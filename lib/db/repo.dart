import 'package:challenge/db/utils/local_repo.dart';

abstract class Repo {
  const Repo();

  factory Repo.provider() => LocalRepo();

  bool get isOpening;
  bool get isOpen;
  void close();

  /// Sets an item's favorite state.
  ///
  /// [id] holds the item's ID
  ///
  /// [state] holds the state value of the item
  ///
  /// * If [state] is true, then the favorite icon is highlighted.
  /// Otherwise, it will be outlined instead.
  ///
  Future<int> setFavoriteState(String id, bool state);

  /// Retrieves an item's favorite state.
  ///
  /// [id] holds the item's ID
  ///
  Future<bool> getFavoriteState(String id);
}
