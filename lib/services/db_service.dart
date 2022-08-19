import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_offline/models/test_model.dart';

class DBProvider {
  static dynamic _database;

  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'Test.db');

    return await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE Test(
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            image TEXT,
            date TEXT
          );
        ''');
    });
  }

  Future<int> newTest(TestModel newTest) async {
    final db = await database;

    final response = await db.insert('Test', newTest.toMap());

    return response;
  }

  Future<List<TestModel>?> getAllTest() async {
    final db = await database;
    final response = await db.query('Test');

    return response.isNotEmpty
        ? response.map((e) => TestModel.fromMap(e)).toList()
        : [];
  }

  Future<int> deleteTest(int id) async {
    final db = await database;
    final res = await db.delete('Test', where: 'id=?', whereArgs: [id]);
    return res;
  }

  Future<int> updateTest(TestModel nuevoTest) async {
    final db = await database;
    final res = await db.update('Test', nuevoTest.toMap(),
        where: 'id=?', whereArgs: [nuevoTest.id]);

    return res;
  }
}
