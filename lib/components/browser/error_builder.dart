import 'constants.dart';

/// Builds error content in the tab-separated format expected by the parser
class ErrorBuilder {
  /// Build error content for a specific error type
  static String buildError(String errorCode, String errorMessage) =>
    't\t$errorCode\nh1\t$errorCode\np\t$errorMessage';

  /// Build error content for "File not found" (Error B)
  static String buildNotFoundError() => buildError(
    BrowserConstants.errorCodeB,
    BrowserConstants.errorNotFound,
  );

  /// Build error content for "Malformed request" (Error C)
  static String buildMalformedError() => buildError(
    BrowserConstants.errorCodeC,
    BrowserConstants.errorMalformed,
  );

  /// Build error content for "Server request error" (Error D)
  static String buildServerError() => buildError(
    BrowserConstants.errorCodeD,
    BrowserConstants.errorServer,
  );
}
