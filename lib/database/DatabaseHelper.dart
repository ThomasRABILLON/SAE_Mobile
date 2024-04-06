import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'your_database.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE OBJET (idObj INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT)');
    await db.execute('CREATE TABLE TYPEANNONCES (idType INTEGER PRIMARY KEY AUTOINCREMENT, libelleType TEXT)');
    await db.execute('CREATE TABLE ANNONCES (id VARCHAR(64) PRIMARY KEY, titre TEXT, description TEXT, dateDeb DATETIME, dateFin DATETIME, idEtat, idObj INTEGER NOT NULL, idType INTEGER NOT NULL, FOREIGN KEY (idObj) REFERENCES objet(idObj), FOREIGN KEY (idType) REFERENCES typeAnnonces(idType))');
  }
}