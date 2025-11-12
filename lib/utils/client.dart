import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:huginn/utils/logger.dart';

/// Protocol constants for Odin server communication
class OdinProtocol {
  static const String scheme = 'odin';
  static const String delimiter = '\t';
  static const int defaultPort = 1866;
  static const String defaultHost = 'localhost';
  static const String defaultPath = '/';

  // Protocol commands
  static const String preflightCommand = 'preflight';
  static const String pullCommand = 'pull';
  static const String protocolPrefix = 'odin';
}

/// Preflight status codes returned by the server
enum PreflightStatus {
  /// Content is ok
  ok('A'),
  /// Content not found
  notFound('B'),
  /// Server error
  serverError('C'),
  /// Client error
  clientError('D');

  const PreflightStatus(this.code);
  final String code;

  static PreflightStatus fromCode(String code) =>
    PreflightStatus.values.firstWhere(
      (status) => status.code == code,
      orElse: () => PreflightStatus.clientError,
    );
}

/// Exception thrown when Odin client operations fail
class OdinClientException implements Exception {
  final String message;
  final String? url;
  final Object? cause;

  OdinClientException(this.message, {this.url, this.cause});

  @override
  String toString() {
    final buffer = StringBuffer('OdinClientException: $message');
    if (url != null) buffer.write(' (url: $url)');
    if (cause != null) buffer.write('\nCaused by: $cause');
    return buffer.toString();
  }
}

/// Configuration for OdinClient
class OdinClientConfig {
  final int port;
  final Duration timeout;
  final Duration connectionTimeout;

  const OdinClientConfig({
    this.port = OdinProtocol.defaultPort,
    this.timeout = const Duration(seconds: 30),
    this.connectionTimeout = const Duration(seconds: 10),
  });
}

/// Client for communicating with Odin protocol servers
///
/// Handles preflight checks and content pulling from Odin servers.
/// Uses tab-delimited protocol over TCP sockets.
///
/// Example:
/// ```dart
/// final client = OdinClient();
/// final status = await client.preflight('odin://localhost/page');
/// if (status == PreflightStatus.ok) {
///   final content = await client.pull('odin://localhost/page');
/// }
/// ```
class OdinClient {
  final OdinClientConfig config;
  final Logger _logger;

  /// Creates an OdinClient with optional configuration
  OdinClient({
    OdinClientConfig? config,
    Logger? logger,
  }) : config = config ?? const OdinClientConfig(),
    _logger = logger ?? Logger('OdinClient');

  /// Parses a URL string into a URI, adding odin:// scheme if missing
  ///
  /// Throws [FormatException] if the URL is invalid
  Uri _parseUrl(String url) {
    if (url.isEmpty) {
      throw const FormatException('URL cannot be empty');
    }

    if (!url.contains('://')) {
      url = '${OdinProtocol.scheme}://$url';
    }

    try {
      return Uri.parse(url);
    } catch (e) {
      throw FormatException('Invalid URL format: $url', e);
    }
  }

  /// Extracts hostname from URI, defaulting to localhost if empty
  String _getHostname(Uri uri) =>
    uri.host.isEmpty ? OdinProtocol.defaultHost : uri.host;

  /// Extracts path from URI, defaulting to / if empty
  String _getPath(Uri uri) =>
    uri.path.isEmpty ? OdinProtocol.defaultPath : uri.path;

  /// Sends a command to the Odin server and returns the response
  ///
  /// Throws [OdinClientException] on connection or communication errors
  Future<String> _sendCommand(
    String hostname,
    String command,
    String path,
  ) async {
    Socket? socket;

    try {
      _logger.fine('Connecting to $hostname:${config.port}');
      socket = await Socket.connect(
        hostname,
        config.port,
        timeout: config.connectionTimeout,
      );

      // Build and send command
      final message = '${OdinProtocol.protocolPrefix}'
        '${OdinProtocol.delimiter}$command'
        '${OdinProtocol.delimiter}$path';

      _logger.fine('Sending command: $message');
      socket.write(message);
      await socket.flush();

      // Wait for response with timeout
      final response = await socket.first.timeout(
        config.timeout,
        onTimeout: () => throw TimeoutException('Server response timeout'),
      );

      final responseStr = utf8.decode(response);
      _logger.fine('Received response: $responseStr');

      return responseStr;
    } on SocketException catch (e) {
      _logger.warning('Socket error: $e');
      throw OdinClientException(
        'Failed to connect to server',
        url: '$hostname:${config.port}',
        cause: e,
      );
    } on TimeoutException catch (e) {
      _logger.warning('Timeout error: $e');
      throw OdinClientException(
        'Server request timed out',
        url: '$hostname:${config.port}',
        cause: e,
      );
    } catch (e) {
      _logger.severe('Unexpected error during command: $e');
      throw OdinClientException(
        'Unexpected error during server communication',
        cause: e,
      );
    } finally {
      // Ensure socket is always closed
      try {
        await socket?.close();
        _logger.fine('Socket closed');
      } catch (e) {
        _logger.warning('Error closing socket: $e');
      }
    }
  }

  /// Performs a preflight check to determine if content needs updating
  ///
  /// Returns [PreflightStatus] indicating content state:
  /// - [PreflightStatus.current] - content is up to date
  /// - [PreflightStatus.dirty] - content needs refresh
  /// - [PreflightStatus.unknown] - error or unknown state
  ///
  /// Returns [PreflightStatus.dirty] on connection errors to trigger refresh
  Future<PreflightStatus> preflight(String url) async {
    try {
      final uri = _parseUrl(url);
      final hostname = _getHostname(uri);
      final path = _getPath(uri);

      final response = await _sendCommand(
        hostname,
        OdinProtocol.preflightCommand,
        path,
      );

      // Parse tab-delimited response
      final parts = response
        .split(OdinProtocol.delimiter)
        .map((s) => s.trim())
        .toList();

      if (parts.length > 1) {
        final status = PreflightStatus.fromCode(parts[1]);
        _logger.info('Preflight for $url: $status');
        return status;
      }

      _logger.warning('Invalid preflight response format: $response');
      return PreflightStatus.serverError;
    } catch (e) {
      _logger.warning('Preflight error for $url: $e');
      // Return client error to trigger content refresh
      return PreflightStatus.clientError;
    }
  }

  /// Pulls content from the Odin server
  ///
  /// Returns the full response string from the server
  ///
  /// Throws [OdinClientException] on connection or communication errors
  Future<String> pull(String url) async {
    try {
      final uri = _parseUrl(url);
      final hostname = _getHostname(uri);
      final path = _getPath(uri);

      final response = await _sendCommand(
        hostname,
        OdinProtocol.pullCommand,
        path,
      );

      _logger.info('Successfully pulled content from $url');
      return response;
    } catch (e) {
      _logger.severe('Pull error for $url: $e');
      if (e is OdinClientException) {
        rethrow;
      }
      throw OdinClientException(
        'Failed to pull content',
        url: url,
        cause: e,
      );
    }
  }

  /// Closes any resources held by the client
  ///
  /// Currently a no-op but provided for future extensibility
  /// (e.g., connection pooling)
  void dispose() {
    _logger.fine('OdinClient disposed');
  }
}
