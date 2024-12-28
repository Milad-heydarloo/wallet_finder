

import 'package:sqlite3/sqlite3.dart';
import 'package:wallet_finder/cleancode_one/Database/DataBaseWallet/base/DatabaseRepository.dart';

import '../../../Model/ItemEntity.dart';
import '../../../Model/MachineEntity.dart';



class DatabaseRepositoryImpl implements DatabaseRepository {
  late final Database _database;

  DatabaseRepositoryImpl() {
    _database = sqlite3.open('machine.db');
    _initializeDatabase();
  }

  void _initializeDatabase() {
    _database.execute('''
      CREATE TABLE IF NOT EXISTS Machines(
        id TEXT PRIMARY KEY,
        name TEXT,
        memonic TEXT
      )
    ''');
    _database.execute('''
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

  @override
  // متد برای دریافت اطلاعات ماشین با استفاده از machine.id
  Future<MachineEntity?> getMachineById(String machineId) async {
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

  @override
  Future<void> insertMachine(MachineEntity machine) async {
    // وارد کردن اطلاعات ماشین
    _database.execute('''
      INSERT OR REPLACE INTO Machines (id, name, memonic) VALUES (?, ?, ?)
    ''', [machine.id, machine.name, machine.memonic]);

    // وارد کردن آیتم‌ها برای ماشین
    for (var item in machine.items) {
      _database.execute('''
        INSERT OR REPLACE INTO Items (machineId, name, code) VALUES (?, ?, ?)
      ''', [machine.id, item.name, item.code]);
    }
  }

  @override
  Future<List<MachineEntity>> getMachineEntitiesWithoutPriceAndColor() async {
    final machineResult = _database.select('SELECT * FROM Machines');
    final machines = <MachineEntity>[];

    for (var machineRow in machineResult) {
      final machineId = machineRow['id'] as String;

      // دریافت آیتم‌های ماشین بدون قیمت و رنگ
      final itemResult = _database
          .select('SELECT * FROM Items WHERE machineId = ?', [machineId]);

      final items = itemResult.map((itemRow) {
        return ItemEntity(
          name: itemRow['name'],
          code: itemRow['code'],
        );
      }).toList();

      machines.add(MachineEntity(
        id: machineRow['id'],
        name: machineRow['name'],
        memonic: machineRow['memonic'],
        items: items,
      ));
    }

    return machines;
  }

  @override
  Future<void> updateItemPriceAndColor(
      String machineId, List<ItemEntity> items) async {
    for (var item in items) {
      _database.execute('''
        UPDATE Items
        SET price = ?, color = ?
        WHERE machineId = ? AND name = ?
      ''', [item.price, item.color, machineId, item.name]);
    }
  }

  @override
  Future<void> deleteMachine(String machineId) async {
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
