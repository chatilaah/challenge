import 'package:challenge/api/utils/cacheable_api.dart';
import 'package:challenge/api/models/orders.dart';

export 'models/orders.dart';

abstract class Api {
  final bool useSecure;

  Api({this.useSecure = true});

  factory Api.provider() => CacheableApi();

  /// Retrieves orders.
  Future<Orders> orders(int page, int limit);
}
