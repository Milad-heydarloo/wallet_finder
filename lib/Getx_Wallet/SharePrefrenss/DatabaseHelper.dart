
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  // مقداردهی اولیه دیتابیس
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // ایجاد جداول دیتابیس
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE BotData (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        botUrl TEXT
      )
    ''');
    print('Tables created successfully');
  }

  // ذخیره تنظیمات در جدول settings
  Future<void> saveSetting(String key, String value) async {
    try {
      final db = await database;
      await db.insert(
        'settings',
        {'key': key, 'value': value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Setting saved: key=$key, value=$value');
    } catch (e) {
      print('Error saving setting: $e');
    }
  }

  // بازیابی یک تنظیم از جدول settings
  Future<String?> getSetting(String key) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query(
        'settings',
        where: 'key = ?',
        whereArgs: [key],
      );
      if (result.isNotEmpty) {
        return result.first['value'] as String?;
      }
    } catch (e) {
      print('Error retrieving setting: $e');
    }
    return null;
  }

  // ذخیره URL ربات
  Future<void> saveBotUrl(String botUrl) async {
    try {
      final db = await database;
      await db.insert(
        'BotData',
        {'botUrl': botUrl},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Bot URL saved: $botUrl');
      await printAllBotUrls(); // نمایش همه رکوردها
    } catch (e) {
      print('Error saving Bot URL: $e');
    }
  }

  // بازیابی URL ربات
  Future<String?> getBotUrl() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query('BotData');
      if (result.isNotEmpty) {
        return result.first['botUrl'] as String?;
      }
    } catch (e) {
      print('Error retrieving Bot URL: $e');
    }
    return null;
  }

  // چاپ تمامی URL های ذخیره‌شده
  Future<void> printAllBotUrls() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> result = await db.query('BotData');
      print('All saved bot URLs: $result');
    } catch (e) {
      print('Error printing all Bot URLs: $e');
    }
  }

  // بررسی وجود جداول در دیتابیس
  Future<void> checkTables() async {
    try {
      final db = await database;
      final tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table'"
      );
      print('Tables in database: $tables');
    } catch (e) {
      print('Error checking tables: $e');
    }
  }

  // حذف دیتابیس (برای تست)
  Future<void> deleteDatabaseFile() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'app.db');
      await deleteDatabase(path);
      print('Database deleted successfully');
    } catch (e) {
      print('Error deleting database: $e');
    }
  }
}
