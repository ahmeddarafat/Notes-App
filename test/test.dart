import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class SqlDB {
  /// Setup Database
  Database? db; // = init()
  Future<Database> init() async {
    // indinifiy the path of database in you phone sotrage
    String localDb = await getDatabasesPath();
    String pathDb = p.join(localDb, 'app.db');

    Database appDb = await openDatabase(
      pathDb, // path
      version: 3,

      // - it's executed only one time when initializing the database
      // - {FutureOr<void> Function(Database, int)? onCreate}
      onCreate: _onCreate,

      // - it's executed when changing the version of database
      // - {FutureOr<void> Function(Database, int, int)? onUpgrade}
      onUpgrade: _onUpgrade,

      // - it's executed every time you open the database
      // - {FutureOr<void> Function(Database)? onOpen}
      onOpen: (db) {},

      readOnly: false,
      singleInstance: true,
    );
    return appDb;
  }

  /// onCreate
  Future<void> _onCreate(Database db, int version) async {
    /// execute
    //    - Execute an SQL query with no return value
    //    - a mehtod in databaseExecuter abstract class
    //    - Future<void> execute(String sql, [List<Object?>? arguments]);
    await db.execute("""create table 'notes' ('id' integer,'note' text)""");
  }

  /// upgrade
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    /// Batch
    //    - Creates a batch, used for performing multiple operation in a single atomic operation.
    //    - Batch is abstract class doing the same as databaseExecuter abstract class
    Batch batch = db.batch();
    batch.execute("""alter table notes add columntitle text""");
    batch.execute("""alter table notes add columntitle text""");
    batch.execute("""alter table notes add columntitle text""");

    //   - Commits all of the operations in this batch as a single atomic unit
    batch.commit();
  }

  /// select
  //    - There are 2 ways "2 methods in databaseExecuter abstract class"
  //        1. rawQuery method
  //        2. query method
  select() async {
    /// 1. rawQuery
    //     - Executes a raw SQL SELECT query and returns a list of the rows that were found.
    //     - Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments])
    var data = await db!.rawQuery("select * from table");

    /// 2. query
    //       - This is a helper to rawQuery
    //       -  Future<List<Map<String, Object?>>> query(
    //              String table, {
    //              bool? distinct,
    //              List<String>? columns,
    //              String? where,
    //              List<Object?>? whereArgs,
    //              String? groupBy,
    //              String? having,
    //              String? orderBy,
    //              int? limit,
    //              int? offset,
    //          })
    var data2 = await db!.query("table");
  }

  /// Update
  //    - There are 2 ways "2 methods in databaseExecuter abstract class"
  //        1. rawUpdate method
  //        2. query method
  update() {
    /// 1. rawUpdate
    //     - Executes a raw SQL UPDATE query and returns the number of changes made.
    //     - Future<int> rawUpdate(String sql, [List<Object?>? arguments])
    var data1 = db!.rawUpdate(
        "'UPDATE Test SET name = 'test', value = test' WHERE name = 'test'");

    /// 2. update
    //       - This is a helper to rawUpdate
    //       -  Future<int> update(
    //              String table,
    //              Map<String, Object?> values, {
    //              String? where,
    //              List<Object?>? whereArgs,
    //              ConflictAlgorithm? conflictAlgorithm,
    //          })
    var data2 = db!.update("table", {});
  }

  /// Insert
  //    - There are 2 ways "2 methods in databaseExecuter abstract class"
  //        1. rawInsert method
  //        2. insert method
  insert() {
    /// 1. rawUpdate
    //     - Executes a raw SQL INSERT query and returns the last inserted row ID.
    //     - Future<int> rawInsert(String sql, [List<Object?>? arguments])
    var data1 = db!.rawInsert('INSERT INTO Test(name, value) VALUES("some name", 12)');

    /// 2. update
    //       - This is a helper to rawDelete
    //       -  Future<int> insert(
    //            String table,
    //            Map<String, Object?> values, {
    //            String? nullColumnHack,
    //            ConflictAlgorithm? conflictAlgorithm,
    //          })
    var data2 = db!.insert("table",{});
  }

  /// Delete
  //    - There are 2 ways "2 methods in databaseExecuter abstract class"
  //        1. rawDelete method
  //        2. delete method
  delete() {
    /// 1. rawUpdate
    //     - Executes a raw SQL DELETE query and returns the number of changes made.
    //     - Future<int> rawDelete(String sql, [List<Object?>? arguments])
    var data1 = db!.rawDelete("DELETE FROM Test WHERE name = 'test'");

    /// 2. update
    //       - This is a helper to rawDelete
    //       -  Future<int> delete(
    //              String table, {
    //              String? where,
    //              List<Object?>? whereArgs,
    //          })
    var data2 = db!.delete("table");

  }
}
