import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('patients.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE records (
  id $idType,
  datetime $textType,
  mrn $textType,
  name $textType,
  sex $textType,
  age $integerType,
  complaints $textType,
  past_history $textType,
  medications $textType,
  examination $textType,
  ecg_comment $textType,
  ecg_photo_path $textType,
  echo_type $textType,
  labs $textType,
  recommendations $textType,
  cha2ds2_vasc_score $integerType,
  grace_score $integerType
  )
''');
  }

  Future<int> insertRecord(PatientRecord record) async {
    final db = await instance.database;
    return await db.insert('records', record.toMap());
  }

  Future<List<PatientRecord>> readAllRecords() async {
    final db = await instance.database;
    final orderBy = 'datetime DESC';
    final result = await db.query('records', orderBy: orderBy);

    return result.map((json) => PatientRecord.fromMap(json)).toList();
  }

  Future<int> updateRecord(PatientRecord record) async {
    final db = await instance.database;
    return db.update(
      'records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
