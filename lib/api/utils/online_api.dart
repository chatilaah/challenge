import 'package:challenge/api/api.dart';
import 'package:challenge/api/utils/http_short.dart';

const String _hostname = '62f4b229ac59075124c1e40b.mockapi.io';

const String _secureHostname = 'https://$_hostname';
const String _unsecureHostname = 'http://$_hostname';

/// An HTTP status code that identifies the current request to be
/// successful.
///
const int kHttpOk = 200;

/// Not to be confused with [kHttpOk], this code is specifically
/// tied to the way how the API was designed to report indicators for
/// success and failures.
///
/// In our case, whenever the API returns a [kApiSuccess] in the [code]
/// variable, it means that we are good to go. Otherwise, we assume it
/// returned an error.
///
const int kApiSuccess = kHttpOk;

class OnlineApi extends Api {
  OnlineApi(bool useSecure) : super(useSecure: useSecure);

  /// Uses the preferred hostname by checking the [useSecure] value.
  ///
  /// * If true, the [_secureHostname] is used.
  /// Otherwise, [_unsecureHostname] is used instead.
  ///
  String get hostname => useSecure ? _secureHostname : _unsecureHostname;

  @override
  Future<Orders> orders(int page, int limit) async {
    final response = await get(url: '$hostname/api/v1/orders', args: {
      'page': page,
      'limit': limit,
    });

    if (response.statusCode != kHttpOk) {
      return Orders.empty(code: response.statusCode);
    }

    return ordersFromJson(response.body);
  }
}
