import 'dart:io';
import 'dart:convert';

class OdinClient {
  static Uri _parseUrl(String url) {
    if (!url.contains('://')) {
      url = 'odin://$url';
    }
    final uri = Uri.parse(url);
    return uri;
  }

  static Future<String> preflight(String url) async {
    final uri = _parseUrl(url);
    final hostname = uri.host.isEmpty || uri.host == '' ? 'localhost' : uri.host;
    final path = uri.path.isEmpty || uri.path == '' ? '/' : uri.path;

    try {
      final socket = await Socket.connect(hostname, 1866);
      
      socket.write('odin\tpreflight\t$path');
      await socket.flush();
      
      final response = await socket.first;
      final responseStr = utf8.decode(response);
      final parts = responseStr.split('\t').map((s) => s.trim()).toList();
      
      await socket.close();
      
      return parts.length > 1 ? parts[1] : 'C';
    } catch (e) {
      print('Preflight error for $url: $e');
      return 'D';
    }
  }

  static Future<String> pull(String url) async {
    final uri = _parseUrl(url);
    final hostname = uri.host.isEmpty || uri.host == '' ? 'localhost' : uri.host;
    final path = uri.path.isEmpty || uri.path == '' ? '/' : uri.path;

    try {
      final socket = await Socket.connect(hostname, 1866);
      
      socket.write('odin\tpull\t$path');
      await socket.flush();
      
      final response = await socket.first;
      final responseStr = utf8.decode(response);
      
      await socket.close();
      
      return responseStr;
    } catch (e) {
      print('Pull error for $url: $e');
      throw Exception('Server request error');
    }
  }
}
