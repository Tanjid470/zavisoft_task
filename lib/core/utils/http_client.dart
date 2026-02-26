import 'package:http/http.dart' as http;
import 'package:pretty_http_logger/pretty_http_logger.dart';

class LoggingHttpClient extends http.BaseClient {
  late final http.Client _innerClient;
  late final HttpLogger _logger;

  LoggingHttpClient() {
    _innerClient = http.Client();
    _logger = HttpLogger(
      logLevel: LogLevel.BODY,
    );
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      return await _innerClient.send(request);
    } catch (e) {
      return await _innerClient.send(request);
    }
  }
}
