// this is a database helper file. It's main purpose to make
// working with database easy and simple.

import 'dart:io';

import 'package:bookuet/model/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBController {
  // we called a private constructor and make a static instance and a static
  // database so that there will be only one instance and
  // database during the whole execution

  DBController._();

  static final DBController instance = DBController._();
  static Database? _database;

  Future<String> getDatabasePath() async {
    String path = '';
    String dbname = 'bookuet';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$dbname.db';
    return path;
  }

  // this function returns a database. If a database exists then it
  // will return that database, otherwise it will create a new database
  // and return that.
  Future<Database> get database async {
    sqfliteFfiInit();
    if (_database != null) return _database!;

    _database = await _initDB();
    // Set default value to the User Table row.
    // _database!.insert(K.tableNameUser, {
    //   K.colNameUser["currency"]!: "\$",
    //   K.colNameUser["currencyMode"]!: 1,
    // });

    return _database!;
  }

  // this function will create a new database with a table
  // with appropriate column names
  Future<Database> _initDB() async {
    DatabaseFactory dbF = databaseFactoryFfi;
    return await dbF.openDatabase(await getDatabasePath(),
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''CREATE TABLE ${WishListTable.tableName} (
                ${WishListTable.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${WishListTable.colBookId} TEXT NOT NULL,
                ${WishListTable.colTitle} TEXT NOT NULL,
                ${WishListTable.colSubtitle} TEXT NOT NULL,
                ${WishListTable.colAuthors} TEXT NOT NULL,
                ${WishListTable.colImageUrl} TEXT NOT NULL,
                ${WishListTable.colBookUrl} TEXT NOT NULL
              )''');

            // await db.execute('''CREATE TABLE ${TaskTable.name} (
            //     id INTEGER PRIMARY KEY AUTOINCREMENT,
            //     ${TaskTable.colTaskDate} TEXT NOT NULL,
            //     ${TaskTable.colIsChecked} INTEGER NOT NULL,
            //     ${TaskTable.colTaskTitle} TEXT NOT NULL
            //   )''');

            // Demo data For test
            // Write demo data here
          },
        ));
  }

  // this function takes a table name and a map of data to insert to the table
  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<int> update(String tableName, Map<String, dynamic> row,
      {String? where, List<Object?>? whereArgs}) async {
    Database db = await instance.database;
    return await db.update(tableName, row, where: where, whereArgs: whereArgs);
  }

  // this function delete row(s) from the table
  Future<int> delete(String tableName,
      {String? where, List<Object?>? whereArgs}) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  // this function query all data from table that's name passed as a argument
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> query(
    String tableName, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    Database db = await instance.database;
    return await db.query(tableName, where: where, whereArgs: whereArgs);
  }
}
