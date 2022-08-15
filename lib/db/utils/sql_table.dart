import 'package:flutter/material.dart';

abstract class SqlTable<T> {
  /// Internally creates a select query with parameters.
  ///
  @protected
  static String internalSelect(String tableName,
      {Map<String, Object?> values = const {}}) {
    var raw = 'select * from $tableName';

    if (values.isNotEmpty) {
      raw += ' where ';

      for (int i = 0; i < values.length; i++) {
        final v = values.entries.elementAt(i);

        final query = '${v.key} = ${v.value}';
        raw += (i != values.length - 1) ? '$query and' : query;
      }
    }

    return raw;
  }

  /// Creates a select query with parameters.
  ///
  String selectQuery({Map<String, Object?> where = const {}});

  /// Converts a class to a [Map] object.
  ///
  Map<String, Object?> toValues();
}
