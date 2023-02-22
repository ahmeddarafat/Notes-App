import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class SqlDB {
  static Database? _db;
  Future<Database?> get db async {
    _db ??= await init();
    return _db;
  }

  Future<Database> init() async {
    // indinifiy the path of database in you phone sotrage
    String localDb = await getDatabasesPath();
    String pathDb = p.join(localDb, 'app.db');
    Database appDb = await openDatabase(pathDb,
        version: 3,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        readOnly: false);
    return appDb;
  }

  /// create
  //    - it's executed only one time when initializing the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    create table 'notes' (
      'id' integer not null primary key autoincrement,
      'note' text not null
    )
    ''');
    debugPrint('===============create =============');
  }

  /// upgrade
  //    - it's executed when changing the version of database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("""
    alter table notes add column
      title text
 """);
    debugPrint('============ Upgrad ===========');
  }

  /// select
  Future<List<Map<String, Object?>>> selectAll() async {
    String query = "select * from 'notes'";
    return await _select(query);
  }

  Future<List<Map<String, Object?>>> _select(String query) async {
    Database? mydb = await db;
    List<Map<String, Object?>> data = await mydb!.rawQuery(query);
    return data;
  }

  /// Update
  Future<int> updateNote(String note, String title, int atId) async {
    // - the string variable should be in quotes
    // - the int variable may be in quotes or not
    String query =
        "update 'notes' set note = '$note', title = '$title' where id = $atId";
    return await _update(query);
  }

  Future<int> _update(String query) async {
    Database? mydb = await db;
    return await mydb!.rawUpdate(query);
  }

  /// Insert
  Future<int> insertNote(String note, String title) async {
    // - the value should be in quotes
    // - Throw error, if you put a comma after the last item ex: (item1, item2, item3 ",")
    String query = "insert into notes (note, title) values ('$note','$title')";
    return await _insert(query);
  }

  Future<int> _insert(String query) async {
    Database? mydb = await db;
    // - return int (index of row)
    return await mydb!.rawInsert(query);
  }

  /// Delete
  Future<int> deleteAll() async {
    Database? mydb = await db;
    return await mydb!.delete("notes");
  }

  Future<int> deleteNote(int atId) async {
    String query = "Delete from notes where id = $atId";
    return await _delete(query);
  }

  Future<int> _delete(String query) async {
    Database? mydb = await db;
    // return 1 when deleteing
    //        0 if it dosen't existing
    return await mydb!.rawDelete(query);
  }
}

/// Notes
// - try use static for init database instead of get db property
