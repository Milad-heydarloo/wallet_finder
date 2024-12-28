import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// View
import 'package:flutter/material.dart';
// Data Models


abstract class DatabaseServiceMachine {
  Future<void> insertMachine(MachineEntity machine);
  Future<List<MachineEntity>> getMachines();
  Future<void> updateItems(String machineName, List<ItemEntity> items);
  Future<void> updateItem(String machineName, ItemEntity item);
  Future<void> deleteMachine(String machineId); // حذف ماشین
}

class MachineDatabaseService extends DatabaseServiceMachine {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'machine_db_with_delete.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE Machines (
          id TEXT PRIMARY KEY,
          name TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE Items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          machineId TEXT,
          name TEXT,
          code TEXT,
          price REAL,
          color TEXT,
          FOREIGN KEY (machineId) REFERENCES Machines (id)
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Code to upgrade database schema if needed
        }
      },
    );
  }

  @override
  Future<void> insertMachine(MachineEntity machine) async {
    final db = await database;

    // ذخیره ماشین
    await db.insert('Machines', {'id': machine.id, 'name': machine.name});

    // ذخیره آیتم‌ها
    for (var item in machine.items) {
      await db.insert('Items', {
        'machineId': machine.id,
        'name': item.name,
        'code': item.code,
        'price': item.price,
        'color': item.color,
      });
    }
  }

  @override
  Future<List<MachineEntity>> getMachines() async {
    final db = await database;
    final machineRows = await db.query('Machines');
    final List<MachineEntity> machines = [];

    // دریافت آیتم‌ها برای هر ماشین
    for (var machineRow in machineRows) {
      final items = await db.query('Items', where: 'machineId = ?', whereArgs: [machineRow['id']]);

      final machineItems = items.map((item) => ItemEntity(
        name: item['name'] as String,
        code: item['code'] as String,
        price: item['price'] as int,
        color: item['color'] as String,
      )).toList();

      machines.add(MachineEntity(
        id: machineRow['id'] as String,
        name: machineRow['name'] as String,
        items: machineItems,
      ));
    }

    return machines;
  }

  @override
  Future<void> updateItems(String machineName, List<ItemEntity> items) async {
    final db = await database;

    // دریافت ID ماشین بر اساس نام
    final machineQuery = await db.query(
      'Machines',
      where: 'name = ?',
      whereArgs: [machineName],
    );

    if (machineQuery.isEmpty) {
      throw Exception('Machine with name $machineName not found.');
    }

    final machineId = machineQuery.first['id'] as String;

    // به‌روزرسانی هر آیتم
    for (final item in items) {
      await db.update(
        'Items',
        {'price': item.price, 'color': item.color},
        where: 'machineId = ? AND name = ? AND code = ?',
        whereArgs: [machineId, item.name, item.code],
      );
    }
  }

  @override
  Future<void> updateItem(String machineName, ItemEntity item) async {
    await updateItems(machineName, [item]);
  }

  // متد حذف ماشین با تمامی آیتم‌های مربوطه
  @override
  Future<void> deleteMachine(String machineId) async {
    final db = await database;

    // ابتدا حذف آیتم‌ها از جدول Items
    await db.delete(
      'Items',
      where: 'machineId = ?',
      whereArgs: [machineId],
    );

    // سپس حذف ماشین از جدول Machines
    await db.delete(
      'Machines',
      where: 'id = ?',
      whereArgs: [machineId],
    );
  }
}



abstract class Entity {}

class MachineEntity extends Entity {
  final String id;
  final String name;
  final List<ItemEntity> items;

  MachineEntity({
    required this.id,
    required this.name,
    required this.items,
  });

}

class ItemEntity extends Entity {
  final String name;
  final String code;
  final int price;
  String color;

  ItemEntity({
    required this.name,
    required this.code,
    this.price = 0,  // Default value if not provided
    this.color = '', // Default empty string if not provided
  });

}


// Database Helper
abstract class DatabaseService {
  Future<void> insertMachine(MachineEntity machine);
  Future<List<MachineEntity>> getMachines();
  Future<void> updateItems(String machineName, List<ItemEntity> items);
  Future<void> updateItem(String machineName, ItemEntity item);
}

