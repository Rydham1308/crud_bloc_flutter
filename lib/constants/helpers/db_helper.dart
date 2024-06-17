import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_crud/constants/helpers/database_constant.dart';

class DbHelper {
  static late Database _db;

  Future<void> initializeDb(String dbPath) async {
    final path = join(dbPath, DatabaseConstant.dbName);
    _db = await openDatabase(path);
  }

  /// returns true if table exists
  Future<bool> checkTable(String tableName) async {
    final exist = await _db.rawQuery("SELECT * FROM sqlite_master WHERE name ='$tableName' and type='table'");
    if (exist.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isTableEmpty(String tableName) async {
    final data = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $tableName'));
    if (data == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<Unit> executeTable(String tableName, String additionalData) async {
    await _db.execute('create table $tableName ($additionalData)');
    return unit;
  }

  /// returns false if not exists
  Future<bool> checkExisting(String tableName, String columnName, String value) async {
    final result = await _db.rawQuery('SELECT * FROM $tableName WHERE $columnName="$value"');
    return result.isNotEmpty;
  }

  Future<int> insertTable(String tableName, Map<String, dynamic> insertQuery) async {
    return _db.insert(
      tableName,
      insertQuery,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Unit> batchInsert(String tableName, List<dynamic> objectList) async {
    final batch = _db.batch();
    objectList
        .map(
          (e) => batch.insert(
        tableName,
        conflictAlgorithm: ConflictAlgorithm.replace,
        (e ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    )
        .toList();
    await batch.commit(noResult: true);
    return unit;
  }

  Future<List<Map<String, Object?>>> fetchDataFromDb(
      String tableName, {
        List<String>? columns,
        String? where,
        int? limit,
        String? groupBy,
        List<dynamic>? whereArgs,
      }) async {
    return _db.query(tableName,
      columns: columns,
      where: (where?.isNotEmpty ?? false) ? '$where = ?' : null,
      whereArgs: whereArgs,
      limit: limit,
      groupBy: groupBy,);
  }

  Future<int> deleteFromDb(String tableName, {String? where, List<dynamic>? whereArgs}) async {
    return _db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> updateFromDb(String tableName, Map<String, dynamic> updateValue, {String? where, List<dynamic>? whereArgs}) async {
    return _db.update(tableName, updateValue, where: '$where = ?', whereArgs: whereArgs);
  }

  Future<int> deleteAllEntriesFromTable(
      String tableName,
      ) async {
    return _db.rawDelete('DELETE FROM $tableName');
  }


  Future<Unit> checkAndInitializeTable() async {
    if (!await checkTable(DatabaseConstant.todoTable)) {
      await executeTable(DatabaseConstant.todoTable, DatabaseConstant.sqlForCreateTodoTable);
    }
    return unit;
  }
}
