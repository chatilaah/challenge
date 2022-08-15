import 'package:challenge/api/api.dart';
import 'package:challenge/api/utils/cacheable_item.dart';

String getMockfileByName(String name) => 'assets/mock/$name.json';

class OfflineApi extends Api {
  CacheableItem? _item;

  OfflineApi();

  /// Sets the [CacheableItem] object to be used when retrieving
  /// a cached object.
  ///
  /// * Important: Setting the [cacheableItem] is important prior
  /// to calling any API call. Otherwise, all returned values will
  /// be empty.
  ///
  set cacheableItem(CacheableItem newValue) => _item = newValue;

  @override
  Future<Orders> orders(int page, int limit) async {
    final cachedObject = await _item?.getCachedObject();
    if (cachedObject == null) return Orders.empty();

    final orders = Orders.fromJson(cachedObject.data);
    orders.offline = true;

    return orders;
  }
}
