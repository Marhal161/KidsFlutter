import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Получаем путь к базе данных
    String path = join(await getDatabasesPath(), 'database.db');
    
    // Проверяем, существует ли база данных
    bool exists = await databaseExists(path);
    
    if (!exists) {
      // Если базы данных нет, копируем её из assets
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load(join('assets', 'database.db'));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print('Ошибка при копировании базы данных: $e');
      }
    }
    
    // Открываем базу данных
    return await openDatabase(path, readOnly: true);
  }

  // Получить все буквы
  Future<List<Map<String, dynamic>>> getAllLetters() async {
    final db = await database;
    return await db.query('alphabet', orderBy: 'letter');
  }

  // Получить конкретную букву
  Future<Map<String, dynamic>?> getLetter(String letter) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'alphabet',
      where: 'letter = ?',
      whereArgs: [letter],
    );
    return results.isNotEmpty ? results.first : null;
  }
}