class SQLiteDatabaseService extends DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'machines.db');

    return await openDatabase(
      path,
      version: 2,  // Increment the version to trigger onUpgrade
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE Machines (
          id TEXT PRIMARY KEY,
          name TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE Items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          machineId TEXT,
          name TEXT,
          code TEXT,
          FOREIGN KEY (machineId) REFERENCES Machines (id)
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // This block will run when upgrading from version 1 to 2
          await db.execute('''
          ALTER TABLE Items ADD COLUMN code TEXT;
        ''');
        }
      },
    );
  }


  @override
  Future<void> insertMachine(MachineEntity machine) async {
    final db = await database;

    // ذخیره ماشین
    await db.insert('Machines', {'id': machine.id, 'name': machine.name});

    // ذخیره آیتم‌ها (نام، شناسه ماشین، و کد)
    for (var item in machine.items) {
      await db.insert('Items', {
        'machineId': machine.id,
        'name': item.name,
        'code': item.code,  // ذخیره کد آیتم
      });
    }
  }



  @override
  Future<List<MachineEntity>> getMachines() async {
    final db = await database;
    final machineRows = await db.query('Machines');
    final List<MachineEntity> machines = [];

    // دریافت فقط نام ماشین، نام آیتم‌ها و کد آیتم‌ها
    for (var machineRow in machineRows) {
      final items = await db.query('Items', where: 'machineId = ?', whereArgs: [machineRow['id']]);

      // آیتم‌ها شامل نام و کد هستند
      final machineItems = items.map((item) => ItemEntity(
        name: item['name'] as String,
        code: item['code'] as String,  // دریافت کد آیتم
        price: 0,  // قیمت اولیه را صفر می‌گذاریم
        color: '', // رنگ اولیه را خالی می‌گذاریم
      )).toList();

      machines.add(MachineEntity(
        id: machineRow['id'] as String,
        name: machineRow['name'] as String,
        items: machineItems,
      ));
    }

    return machines;
  }



  @override
  Future<void> updateItems(String machineName, List<ItemEntity> items) async {
    final db = await database;

    // دریافت ID ماشین بر اساس نام
    final machineQuery = await db.query(
      'Machines',
      where: 'name = ?',
      whereArgs: [machineName],
    );

    if (machineQuery.isEmpty) {
      throw Exception('Machine with name $machineName not found.');
    }

    final machineId = machineQuery.first['id'] as String;

    // به‌روزرسانی هر آیتم در لیست
    for (final item in items) {
      await db.update(
        'Items',
        {'price': item.price, 'color': item.color},
        where: 'machineId = ? AND name = ? AND code = ?',  // اضافه کردن شرط code
        whereArgs: [machineId, item.name, item.code],  // اضافه کردن کد به پارامترهای whereArgs
      );
    }
  }

  @override
  Future<void> updateItem(String machineName, ItemEntity item) async {
    await updateItems(machineName, [item]);
  }
}




// Controller
abstract class MachineControllerInterface {
  Future<void> fetchMachinesFromAPI();
  Future<void> loadMachines();
  Future<void> updateItemsForMachine(String machineName, List<ItemEntity> items);
  Future<void> updateSingleItem(String machineName, ItemEntity item);
}
class MachineController extends GetxController implements MachineControllerInterface {
  final DatabaseService databaseService;

  MachineController({required this.databaseService});

  final machines = <MachineEntity>[].obs;

  @override
  Future<void> fetchMachinesFromAPI() async {
    // Simulate API Call
    final fetchedMachines = [
      MachineEntity(id: 'g44g4g45g4', name: 'Machine 1', items: [
        ItemEntity(name: 'Door', code: 'hbwibvcir9384', price: 0, color: ''),
        ItemEntity(name: 'Wheel', code: '3f3434f', price: 0, color: ''),
      ]),
      MachineEntity(id: '45g445g45g445g', name: 'Machine 2', items: [
        ItemEntity(name: 'Body', code: 'erv3344v343v', price: 0, color: ''),
        ItemEntity(name: 'dee', code: 'erv3344v343v', price: 0, color: ''),
        ItemEntity(name: 'edrf', code: 'erv3344v343v', price: 0, color: ''),
      ]),
      MachineEntity(id: '4g4545445g', name: 'Machine 3', items: [
        ItemEntity(name: 'ere', code: 'erv3344v343v', price: 0, color: ''),
        ItemEntity(name: 'deerfee', code: 'erv3344v343v', price: 0, color: ''),
        ItemEntity(name: 'ederfrf', code: 'erv3344v343v', price: 0, color: ''),
      ]),
    ];

    // Insert the machines into the database
    for (var machine in fetchedMachines) {
      await databaseService.insertMachine(machine);
    }

    // Load machines after insertion
    await loadMachines();
  }

  @override
  Future<void> loadMachines() async {
    machines.assignAll(await databaseService.getMachines());
    update(); // Call update to notify listeners
  }

  @override
  Future<void> updateItemsForMachine(String machineName, List<ItemEntity> items) async {
    await databaseService.updateItems(machineName, items);
    await loadMachines();
  }

  @override
  Future<void> updateSingleItem(String machineName, ItemEntity item) async {
    await databaseService.updateItem(machineName, item);
    await loadMachines();
  }
}

class MachineListView extends StatelessWidget {
  final MachineController controller = Get.put(MachineController(databaseService: SQLiteDatabaseService()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Machines')),
      body: GetBuilder<MachineController>(
        builder: (controller) {
          if (controller.machines.isEmpty) {
            return Center(child: Text('No machines available'));
          }
          return ListView.builder(
            itemCount: controller.machines.length,
            itemBuilder: (context, index) {
              final machine = controller.machines[index];
              return ExpansionTile(
                title: Text(machine.name),
                children: machine.items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Code: ${item.code}'),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await controller.fetchMachinesFromAPI();
        },
        child: Icon(Icons.download),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    home: MachineListView(),
  ));
}
