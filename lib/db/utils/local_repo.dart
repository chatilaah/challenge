import 'package:challenge/db/repo.dart';
import 'package:challenge/db/utils/migration_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:challenge/db/models/item.dart' as dbitem;

class LocalRepo extends Repo {
  Database? _handle;
  bool _openProgress = true;

  LocalRepo() {
    openDatabase('app.db',
        onUpgrade: ((db, oldVersion, newVersion) {
          // do nothing...
        }),
        version: kVersion_1_00,
        onCreate: ((db, version) async {
          await db.execute(dbitem.createQuery);
        })).then((value) {
      _handle = value;
      _openProgress = false;
    });
  }

  /// On initialize, we are raising the indicator that the open
  /// is currently in progress. Once loaded, this value will be set to false
  /// and will never be reset unless the instance of [LocalRepo] is re-allocated.
  ///
  @override
  bool get isOpening => _openProgress;

  /// Tell if the database is open, returns false once close has been called
  @override
  bool get isOpen => _handle?.isOpen ?? false;

  /// Close the database. Cannot be accessed anymore
  @override
  void close() => _handle?.close();

  @override
  Future<int> setFavoriteState(String id, bool state) async {
    if (_handle == null) throw NullThrownError();

    final item = dbitem.Item(id: id, state: state);

    final query = item.selectQuery(where: {dbitem.columnId: id});
    final data = await _handle!.rawQuery(query);

    if (data.isEmpty) {
      return Future.value(_handle?.insert(dbitem.tableName, item.toValues()));
    }

    assert(data.length == 1, 'entry should appear only once!');

    return Future.value(_handle?.update(dbitem.tableName, item.toValues(),
        where: '${dbitem.columnId} = ?', whereArgs: [id]));
  }

  @override
  Future<bool> getFavoriteState(String id) async {
    if (_handle == null) throw NullThrownError();

    final item = dbitem.Item(id: id);

    final query = item.selectQuery(where: {dbitem.columnId: id});
    final data = await _handle!.rawQuery(query);

    if (data.isEmpty) {
      return false;
    }

    assert(data.length == 1, 'entry should appear only once!');

    return dbitem.Item.fromValues(data.first).state;
  }
}
