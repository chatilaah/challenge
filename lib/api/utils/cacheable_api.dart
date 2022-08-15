import 'dart:io';

import 'package:challenge/api/api.dart';
import 'package:challenge/api/utils/cacheable_item.dart';
import 'package:challenge/api/utils/cacheable_util.dart';
import 'package:challenge/api/utils/offline_api.dart';
import 'package:challenge/api/utils/online_api.dart';
import 'package:flutter/services.dart';

class CacheableApi extends Api with CacheableUtil {
  final _offlineApi = OfflineApi();
  late Object _lastError;

  /// Gets the last exception that occurred.
  Object get lastError => _lastError;

  @override
  Future<Orders> orders(int page, int limit) async {
    final item = CacheableItem(internalName: 'orders_$page&$limit');

    try {
      // final body =
      //     await rootBundle.loadString(getMockfileByName('orders_response'));
      // final online = ordersFromJson(body);

      final online = await OnlineApi(useSecure).orders(page, limit);
      if (online.code == kApiSuccess) {
        await item.preserveCacheObject(online);
        return online;
      }
    } catch (e) {
      if ((_lastError = e) is! SocketException) {
        rethrow;
      }

      // We are throwing an exception if parsing failed.
      // If it's the case, then we need to fix our parsing
      // function and try again harder...
    }

    _offlineApi.cacheableItem = item;
    final offline = await _offlineApi.orders(page, limit);

    if (offline.data.isNotEmpty) {
      return offline;
    }

    throw lastError;
  }
}
