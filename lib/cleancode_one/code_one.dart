//
// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:sqlite3/sqlite3.dart';
// import 'package:wallet_finder/cleancode_one/cleannewedameh.dart';
//
// import 'package:wallet_finder/view_front_farbod/model/model_api_records.dart';
//
//
// abstract class DatabaseRepositoryView {
//   Future<void> insertMachine(MachineEntity machine);
//
//   Future<List<MachineEntity>> getMachineWithItems();
//
//   Future<void> deleteMachine(String machineId);
// }
//
// class DatabaseRepositoryImplView extends DatabaseRepositoryView {
//   late Database _database;
//   // متد برای دریافت اطلاعات ماشین با استفاده از machine.id
//   Future<MachineEntity?> getMachineById(String machineId) async {
//     await _initializeDatabase();
//
//     // دریافت اطلاعات ماشین با استفاده از machineId
//     final machineResult = _database.select('SELECT * FROM Machines WHERE id = ?', [machineId]);
//
//     // اگر ماشین یافت شد
//     if (machineResult.isNotEmpty) {
//       final machineRow = machineResult.first;
//
//       // دریافت آیتم‌های ماشین
//       final itemResult = _database.select('SELECT * FROM Items WHERE machineId = ?', [machineId]);
//
//       // تبدیل آیتم‌ها به یک لیست از ItemEntity
//       final items = itemResult.map((itemRow) {
//         return ItemEntity(
//           name: itemRow['name'],
//           code: itemRow['code'],
//           price: itemRow['price'],
//           color: itemRow['color'],
//         );
//       }).toList();
//
//       // ساخت شیء MachineEntity و بازگرداندن آن
//       return MachineEntity(
//         id: machineRow['id'],
//         name: machineRow['name'],
//         memonic: machineRow['memonic'],
//         items: items,
//       );
//     }
//
//     // اگر ماشین با این id پیدا نشد، مقدار null برمی‌گردانیم
//     return null;
//   }
//
// // متد برای حذف تمام داده‌ها از دیتابیس view
//   Future<void> clearViewDatabase() async {
//     await _initializeDatabase();
//
//     // حذف تمام داده‌ها از جدول Items
//     _database.execute('DELETE FROM Items');
//
//     // حذف تمام داده‌ها از جدول Machines
//     _database.execute('DELETE FROM Machines');
//
//     print('All data has been cleared from the view database.');
//   }
//
//   // ایجاد دیتابیس و جداول
//   Future<void> _initializeDatabase() async {
//     final db = sqlite3.open('machineview.db');
//     _database = db;
//
//     // ایجاد جداول در دیتابیس جدید
//     db.execute('''
//       CREATE TABLE IF NOT EXISTS Machines(
//         id TEXT PRIMARY KEY,
//         name TEXT,
//         memonic TEXT
//       )
//     ''');
//
//     db.execute('''
//       CREATE TABLE IF NOT EXISTS Items(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         machineId TEXT,
//         name TEXT,
//         code TEXT,
//         price REAL,
//         color TEXT,
//         FOREIGN KEY (machineId) REFERENCES Machines(id)
//       )
//     ''');
//   }
//
//   // متدی برای وارد کردن داده‌های ماشین و آیتم‌ها به‌صورت یکجا
//   @override
//   Future<void> insertMachine(MachineEntity machine) async {
//     await _initializeDatabase();
//
//     // شروع تراکنش با اجرای دستور BEGIN TRANSACTION
//     _database.execute('BEGIN TRANSACTION');
//
//     try {
//       // وارد کردن اطلاعات ماشین به دیتابیس
//       _database.execute('''
//         INSERT OR REPLACE INTO Machines (id, name, memonic) VALUES (?, ?, ?)
//       ''', [machine.id, machine.name, machine.memonic]);
//
//       // وارد کردن آیتم‌ها برای ماشین
//       for (var item in machine.items) {
//         _database.execute('''
//           INSERT OR REPLACE INTO Items (machineId, name, code, price, color) VALUES (?, ?, ?, ?, ?)
//         ''', [machine.id, item.name, item.code, item.price, item.color]);
//       }
//
//       // در صورت موفقیت، اعمال تراکنش
//       _database.execute('COMMIT');
//     } catch (e) {
//       // در صورت خطا، برگرداندن تراکنش
//       _database.execute('ROLLBACK');
//       print('Error inserting machine data: $e');
//     }
//   }
//
//   // متدی برای وارد کردن داده‌های آپدیت شده به دیتابیس جدید
//   Future<void> insertUpdatedMachineData(List<MachineEntity> machines) async {
//     await _initializeDatabase();
//
//     // شروع تراکنش با اجرای دستور BEGIN TRANSACTION
//     _database.execute('BEGIN TRANSACTION');
//
//     try {
//       for (var machine in machines) {
//         // وارد کردن ماشین به دیتابیس جدید
//         _database.execute('''
//           INSERT OR REPLACE INTO Machines (id, name, memonic) VALUES (?, ?, ?)
//         ''', [machine.id, machine.name, machine.memonic]);
//
//         // وارد کردن آیتم‌ها با قیمت و رنگ به‌روزرسانی شده به دیتابیس جدید
//         for (var item in machine.items) {
//           _database.execute('''
//             INSERT OR REPLACE INTO Items (machineId, name, code, price, color) VALUES (?, ?, ?, ?, ?)
//           ''', [machine.id, item.name, item.code, item.price, item.color]);
//         }
//       }
//
//       // در صورت موفقیت، اعمال تراکنش
//       _database.execute('COMMIT');
//     } catch (e) {
//       // در صورت خطا، برگرداندن تراکنش
//       _database.execute('ROLLBACK');
//       print('Error inserting updated machine data: $e');
//     }
//   }
//
//   // سایر متدها
//   @override
//   Future<void> deleteMachine(String machineId) async {
//     await _initializeDatabase();
//
//     // حذف آیتم‌ها مربوط به ماشین
//     _database.execute('''
//       DELETE FROM Items WHERE machineId = ?
//     ''', [machineId]);
//
//     // حذف ماشین
//     _database.execute('''
//       DELETE FROM Machines WHERE id = ?
//     ''', [machineId]);
//   }
//
//   @override
//   Future<List<MachineEntity>> getMachineWithItems() async {
//     await _initializeDatabase();
//
//     final machineResult = _database.select('SELECT * FROM Machines');
//     final machines = <MachineEntity>[];
//
//     for (var machineRow in machineResult) {
//       final machineId = machineRow['id'] as String;
//
//       // دریافت آیتم‌ها برای هر ماشین
//       final itemResult = _database
//           .select('SELECT * FROM Items WHERE machineId = ?', [machineId]);
//
//       // تبدیل نتایج آیتم‌ها به یک لیست از ItemEntity
//       final items = itemResult.map((itemRow) {
//         return ItemEntity(
//           name: itemRow['name'],
//           code: itemRow['code'],
//           price: itemRow['price'],
//           color: itemRow['color'],
//         );
//       }).toList();
//
//       // ساخت شیء MachineEntity و اضافه کردن آن به لیست
//       machines.add(MachineEntity(
//         id: machineRow['id'],
//         name: machineRow['name'],
//         memonic: machineRow['memonic'],
//         items: items,
//       ));
//     }
//
//     return machines;
//   }
// }
//
//
// abstract class Entity {}
//
// class MachineEntity extends Entity {
//   final String id;
//   final String name;
//   final String memonic;
//   final List<ItemEntity> items;
//
//   MachineEntity({
//     required this.id,
//     required this.name,
//     required this.items,
//     required this.memonic,
//   });
//
//   // فکتوری برای ساخت ماشین از داده‌های JSON
//   factory MachineEntity.fromJson(Map<String, dynamic> json) {
//     List<ItemEntity> itemsList = [];
//
//     // تبدیل آیتم‌ها به یک لیست از ItemEntity
//     json.forEach((key, value) {
//       // بررسی اینکه کلیدهایی مانند 'id', 'collectionName', 'Code', 'collectionId' و موارد مشابه در آیتم‌ها ذخیره نشوند
//       if (key != 'collectionName' && // جلوگیری از ذخیره collectionName
//
//           key != 'collectionId' && // جلوگیری از ذخیره collectionId
//           key != 'created' &&
//           key != 'updated' &&
//           key != 'id' &&
//           key != 'memonic' &&
//           key != 'check') {
//         // فقط کلیدهایی که به عنوان آیتم هستند را پردازش می‌کنیم
//         itemsList.add(ItemEntity.fromJson(key, value));
//       }
//     });
//
//     return MachineEntity(
//       id: json['id'] ?? '',
//       // مقدار پیش‌فرض برای id
//       name: json['collectionName'] ?? 'Unknown Machine',
//       // مقدار پیش‌فرض برای نام
//       memonic: json['memonic'] ?? 'memonic Machine',
//       // مقدار پیش‌فرض برای نام
//       items: itemsList,
//     );
//   }
// }
//
// class ItemEntity extends Entity {
//   final String name;
//   final String code;
//   double? price; // قیمت آیتم
//   String? color; // رنگ آیتم
//
//   ItemEntity({
//     required this.name,
//     required this.code,
//     this.price,
//     this.color,
//   });
//
//   // فکتوری برای ساخت آیتم از داده‌های JSON
//   factory ItemEntity.fromJson(String name, dynamic value) {
//     return ItemEntity(
//       name: name, // نام آیتم که از کلید گرفته می‌شود
//       code: value.toString(), // مقدار کد که از داده‌های API گرفته می‌شود
//     );
//   }
// }
//
// abstract class DatabaseRepository {
//   Future<void> insertMachine(MachineEntity machine);
//   Future<List<MachineEntity>> getMachineEntitiesWithoutPriceAndColor();
//   Future<List<MachineEntity>> getMachineWithItems();
//   Future<MachineEntity?> getMachineById(String machineId);
//   Future<void> updateItemPriceAndColor(String machineId, List<ItemEntity> items);
//   Future<void> deleteMachine(String machineId);
//
//
//
// }
//
// class DatabaseRepositoryImpl implements DatabaseRepository {
//   late final Database _database;
//
//   DatabaseRepositoryImpl() {
//     _database = sqlite3.open('machine.db');
//     _initializeDatabase();
//   }
//
//   void _initializeDatabase() {
//     _database.execute('''
//       CREATE TABLE IF NOT EXISTS Machines(
//         id TEXT PRIMARY KEY,
//         name TEXT,
//         memonic TEXT
//       )
//     ''');
//     _database.execute('''
//       CREATE TABLE IF NOT EXISTS Items(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         machineId TEXT,
//         name TEXT,
//         code TEXT,
//         price REAL,
//         color TEXT,
//         FOREIGN KEY (machineId) REFERENCES Machines(id)
//       )
//     ''');
//
//
//
//   }
//
//   @override
//   // متد برای دریافت اطلاعات ماشین با استفاده از machine.id
//   Future<MachineEntity?> getMachineById(String machineId) async {
//
//
//     // دریافت اطلاعات ماشین با استفاده از machineId
//     final machineResult = _database.select('SELECT * FROM Machines WHERE id = ?', [machineId]);
//
//     // اگر ماشین یافت شد
//     if (machineResult.isNotEmpty) {
//       final machineRow = machineResult.first;
//
//       // دریافت آیتم‌های ماشین
//       final itemResult = _database.select('SELECT * FROM Items WHERE machineId = ?', [machineId]);
//
//       // تبدیل آیتم‌ها به یک لیست از ItemEntity
//       final items = itemResult.map((itemRow) {
//         return ItemEntity(
//           name: itemRow['name'],
//           code: itemRow['code'],
//           price: itemRow['price'],
//           color: itemRow['color'],
//         );
//       }).toList();
//
//       // ساخت شیء MachineEntity و بازگرداندن آن
//       return MachineEntity(
//         id: machineRow['id'],
//         name: machineRow['name'],
//         memonic: machineRow['memonic'],
//         items: items,
//       );
//     }
//
//     // اگر ماشین با این id پیدا نشد، مقدار null برمی‌گردانیم
//     return null;
//   }
//
//
//   @override
//   Future<void> insertMachine(MachineEntity machine) async {
//
//
//
//     // وارد کردن اطلاعات ماشین
//     _database.execute('''
//       INSERT OR REPLACE INTO Machines (id, name, memonic) VALUES (?, ?, ?)
//     ''', [machine.id, machine.name, machine.memonic]);
//
//     // وارد کردن آیتم‌ها برای ماشین
//     for (var item in machine.items) {
//       _database.execute('''
//         INSERT OR REPLACE INTO Items (machineId, name, code) VALUES (?, ?, ?)
//       ''', [machine.id, item.name, item.code]);
//
//     }
//   }
//
//   @override
//   Future<List<MachineEntity>> getMachineEntitiesWithoutPriceAndColor() async {
//
//
//
//     final machineResult = _database.select('SELECT * FROM Machines');
//     final machines = <MachineEntity>[];
//
//     for (var machineRow in machineResult) {
//       final machineId = machineRow['id'] as String;
//
//       // دریافت آیتم‌های ماشین بدون قیمت و رنگ
//       final itemResult = _database
//           .select('SELECT * FROM Items WHERE machineId = ?', [machineId]);
//
//       final items = itemResult.map((itemRow) {
//         return ItemEntity(
//           name: itemRow['name'],
//           code: itemRow['code'],
//         );
//       }).toList();
//
//       machines.add(MachineEntity(
//         id: machineRow['id'],
//         name: machineRow['name'],
//         memonic: machineRow['memonic'],
//         items: items,
//       ));
//     }
//
//     return machines;
//
//
//   }
//
//   @override
//   Future<void> updateItemPriceAndColor(String machineId, List<ItemEntity> items) async {
//     for (var item in items) {
//       _database.execute('''
//         UPDATE Items
//         SET price = ?, color = ?
//         WHERE machineId = ? AND name = ?
//       ''', [item.price, item.color, machineId, item.name]);
//     }
//   }
//
//   @override
//   Future<void> deleteMachine(String machineId) async {
//     // حذف آیتم‌ها مربوط به ماشین
//     _database.execute('''
//       DELETE FROM Items WHERE machineId = ?
//     ''', [machineId]);
//
//     // حذف ماشین
//     _database.execute('''
//       DELETE FROM Machines WHERE id = ?
//     ''', [machineId]);
//
//   }
//
//   @override
//   Future<List<MachineEntity>> getMachineWithItems() async {
//
//     final machineResult = _database.select('SELECT * FROM Machines');
//     final machines = <MachineEntity>[];
//
//     for (var machineRow in machineResult) {
//       final machineId = machineRow['id'] as String;
//
//       // دریافت آیتم‌ها برای هر ماشین
//       final itemResult = _database
//           .select('SELECT * FROM Items WHERE machineId = ?', [machineId]);
//
//       // تبدیل نتایج آیتم‌ها به یک لیست از ItemEntity
//       final items = itemResult.map((itemRow) {
//         return ItemEntity(
//           name: itemRow['name'],
//           code: itemRow['code'],
//           price: itemRow['price'],
//           color: itemRow['color'],
//         );
//       }).toList();
//
//       // ساخت شیء MachineEntity و اضافه کردن آن به لیست
//       machines.add(MachineEntity(
//         id: machineRow['id'],
//         name: machineRow['name'],
//         memonic: machineRow['memonic'],
//         items: items,
//       ));
//     }
//
//     return machines;
//   }
// }
//
// class ApiService implements ApiServiceBase {
//   static final Dio dio = Dio();
//
//   static const String _baseUrlFetchWalletRecords = 'http://49.13.74.101:4000/assign';
//
//   @override
//   Future<List<MachineEntity>> fetchWalletRecords(String userId) async {
//     if (userId.isEmpty) {
//       throw Exception('User ID cannot be empty');
//     }
//
//     print('Sending user_id: $userId');
//     try {
//       final response = await dio.post(
//         _baseUrlFetchWalletRecords,
//         data: {'user_id': userId},
//         options: Options(headers: {'Content-Type': 'application/json'}),
//       );
//
//       if (response.statusCode == 200) {
//
//
//
//         final List<dynamic> data = response.data['assigned_records'];
//         print('Number of records fetched: ${data.length}');
//         print('${data.toList()}');
//
//         // تبدیل داده‌ها به لیست MachineEntity
//         return data.map((record) {
//           return MachineEntity.fromJson(
//               record); // تبدیل هر رکورد به MachineEntity
//         }).toList();
//
//
//       } else {
//         throw Exception('Failed to fetch wallet records. Status: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       // چاپ جزئیات خطا
//       if (e.response != null) {
//         print('Response status: ${e.response!.statusCode}');
//         print('Response data: ${e.response!.data}');
//       } else {
//         print('Error: $e');
//       }
//       rethrow;
//     }
//   }
//
//   @override
//   Future<double> getEthBalance(String address, String apiKey) async {
//     final url = 'https://api.etherscan.io/api?module=account&action=balance&address=$address&apikey=$apiKey';
//     return _fetchBalance(url);
//   }
//
//   @override
//   Future<double> getBnbBalance(String address, String apiKey) async {
//     final url = 'https://api.bscscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
//     return _fetchBalance(url);
//   }
//
//   @override
//   Future<double> getMaticBalance(String address, String apiKey) async {
//     final url = 'https://api.polygonscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
//     return _fetchBalance(url);
//   }
//
//   @override
//   Future<double> getTrxBalance(String address) async {
//     final url = 'https://apilist.tronscanapi.com/api/account?address=$address';
//     return _fetchTrxBalance(url);
//   }
//
//   @override
//   Future<double> getUsdtBalance(String address, String apiKey) async {
//     final url =
//         'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0x55d398326f99059fF775485246999027B3197955&address=$address&tag=latest&apikey=$apiKey';
//     return _fetchBalance(url);
//   }
//
//   @override
//   Future<double> getBusdBalance(String address, String apiKey) async {
//     final url =
//         'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0xe9e7cea3dedca5984780bafc599bd69add087d56&address=$address&tag=latest&apikey=$apiKey';
//     return _fetchBalance(url);
//   }
//
//
//
//   @override
//   Future<double?> getBitcoinBalance(String address) async {
//     final dio = Dio();
//     final url = 'https://api.blockcypher.com/v1/btc/main/addrs/$address/balance';
//
//     for (var attempt = 0; attempt < 5; attempt++) {
//       try {
//         // ارسال درخواست به API
//         final response = await dio.get(url);
//         // تأخیر 2 ثانیه‌ای بین درخواست‌ها
//         await Future.delayed(Duration(seconds: 2));
//
//         if (response.statusCode == 200) {
//           // دریافت موجودی به صورت ساتوشی
//           int balanceSatoshi = response.data['balance'];
//           double balanceBtc = balanceSatoshi / 1e8;  // تبدیل ساتوشی به بیت‌کوین
//           return balanceBtc;
//         } else {
//           print('Error fetching balance for $address: ${response.statusCode}');
//           return null;
//         }
//       } catch (e) {
//         print('Exception occurred: $e');
//         return null;
//       }
//     }
//
//     return null;
//   }
//
//
//   Future<double> _fetchBalance(String url) async {
//     try {
//       final response = await dio.get(url);
//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data['status'] == '1' && data['result'] != null) {
//           return int.parse(data['result']) / 1e18;
//         }
//       }
//     } catch (e) {
//       print('Error fetching balance: $e');
//     }
//     return 0.0;
//   }
//
//   Future<double> _fetchTrxBalance(String url) async {
//     try {
//       final response = await dio.get(url);
//       if (response.statusCode == 200) {
//         final data = response.data;
//         if (data['balance'] != null) {
//           return data['balance'] / 1e6;
//         }
//       }
//     } catch (e) {
//       print('Error fetching TRX balance: $e');
//     }
//     return 0.0;
//   }
//
//
//   static const String _baseUrlFetchAPIRecords = 'http://49.13.74.101:5000/assign';
//   Future<API_Record?> fetchAPIRecords() async {
//     try {
//       final response = await dio.post(
//         _baseUrlFetchAPIRecords,
//         data: {'user_id': 'userId'},
//       );
//
//       if (response.statusCode == 200) {
//         final data = response.data;
//         return API_Record.fromJson(data['assigned_record']);
//       } else {
//         print('Error: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//       return null;
//     }
//   }
//
//   Future<List<MachineEntity>> fetchWalletRecordswallet() async {
//     try {
//       final response = await dio.post(
//         _baseUrlFetchWalletRecords,
//         data: jsonEncode({'user_id': 'user123'}), // تبدیل به JSON
//         options: Options(
//           headers: {'Content-Type': 'application/json'}, // ارسال به عنوان JSON
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = response.data['assigned_records'];
//         print('Number of records fetched: ${data.length}');
//         print('${data.toList()}');
//
//         // تبدیل داده‌ها به لیست MachineEntity
//         return data.map((record) {
//           return MachineEntity.fromJson(
//               record); // تبدیل هر رکورد به MachineEntity
//         }).toList();
//       } else {
//         print('Error: ${response.statusCode}');
//         print('Response data: ${response.data}');
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//       throw Exception('Error fetching data: $e');
//     }
//   }
//
//   @override
//   Future<double> getBtcBalance(String address) {
//     // TODO: implement getBtcBalance
//     throw UnimplementedError();
//   }
//
//
//
// }
//
// abstract class ApiServiceBase {
//   Future<List<MachineEntity>> fetchWalletRecords(String userId);
//   Future<double> getEthBalance(String address, String apiKey);
//   Future<double> getBnbBalance(String address, String apiKey);
//   Future<double> getMaticBalance(String address, String apiKey);
//   Future<double> getTrxBalance(String address);
//   Future<double> getUsdtBalance(String address, String apiKey);
//   Future<double> getBusdBalance(String address, String apiKey);
//   Future<double> getBtcBalance(String address);
//   Future<API_Record?> fetchAPIRecords();
//
// }
//
// class MachineProcessor {
//   final DatabaseRepository dbRepo;
//   final ApiService apiService;
//
//   MachineProcessor(this.dbRepo, this.apiService);
//
//   Future<void> ensureDatabaseIsFilledAndProcess() async {
//     final machinesInDb = await dbRepo.getMachineEntitiesWithoutPriceAndColor();
//
//     if (machinesInDb.length >= 2) {
//       print('دیتابیس دارای حداقل دو رکورد است.');
//       final selectedMachines = extractTwoMachines(machinesInDb);
//       await loopCheck(selectedMachines);
//     } else {
//       print('دیتابیس کمتر از دو رکورد دارد، دریافت اطلاعات از API...');
//
//       final machinesFromApi = await apiService.fetchWalletRecordswallet();
//       for (var machine in machinesFromApi) {
//         await dbRepo.insertMachine(machine);
//       }
//
//       final updatedMachinesInDb = await dbRepo.getMachineEntitiesWithoutPriceAndColor();
//       if (updatedMachinesInDb.length >= 2) {
//         final selectedMachines = extractTwoMachines(updatedMachinesInDb);
//         await loopCheck(selectedMachines);
//       } else {
//         print('داده کافی حتی پس از دریافت از API موجود نیست.');
//       }
//     }
//   }
//
//   List<MachineEntity> extractTwoMachines(List<MachineEntity> machines) {
//     return machines.take(2).toList();
//   }
//   Future<void> loopCheck(List<MachineEntity> machines) async {
//     if (machines.isNotEmpty) {
//       print('Raw Machine Data (Before Update):');
//       final ApiService _apiService = ApiService();
//
//       List<String> balanceColors = []; // لیستی برای ذخیره رنگ‌ها
//
//       // برای هر ماشین در لیست
//       for (var machine in machines) {
//         // چاپ ویژگی‌های ماشین
//         print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
//
//         final apiRecordMap = await _apiService.fetchAPIRecords();
//         List<ItemEntity> updatedItems = []; // لیستی برای ذخیره آیتم‌های بروزرسانی شده
//
//         // بررسی آیتم‌ها در ماشین و پیدا کردن آیتم‌ها
//         for (var item in machine.items) {
//           print('Raw Item: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
//
//           String balanceColor;
//
//           // بررسی بالانس‌ها و چاپ رنگ‌ها
//           if (item.name == 'usdt') {
//             await Future.delayed(Duration(milliseconds: 1000));
//             double usdtBalance = await _apiService.getUsdtBalance(item.code, apiRecordMap!.bscScanApi);
//             balanceColor = getBalanceColor(usdtBalance);
//             print('USDT Balance: $usdtBalance, Color: $balanceColor');
//
//             // به‌روزرسانی قیمت و رنگ آیتم
//             item.price = usdtBalance; // به‌روزرسانی قیمت با بالانس
//             item.color = balanceColor; // به‌روزرسانی رنگ با رنگ موجود
//
//           } else if (item.name == 'bnb') {
//             await Future.delayed(Duration(milliseconds: 1000));
//             double bnbBalance = await _apiService.getBnbBalance(item.code, apiRecordMap!.bscScanApi);
//             balanceColor = getBalanceColor(bnbBalance);
//             print('BNB Balance: $bnbBalance, Color: $balanceColor');
//
//             // به‌روزرسانی قیمت و رنگ آیتم
//             item.price = bnbBalance;
//             item.color = balanceColor;
//
//           } else if (item.name == 'eth') {
//             await Future.delayed(Duration(milliseconds: 1000));
//             double ethBalance = await _apiService.getEthBalance(item.code, apiRecordMap!.etherscanApi);
//             balanceColor = getBalanceColor(ethBalance);
//             print('ETH Balance: $ethBalance, Color: $balanceColor');
//
//             // به‌روزرسانی قیمت و رنگ آیتم
//             item.price = ethBalance;
//             item.color = balanceColor;
//
//           } else if (item.name == 'busd') {
//             await Future.delayed(Duration(milliseconds: 1000));
//             double busdBalance = await _apiService.getBusdBalance(item.code, apiRecordMap!.bscScanApi);
//             balanceColor = getBalanceColor(busdBalance);
//             print('BUSD Balance: $busdBalance, Color: $balanceColor');
//
//             // به‌روزرسانی قیمت و رنگ آیتم
//             item.price = busdBalance;
//             item.color = balanceColor;
//
//           } else if (item.name == 'trx') {
//             await Future.delayed(Duration(milliseconds: 1000));
//             double trxBalance = await _apiService.getTrxBalance(item.code);
//             balanceColor = getBalanceColor(trxBalance);
//             print('TRX Balance: $trxBalance, Color: $balanceColor');
//
//             // به‌روزرسانی قیمت و رنگ آیتم
//             item.price = trxBalance;
//             item.color = balanceColor;
//
//           }else if (item.name == 'btc_o') {
//             await Future.delayed(Duration(seconds: 4));
//             double? trxBalance = await _apiService.getBitcoinBalance(item.code);
//             balanceColor = getBalanceColor(trxBalance!);
//             print('TRX Balance: $trxBalance, Color: $balanceColor');
//
//             // به‌روزرسانی قیمت و رنگ آیتم
//             item.price = trxBalance;
//             item.color = balanceColor;
//
//           }else if (item.name == 'btc_n') {
//             await Future.delayed(Duration(seconds: 4));
//             double? trxBalance = await _apiService.getBitcoinBalance(item.code);
//             balanceColor = getBalanceColor(trxBalance!);
//             print('TRX Balance: $trxBalance, Color: $balanceColor');
//
//             // به‌روزرسانی قیمت و رنگ آیتم
//             item.price = trxBalance;
//             item.color = balanceColor;
//
//           } else {
//             print('Unknown item: ${item.name}');
//             continue;
//           }
//
//           // اضافه کردن آیتم بروزرسانی‌شده به لیست
//           updatedItems.add(item);
//
//           // ذخیره رنگ در لیست برای بررسی بعدی
//           balanceColors.add(balanceColor);
//         }
//
//         // بررسی اینکه آیا همه رنگ‌ها نارنجی هستند
//         bool allOrange = balanceColors.every((color) => color == 'orange');
//         final dbRepo = DatabaseRepositoryImpl();
//         // بروزرسانی اطلاعات در پایگاه‌داده
//         await dbRepo.updateItemPriceAndColor(machine.id, updatedItems);
//
//         // فراخوانی متد مناسب
//         if (allOrange)
//           sendToOrangeMethod(machine.id); // ارسال به متد نارنجی
//         // } else {
//          // sendToGreenMethod(machine.id); // ارسال به متد سبز
//         // }
//         updatedItems.clear();
//         //await Future.delayed(Duration(seconds: 1));
//       }
//
//       // final dbRepo = DatabaseRepositoryImpl();
//       // // پس از تکمیل پردازش‌ها، تمام اطلاعات ماشین‌ها و آیتم‌ها را چاپ کنید
//       // print('Updated Machine Data (After Update):');
//       // final List<MachineEntity> updatedMachines = await dbRepo.getMachineWithItems();
//       // updatedMachines.forEach((machine) {
//       //   print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
//       //   machine.items.forEach((item) {
//       //     print('Item: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
//       //   });
//       // });
//
//     } else {
//       print('لیست ماشین‌ها خالی است.');
//     }
//    // ensureDatabaseIsFilledAndProcess();
//   }
//
//   // Future<void> loopCheck(List<MachineEntity> machines) async {
//   //   if (machines.isNotEmpty) {
//   //     print('Raw Machine Data (Before Update):');
//   //     List<String> balanceColors = [];
//   //
//   //     for (var machine in machines) {
//   //       print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
//   //
//   //       final apiRecordMap = await apiService.fetchAPIRecords();
//   //       List<ItemEntity> updatedItems = [];
//   //
//   //       for (var item in machine.items) {
//   //         print('in toooooo');
//   //         print('Raw Item: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
//   //
//   //         String balanceColor = await getBalanceColorForItem(item, apiRecordMap);
//   //         print('${item.name} Balance: ${item.price}, Color: $balanceColor');
//   //
//   //         item.color = balanceColor;
//   //         updatedItems.add(item);
//   //         balanceColors.add(balanceColor);
//   //       }
//   //
//   //       bool allOrange = balanceColors.every((color) => color == 'orange');
//   //       await dbRepo.updateItemPriceAndColor(machine.id, updatedItems);
//   //
//   //       if (allOrange) {
//   //         await sendToOrangeMethod(machine.id);
//   //       } else {
//   //        // await sendToGreenMethod(machine.id);
//   //       }
//   //       updatedItems.clear();
//   //     }
//   //   } else {
//   //     print('لیست ماشین‌ها خالی است.');
//   //   }
//   // }
//
//   // Future<String> getBalanceColorForItem(ItemEntity item, API_Record? apiRecordMap) async {
//   //   double balance = 0.0;
//   //
//   //   switch (item.name) {
//   //     case 'usdt':
//   //       balance = await apiService.getUsdtBalance(item.code, apiRecordMap!.bscScanApi);
//   //       break;
//   //     case 'bnb':
//   //       balance = await apiService.getBnbBalance(item.code, apiRecordMap!.bscScanApi);
//   //       break;
//   //     case 'eth':
//   //       balance = await apiService.getEthBalance(item.code, apiRecordMap!.etherscanApi);
//   //       break;
//   //     case 'busd':
//   //       balance = await apiService.getBusdBalance(item.code, apiRecordMap!.bscScanApi);
//   //       break;
//   //     case 'trx':
//   //       balance = await apiService.getTrxBalance(item.code);
//   //       break;
//   //     case 'btc_n': balance =0.0;
//   //     case 'btc_o':balance =0.0;
//   //       return 'orange'; // For these two, the color will always be orange
//   //     default:
//   //       throw Exception('Unknown item: ${item.name}');
//   //   }
//   //
//   //   return getBalanceColor(balance);
//   // }
//   //
//   // String getBalanceColor(double balance) {
//   //   return balance > 0.0 ? 'green' : 'orange';
//   // }
//   void sendToOrangeMethod(String machineId) async {
//     final dbRepo = DatabaseRepositoryImpl();
//
//     // دریافت اطلاعات ماشین از دیتابیس با استفاده از machineId
//     MachineEntity? machine = await dbRepo.getMachineById(machineId);
//
//     if (machine != null) {
//       print('All items are orange. Sending data to orange method...');
//
//       // چاپ اطلاعات کامل ماشین
//       print('Machine Details:');
//       print('Machine ID: ${machine.id}');
//       print('Machine Name: ${machine.name}');
//       print('Machine Memonic: ${machine.memonic}');
//       print('Machine Parts:');
//       for (var item in machine.items) {
//         print('Item Name: ${item.name}');
//         print('Item Code: ${item.code}');
//         print('Item Price: ${item.price}');
//         print('Item Color: ${item.color}');
//       }
//       final dbRepoview = DatabaseRepositoryImplView();
//       // فراخوانی متد insertMachine برای ذخیره اطلاعات
//       await dbRepoview.insertMachine(machine);
//       print('Data has been successfully inserted into the database.');
//
//       dbRepo.deleteMachine(machineId);
//
//       try {
//                   final machinesWithItems = await dbRepoview.getMachineWithItems();
//                   machinesWithItems.forEach((machine) {
//                     print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
//                     machine.items.forEach((item) {
//                       print('Item Name: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
//                     });
//                   });
//                 } catch (e) {
//                   print('Error: $e');
//                 }
//     } else {
//       print('Machine with ID $machineId not found.');
//     }
//   }
//   // Future<void> sendToOrangeMethod(String machineId) async {
//   //
//   //
//   //   final machine = await dbRepo.getMachineById(machineId);
//   //   if (machine != null) {
//   //     print('All items are orange. Sending data to orange method...');
//   //     printMachineDetails(machine);
//   //     final dbRepoview = DatabaseRepositoryImplView();
//   //     // // فراخوانی متد insertMachine برای ذخیره اطلاعات
//   //     // await dbRepoview.insertMachine(machine);
//   //     // print('Data has been successfully inserted into the database.');
//   //
//   //     await dbRepo.deleteMachine(machineId);
//   //     try {
//   //           final machinesWithItems = await dbRepoview.getMachineWithItems();
//   //           machinesWithItems.forEach((machine) {
//   //             print('Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
//   //             machine.items.forEach((item) {
//   //               print('Item Name: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
//   //             });
//   //           });
//   //         } catch (e) {
//   //           print('Error: $e');
//   //         }
//   //   } else {
//   //     print('Machine with ID $machineId not found.');
//   //   }
//   // }
//
//   Future<void> sendToGreenMethod(String machineId) async {
//     final machine = await dbRepo.getMachineById(machineId);
//     if (machine != null) {
//       print('At least one item is green. Sending data to green method...');
//       printMachineDetails(machine);
//     } else {
//       print('Machine with ID $machineId not found.');
//     }
//
//
//   }
//
//   void printMachineDetails(MachineEntity machine) {
//     print('Machine ID: ${machine.id}');
//     print('Machine Name: ${machine.name}');
//     print('Machine Memonic: ${machine.memonic}');
//     machine.items.forEach((item) {
//       print('Item Name: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');
//     });
//   }
// }
//
//
// void main() async {
//   final dbRepo = DatabaseRepositoryImpl();
//   final apiService = ApiService();
//   final processor = MachineProcessor(dbRepo, apiService);
//
//   await processor.ensureDatabaseIsFilledAndProcess();
// }







import 'package:wallet_finder/cleancode_one/ApiService/ApiService.dart';
import 'package:wallet_finder/cleancode_one/Processor/MachineProcessor.dart';

import 'Database/DataBaseWallet/base/DatabaseRepositoryImpl.dart';
import 'Database/DataBaseWallet/view/DatabaseRepositoryImplView.dart';

void main() async {
  final db_base = DatabaseRepositoryImpl();
  final db_view = DatabaseRepositoryImplView();
  final apiService = ApiService_Wallet();
  final processor = MachineProcessor(db_base, apiService, db_view);

  await processor.ensureDatabaseIsFilledAndProcess();
}



// main.dart

//
// import 'package:flutter/material.dart';
// import 'package:wallet_finder/cleancode_one/runcode.dart';
//
// void main() async {
//   // اطمینان از اینکه فریم ورک فلاتر آماده است قبل از شروع برنامه
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // راه‌اندازی سرویس پس‌زمینه
//  // await initializeService();
//
//   // اجرای اپلیکیشن
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: Text('Background Service Example')),
//         body: Center(child: TextButton(onPressed: (){}, child: Text('ddddddddddd'))),
//       ),
//     );
//   }
// }
