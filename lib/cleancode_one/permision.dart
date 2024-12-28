import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// کلاس پایگاه داده برای ذخیره وضعیت مجوزها
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

// اپلیکیشن اصلی
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متغیر برای ذخیره وضعیت مجوزها
  bool isBatteryPermissionGranted = false;
  bool isWakeLockPermissionGranted = false;

  final dbHelper = DatabaseHelper_Permission(); // شیء از DatabaseHelper_Permission

  @override
  void initState() {
    super.initState();
    startServiceWithPermissions();
  }

  // متد اصلی برای هندل کردن مجوزها و شروع سرویس
  Future<void> startServiceWithPermissions() async {
    // درخواست مجوزها
    await requestPermissions();
  }

  // درخواست مجوزها
  Future<void> requestPermissions() async {
    // خواندن وضعیت مجوزها از پایگاه داده
    isBatteryPermissionGranted = await dbHelper.getPermissionStatus("Battery Optimization");
    isWakeLockPermissionGranted = await dbHelper.getPermissionStatus("Wake Lock");

    // درخواست برای Ignore Battery Optimizations
    if (!isBatteryPermissionGranted) {
      final batteryPermission = await Permission.ignoreBatteryOptimizations.request();
      if (batteryPermission.isGranted) {
        isBatteryPermissionGranted = true;
        await dbHelper.savePermission("Battery Optimization", true);
        print("Battery optimization permission granted.");
      } else {
        print("Battery optimization permission denied.");
        promptUserToGrantPermission(
          "مجوز بهینه‌سازی باتری",
          "برای اطمینان از اجرای صحیح برنامه در پس‌زمینه، لطفاً مجوز بهینه‌سازی باتری را فعال کنید.",
          Permission.ignoreBatteryOptimizations,

        );
      }
    }

    // درخواست برای Wake Lock
    if (!isWakeLockPermissionGranted) {
      final wakeLockPermission = await Permission.systemAlertWindow.request();
      if (wakeLockPermission.isGranted) {
        isWakeLockPermissionGranted = true;
        await dbHelper.savePermission("Wake Lock", true);
        print("Wake lock permission granted.");
      } else {
        print("Wake lock permission denied.");
        promptUserToGrantPermission(
          "مجوز قفل بیداری",
          "برای حفظ اجرای برنامه در پس‌زمینه، لطفاً مجوز قفل بیداری را فعال کنید.",
          Permission.systemAlertWindow,

        );
      }
    }
  }

  // هدایت کاربر به صفحه تنظیمات یا نمایش پیام
  void promptUserToGrantPermission(
      String permissionName, String message, Permission permission) {
    print("Prompting user for permission: $permissionName");

    // نمایش یک دیالوگ برای توضیح دلیل نیاز به مجوز
    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: Text("نیاز به مجوز"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // دیالوگ بسته می‌شود و هیچ عملی انجام نمی‌شود
            },
            child: Text("باشه"),
          ),
          TextButton(
            onPressed: () async {
              // درخواست مجدد مجوز از کاربر در همان دیالوگ
              final status = await permission.request();
              if (status.isGranted) {
                print("$permissionName مجوز تایید شد.");
                // وضعیت مجوز را به true تغییر بده
                if (permission == Permission.ignoreBatteryOptimizations) {
                  setState(() {
                    isBatteryPermissionGranted = true;
                  });
                  await dbHelper.savePermission("Battery Optimization", true);
                } else if (permission == Permission.systemAlertWindow) {
                  setState(() {
                    isWakeLockPermissionGranted = true;
                  });
                  await dbHelper.savePermission("Wake Lock", true);
                }
              } else {
                print("$permissionName مجوز تایید نشد.");
              }
              Navigator.of(context).pop(); // دیالوگ بسته می‌شود
            },
            child: Text("تایید مجوز"),
          ),
        ],
      ),
    );
  }

  // شروع سرویس اصلی
  void startService() {
    print("Service is now running...");
    // در اینجا می‌توانید کد سرویس اصلی را اضافه کنید
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Permission Handler Example"),
      ),
      body: Center(
        child: Text(
          "Handling Permissions in Flutter",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
