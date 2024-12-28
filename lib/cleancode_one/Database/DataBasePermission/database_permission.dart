import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper_Permission {
  static Database? _database;

  // نام جدول
  static const String tableName = 'permissions';

  // نام پایگاه داده
  static const String dbName = 'permissions.db';

  // ستون‌های جدول
  static const String columnId = 'id';
  static const String columnPermission = 'permission';
  static const String columnGranted = 'granted';

  // دریافت یا ایجاد پایگاه داده
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // ایجاد پایگاه داده
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableName (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnPermission TEXT,
          $columnGranted INTEGER
        )
      ''');
    });
  }

  // ذخیره وضعیت مجوز
  Future<void> savePermission(String permission, bool granted) async {
    final db = await database;
    await db.insert(
      tableName,
      {
        columnPermission: permission,
        columnGranted: granted ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // خواندن وضعیت مجوز
  Future<bool> getPermissionStatus(String permission) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: '$columnPermission = ?',
      whereArgs: [permission],
    );
    if (result.isNotEmpty) {
      return result.first[columnGranted] == 1;
    }
    return false; // اگر مجوز یافت نشد، به‌طور پیش‌فرض آن را رد شده در نظر می‌گیریم
  }
}
