

import 'package:sqlite3/sqlite3.dart';
import 'package:wallet_finder/cleancode_one/Database/DataBaseWallet/view/DatabaseRepositoryView.dart';

import 'package:wallet_finder/cleancode_one/Model/ItemEntity.dart';


import '../../../Model/MachineEntity.dart';



class DatabaseRepositoryImplView extends DatabaseRepositoryView {
  late Database _database;

  // متد برای دریافت اطلاعات ماشین با استفاده از machine.id
  Future<MachineEntity?> getMachineById(String machineId) async {
    await _initializeDatabase();

    // دریافت اطلاعات ماشین با استفاده از machineId
    final machineResult =
    _database.select('SELECT * FROM Machines WHERE id = ?', [machineId]);

    // اگر ماشین یافت شد
    if (machineResult.isNotEmpty) {
      final machineRow = machineResult.first;

      // دریافت آیتم‌های ماشین
      final itemResult = _database
          .select('SELECT * FROM Items WHERE machineId = ?', [machineId]);

      // تبدیل آیتم‌ها به یک لیست از ItemEntity
      final items = itemResult.map((itemRow) {
        return ItemEntity(
          name: itemRow['name'],
          code: itemRow['code'],
          price: itemRow['price'],
          color: itemRow['color'],
        );
      }).toList();

      // ساخت شیء MachineEntity و بازگرداندن آن
      return MachineEntity(
        id: machineRow['id'],
        name: machineRow['name'],
        memonic: machineRow['memonic'],
        items: items,
      );
    }

    // اگر ماشین با این id پیدا نشد، مقدار null برمی‌گردانیم
    return null;
  }

// متد برای حذف تمام داده‌ها از دیتابیس view
  Future<void> clearViewDatabase() async {
    await _initializeDatabase();

    // حذف تمام داده‌ها از جدول Items
    _database.execute('DELETE FROM Items');

    // حذف تمام داده‌ها از جدول Machines
    _database.execute('DELETE FROM Machines');

    print('All data has been cleared from the view database.');
  }

  // ایجاد دیتابیس و جداول
  Future<void> _initializeDatabase() async {
    final db = sqlite3.open('machineview.db');
    _database = db;

    // ایجاد جداول در دیتابیس جدید
    db.execute('''
      CREATE TABLE IF NOT EXISTS Machines(
        id TEXT PRIMARY KEY,
        name TEXT,
        memonic TEXT
      )
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS Items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        machineId TEXT,
        name TEXT,
        code TEXT,
        price REAL,
        color TEXT,
        FOREIGN KEY (machineId) REFERENCES Machines(id)
      )
    ''');
  }

  // متدی برای وارد کردن داده‌های ماشین و آیتم‌ها به‌صورت یکجا
  @override
  Future<void> insertMachine(MachineEntity machine) async {
    await _initializeDatabase();

    // شروع تراکنش با اجرای دستور BEGIN TRANSACTION
    _database.execute('BEGIN TRANSACTION');

    try {
      // وارد کردن اطلاعات ماشین به دیتابیس
      _database.execute('''
        INSERT OR REPLACE INTO Machines (id, name, memonic) VALUES (?, ?, ?)
      ''', [machine.id, machine.name, machine.memonic]);

      // وارد کردن آیتم‌ها برای ماشین
      for (var item in machine.items) {
        _database.execute('''
          INSERT OR REPLACE INTO Items (machineId, name, code, price, color) VALUES (?, ?, ?, ?, ?)
        ''', [machine.id, item.name, item.code, item.price, item.color]);
      }

      // در صورت موفقیت، اعمال تراکنش
      _database.execute('COMMIT');
    } catch (e) {
      // در صورت خطا، برگرداندن تراکنش
      _database.execute('ROLLBACK');
      print('Error inserting machine data: $e');
    }
  }

  // متدی برای وارد کردن داده‌های آپدیت شده به دیتابیس جدید
  Future<void> insertUpdatedMachineData(List<MachineEntity> machines) async {
    await _initializeDatabase();

    // شروع تراکنش با اجرای دستور BEGIN TRANSACTION
    _database.execute('BEGIN TRANSACTION');

    try {
      for (var machine in machines) {
        // وارد کردن ماشین به دیتابیس جدید
        _database.execute('''
          INSERT OR REPLACE INTO Machines (id, name, memonic) VALUES (?, ?, ?)
        ''', [machine.id, machine.name, machine.memonic]);

        // وارد کردن آیتم‌ها با قیمت و رنگ به‌روزرسانی شده به دیتابیس جدید
        for (var item in machine.items) {
          _database.execute('''
            INSERT OR REPLACE INTO Items (machineId, name, code, price, color) VALUES (?, ?, ?, ?, ?)
          ''', [machine.id, item.name, item.code, item.price, item.color]);
        }
      }

      // در صورت موفقیت، اعمال تراکنش
      _database.execute('COMMIT');
    } catch (e) {
      // در صورت خطا، برگرداندن تراکنش
      _database.execute('ROLLBACK');
      print('Error inserting updated machine data: $e');
    }
  }

  // سایر متدها
  @override
  Future<void> deleteMachine(String machineId) async {
    await _initializeDatabase();

    // حذف آیتم‌ها مربوط به ماشین
    _database.execute('''
      DELETE FROM Items WHERE machineId = ?
    ''', [machineId]);

    // حذف ماشین
    _database.execute('''
      DELETE FROM Machines WHERE id = ?
    ''', [machineId]);
  }

  @override
  Future<List<MachineEntity>> getMachineWithItems() async {
    await _initializeDatabase();

    final machineResult = _database.select('SELECT * FROM Machines');
    final machines = <MachineEntity>[];

    for (var machineRow in machineResult) {
      final machineId = machineRow['id'] as String;

      // دریافت آیتم‌ها برای هر ماشین
      final itemResult = _database
          .select('SELECT * FROM Items WHERE machineId = ?', [machineId]);

      // تبدیل نتایج آیتم‌ها به یک لیست از ItemEntity
      final items = itemResult.map((itemRow) {
        return ItemEntity(
          name: itemRow['name'],
          code: itemRow['code'],
          price: itemRow['price'],
          color: itemRow['color'],
        );
      }).toList();

      // ساخت شیء MachineEntity و اضافه کردن آن به لیست
      machines.add(MachineEntity(
        id: machineRow['id'],
        name: machineRow['name'],
        memonic: machineRow['memonic'],
        items: items,
      ));
    }

    return machines;
  }
}
