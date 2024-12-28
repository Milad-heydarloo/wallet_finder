

import 'package:sqlite3/sqlite3.dart';
import 'package:wallet_finder/view_front_farbod/service/api_service.dart';

import 'Processor/MachineProcessor.dart';

abstract class DatabaseRepository {
  Future<void> insertMachine(MachineEntity machine);

  Future<List<MachineEntity>> getMachineEntitiesWithoutPriceAndColor();
  Future<List<MachineEntity>> getMachineWithItems();

  Future<void> updateItemPriceAndColor(
      String machineId, List<ItemEntity> items);

  Future<void> deleteMachine(String machineId);
}

class DatabaseRepositoryImpl extends DatabaseRepository {
  late Database _database;
  // متد برای دریافت اطلاعات ماشین با استفاده از machine.id
  Future<MachineEntity?> getMachineById(String machineId) async {
    await _initializeDatabase();

    // دریافت اطلاعات ماشین با استفاده از machineId
    final machineResult = _database.select('SELECT * FROM Machines WHERE id = ?', [machineId]);

    // اگر ماشین یافت شد
    if (machineResult.isNotEmpty) {
      final machineRow = machineResult.first;

      // دریافت آیتم‌های ماشین
      final itemResult = _database.select('SELECT * FROM Items WHERE machineId = ?', [machineId]);

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

// متد برای حذف تمام داده‌ها از دیتابیس اصلی
  Future<void> clearDatabase() async {
    await _initializeDatabase();

    // حذف تمام داده‌ها از جدول Items
    _database.execute('DELETE FROM Items');

    // حذف تمام داده‌ها از جدول Machines
    _database.execute('DELETE FROM Machines');

    print('All data has been cleared from the main database.');
  }

  // ایجاد دیتابیس و جدول‌ها
  Future<void> _initializeDatabase() async {
    final db = sqlite3.open('machine.db');
    _database = db;

    // ایجاد جداول در دیتابیس
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

  @override
  Future<void> insertMachine(MachineEntity machine) async {
    await _initializeDatabase();

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
    await _initializeDatabase();

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
    await _initializeDatabase();

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

abstract class DatabaseRepositoryView {
  Future<void> insertMachine(MachineEntity machine);

  Future<List<MachineEntity>> getMachineWithItems();

  Future<void> deleteMachine(String machineId);
}

class DatabaseRepositoryImplView extends DatabaseRepositoryView {
  late Database _database;
  // متد برای دریافت اطلاعات ماشین با استفاده از machine.id
  Future<MachineEntity?> getMachineById(String machineId) async {
    await _initializeDatabase();

    // دریافت اطلاعات ماشین با استفاده از machineId
    final machineResult = _database.select('SELECT * FROM Machines WHERE id = ?', [machineId]);

    // اگر ماشین یافت شد
    if (machineResult.isNotEmpty) {
      final machineRow = machineResult.first;

      // دریافت آیتم‌های ماشین
      final itemResult = _database.select('SELECT * FROM Items WHERE machineId = ?', [machineId]);

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

abstract class Entity {}

class MachineEntity extends Entity {
  final String id;
  final String name;
  final String memonic;
  final List<ItemEntity> items;

  MachineEntity({
    required this.id,
    required this.name,
    required this.items,
    required this.memonic,
  });

  // فکتوری برای ساخت ماشین از داده‌های JSON
  factory MachineEntity.fromJson(Map<String, dynamic> json) {
    List<ItemEntity> itemsList = [];

    // تبدیل آیتم‌ها به یک لیست از ItemEntity
    json.forEach((key, value) {
      // بررسی اینکه کلیدهایی مانند 'id', 'collectionName', 'Code', 'collectionId' و موارد مشابه در آیتم‌ها ذخیره نشوند
      if (key != 'collectionName' && // جلوگیری از ذخیره collectionName

          key != 'collectionId' && // جلوگیری از ذخیره collectionId
          key != 'created' &&
          key != 'updated' &&
          key != 'id' &&
          key != 'memonic' &&
          key != 'check') {
        // فقط کلیدهایی که به عنوان آیتم هستند را پردازش می‌کنیم
        itemsList.add(ItemEntity.fromJson(key, value));
      }
    });

    return MachineEntity(
      id: json['id'] ?? '',
      // مقدار پیش‌فرض برای id
      name: json['collectionName'] ?? 'Unknown Machine',
      // مقدار پیش‌فرض برای نام
      memonic: json['memonic'] ?? 'memonic Machine',
      // مقدار پیش‌فرض برای نام
      items: itemsList,
    );
  }
}

class ItemEntity extends Entity {
  final String name;
  final String code;
  double? price; // قیمت آیتم
  String? color; // رنگ آیتم

  ItemEntity({
    required this.name,
    required this.code,
    this.price,
    this.color,
  });

  // فکتوری برای ساخت آیتم از داده‌های JSON
  factory ItemEntity.fromJson(String name, dynamic value) {
    return ItemEntity(
      name: name, // نام آیتم که از کلید گرفته می‌شود
      code: value.toString(), // مقدار کد که از داده‌های API گرفته می‌شود
    );
  }
}



/// متد برای چک کردن دیتابیس و پر کردن آن در صورت نیاز
Future<void> ensureDatabaseIsFilledAndProcess() async {
  final dbRepo = DatabaseRepositoryImpl();
  // بررسی تعداد رکوردهای موجود در دیتابیس
  final machinesInDb = await dbRepo.getMachineEntitiesWithoutPriceAndColor();

  if (machinesInDb.length >= 2) {
    print('دیتابیس دارای حداقل دو رکورد است.');
    final selectedMachines = extractTwoMachines(machinesInDb);
    loopCheck(selectedMachines);
  } else {
    print('دیتابیس کمتر از دو رکورد دارد، دریافت اطلاعات از API...');
    final ApiService _apiService = ApiService();

    // دریافت داده‌ها از API و ذخیره در دیتابیس
    final machinesFromApi = await _apiService.fetchWalletRecordswallet();
    for (var machine in machinesFromApi) {
      await dbRepo.insertMachine(machine);
    }

    // دوباره رکوردها را از دیتابیس دریافت می‌کنیم
    final updatedMachinesInDb = await dbRepo.getMachineEntitiesWithoutPriceAndColor();

    if (updatedMachinesInDb.length >= 2) {
      final selectedMachines = extractTwoMachines(updatedMachinesInDb);
      loopCheck(selectedMachines);
    } else {
      print('داده کافی حتی پس از دریافت از API موجود نیست.');
    }
  }
}

/// متد برای استخراج دو ماشین اول از لیست
List<MachineEntity> extractTwoMachines(List<MachineEntity> machines) {
  return machines.take(2).toList(); // استخراج دو ماشین اول از لیست
}



void loopCheck(List<MachineEntity> machines) async {
  if (machines.isNotEmpty) {
    print('Raw Machine Data (Before Update):');
    final ApiService _apiService = ApiService();

    List<String> balanceColors = []; // لیستی برای ذخیره رنگ‌ها

    // برای هر ماشین در لیست
    for (var machine in machines) {
      // چاپ ویژگی‌های ماشین
      print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');

      final apiRecordMap = await _apiService.fetchAPIRecords();
      List<ItemEntity> updatedItems = []; // لیستی برای ذخیره آیتم‌های بروزرسانی شده

      // بررسی آیتم‌ها در ماشین و پیدا کردن آیتم‌ها
      for (var item in machine.items) {
        print('Raw Item: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');

        String balanceColor;

        // بررسی بالانس‌ها و چاپ رنگ‌ها
        if (item.name == 'usdt') {

          double usdtBalance = await _apiService.getUsdtBalance(item.code, apiRecordMap!.bscScanApi);
          balanceColor = getBalanceColor(usdtBalance);
          print('USDT Balance: $usdtBalance, Color: $balanceColor');

          // به‌روزرسانی قیمت و رنگ آیتم
          item.price = usdtBalance; // به‌روزرسانی قیمت با بالانس
          item.color = balanceColor; // به‌روزرسانی رنگ با رنگ موجود

        } else if (item.name == 'bnb') {
          double bnbBalance = await _apiService.getBnbBalance(item.code, apiRecordMap!.bscScanApi);
          balanceColor = getBalanceColor(bnbBalance);
          print('BNB Balance: $bnbBalance, Color: $balanceColor');

          // به‌روزرسانی قیمت و رنگ آیتم
          item.price = bnbBalance;
          item.color = balanceColor;

        } else if (item.name == 'eth') {
          double ethBalance = await _apiService.getEthBalance(item.code, apiRecordMap!.etherscanApi);
          balanceColor = getBalanceColor(ethBalance);
          print('ETH Balance: $ethBalance, Color: $balanceColor');

          // به‌روزرسانی قیمت و رنگ آیتم
          item.price = ethBalance;
          item.color = balanceColor;

        } else if (item.name == 'busd') {
          double busdBalance = await _apiService.getBusdBalance(item.code, apiRecordMap!.bscScanApi);
          balanceColor = getBalanceColor(busdBalance);
          print('BUSD Balance: $busdBalance, Color: $balanceColor');

          // به‌روزرسانی قیمت و رنگ آیتم
          item.price = busdBalance;
          item.color = balanceColor;

        } else if (item.name == 'trx') {
          double trxBalance = await _apiService.getTrxBalance(item.code);
          balanceColor = getBalanceColor(trxBalance);
          print('TRX Balance: $trxBalance, Color: $balanceColor');

          // به‌روزرسانی قیمت و رنگ آیتم
          item.price = trxBalance;
          item.color = balanceColor;

        } else {
          print('Unknown item: ${item.name}');
          continue;
        }

        // اضافه کردن آیتم بروزرسانی‌شده به لیست
        updatedItems.add(item);

        // ذخیره رنگ در لیست برای بررسی بعدی
        balanceColors.add(balanceColor);
      }

      // بررسی اینکه آیا همه رنگ‌ها نارنجی هستند
      bool allOrange = balanceColors.every((color) => color == 'orange');
      final dbRepo = DatabaseRepositoryImpl();
      // بروزرسانی اطلاعات در پایگاه‌داده
      await dbRepo.updateItemPriceAndColor(machine.id, updatedItems);

      // فراخوانی متد مناسب
      if (allOrange) {
          sendToOrangeMethod(machine.id); // ارسال به متد نارنجی
      } else {
          sendToGreenMethod(machine.id); // ارسال به متد سبز
      }
      updatedItems.clear();

    }

    // final dbRepo = DatabaseRepositoryImpl();
    // // پس از تکمیل پردازش‌ها، تمام اطلاعات ماشین‌ها و آیتم‌ها را چاپ کنید
    // print('Updated Machine Data (After Update):');
    // final List<MachineEntity> updatedMachines = await dbRepo.getMachineWithItems();
    // updatedMachines.forEach((machine) {
    //   print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
    //   machine.items.forEach((item) {
    //     print('Item: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
    //   });
    // });

  } else {
    print('لیست ماشین‌ها خالی است.');
  }
  ensureDatabaseIsFilledAndProcess();
}

void sendToOrangeMethod(String machineId) async {
  final dbRepo = DatabaseRepositoryImpl();

  // دریافت اطلاعات ماشین از دیتابیس با استفاده از machineId
  MachineEntity? machine = await dbRepo.getMachineById(machineId);

  if (machine != null) {
    print('All items are orange. Sending data to orange method...');

    // چاپ اطلاعات کامل ماشین
    print('Machine Details:');
    print('Machine ID: ${machine.id}');
    print('Machine Name: ${machine.name}');
    print('Machine Memonic: ${machine.memonic}');
    print('Machine Parts:');
    for (var item in machine.items) {
      print('Item Name: ${item.name}');
      print('Item Code: ${item.code}');
      print('Item Price: ${item.price}');
      print('Item Color: ${item.color}');
    }
    final dbRepoview = DatabaseRepositoryImplView();
    // فراخوانی متد insertMachine برای ذخیره اطلاعات
    await dbRepoview.insertMachine(machine);
    print('Data has been successfully inserted into the database.');

    dbRepo.deleteMachine(machineId);
  } else {
    print('Machine with ID $machineId not found.');
  }
}


void sendToGreenMethod(String machineId) async {
  print('hi green');
  final dbRepo = DatabaseRepositoryImpl();

  // دریافت اطلاعات ماشین از دیتابیس با استفاده از machineId
  MachineEntity? machine = await dbRepo.getMachineById(machineId);

  if (machine != null) {
    print('At least one item is green. Sending data to green method...');
    // چاپ اطلاعات کامل ماشین
    print('Machine Details:');
    print('Machine ID: ${machine.id}');
    print('Machine Name: ${machine.name}');
    print('Machine Memonic: ${machine.memonic}');
    print('Machine Parts:');
    for (var item in machine.items) {
      print('Item Name: ${item.name}');
      print('Item Code: ${item.code}');
      print('Item Price: ${item.price}');
      print('Item Color: ${item.color}');
    }
    // انجام عملیات دیگر برای وضعیت سبز
  } else {
    print('Machine with ID $machineId not found.');
  }
}



void main() async {
  // try {


    final dbRepoview = DatabaseRepositoryImplView();
    final dbRepo = DatabaseRepositoryImpl();
    await dbRepo.clearDatabase(); // پاک کردن دیتابیس اصلی


    await dbRepoview.clearViewDatabase(); // پاک کردن دیتابیس نمایشی

    // فراخوانی متد برای چک کردن و پر کردن دیتابیس
    await ensureDatabaseIsFilledAndProcess();
    // // 1. دریافت داده‌ها از API و وارد کردن به دیتابیس اول
    // final machinesFromApi = await fetchWalletRecords(); // دریافت رکوردها از API
    // for (var machine in machinesFromApi) {
    //   await dbRepo.insertMachine(machine); // وارد کردن داده‌ها به دیتابیس اول
    // }

   // print('Data from API inserted into the first database.');

    // 2. ویرایش داده‌ها با اطلاعات تصادفی
  //   final machinesFromDb = await dbRepo.getMachineEntitiesWithoutPriceAndColor();
  //   print('Raw Machine Data (Before Update):');
  //   for (var machine in machinesFromDb) {
  //     print('Machine ID: ${machine.id}, Name: ${machine.name}, memonic: ${machine.memonic}');
  //     for (var item in machine.items) {
  //       print('Raw Item: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
  //     }
  //   }
  //
  //   List<ItemEntity> updatedItems = [];
  //   for (var machine in machinesFromDb) {
  //     for (var item in machine.items) {
  //       final random = Random();
  //       final randomPrice = random.nextDouble() * 1000;
  //       final randomColor = getRandomColor();
  //
  //       item.price = randomPrice;
  //       item.color = randomColor;
  //       updatedItems.add(item);
  //     }
  //
  //     // 3. به روز رسانی داده‌ها در دیتابیس اول
  //     try {
  //       await dbRepo.updateItemPriceAndColor(machine.id, updatedItems);
  //     } catch (e) {
  //       print('Error during updating item data: $e');
  //     }
  //
  //     updatedItems.clear();
  //   }
  //
  //   print('Machine data updated with random price and color.');
  //
  //   // 4. انتقال رکورد کامل به دیتابیس دوم
  //   try {
  //     await dbRepoview.insertUpdatedMachineData(machinesFromDb);
  //     print('Data successfully transferred to the second database.');
  //   } catch (e) {
  //     print('Error during transferring data to second database: $e');
  //   }
  //
  //   // 5. خواندن و چاپ داده‌ها از دیتابیس دوم
  //   try {
  //     final machinesWithItems = await dbRepoview.getMachineWithItems();
  //     machinesWithItems.forEach((machine) {
  //       print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
  //       machine.items.forEach((item) {
  //         print('Item Name: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
  //       });
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // } catch (e) {
  //   print('Error: $e');
  // }
}




