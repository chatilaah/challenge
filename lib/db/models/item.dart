import 'package:challenge/db/utils/primitive_values.dart';
import 'package:challenge/db/utils/sql_table.dart';

const String tableName = 'item';
const String createQuery =
    'CREATE TABLE \'$tableName\' ($columnId TEXT PRIMARY KEY, $columnState INTEGER)';

const String columnId = 'id';
const String columnState = 'state';

class Item implements SqlTable<Item> {
  final String id;
  final bool state;

  Item({required this.id, this.state = false});

  factory Item.fromValues(Map<String, Object?> map) => Item(
        id: map[columnId] as String,
        state: (map[columnState] as int) == kTrue,
      );

  @override
  Map<String, Object?> toValues() => {
        columnId: id,
        columnState: state ? kTrue : kFalse,
      };

  @override
  String selectQuery({Map<String, Object?> where = const {}}) =>
      SqlTable.internalSelect(tableName, values: where);
}
