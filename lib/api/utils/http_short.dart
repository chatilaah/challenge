import 'dart:convert';

import 'package:http/http.dart' as http;

/// Performs an HTTP Post operation.
///
/// The [body] parameter will be converted into a JSON string.
///
Future<http.Response> post({required String url, Map? body}) async {
  var json = jsonEncode(body ?? '');

  return http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json,
  );
}

///
/// Performs an HTTP Get operation.
///
/// The [args] parameter will be converted into a valid URL string.
///
Future<http.Response> get(
    {required String url, Map<String, Object> args = const {}}) {
  var newUrl = url;

  for (int i = 0; i < args.length; i++) {
    final entry = args.entries.elementAt(i);
    final param = '${entry.key}=${entry.value}';

    newUrl += (i == 0) ? '?$param' : '&$param';
  }

  return http.get(Uri.parse(newUrl), headers: {});
}
