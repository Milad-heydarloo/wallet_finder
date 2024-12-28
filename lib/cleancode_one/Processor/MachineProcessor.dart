




import 'package:wallet_finder/cleancode_one/ApiService/ApiService.dart';
import 'package:wallet_finder/cleancode_one/Database/DataBaseWallet/base/DatabaseRepositoryImpl.dart';


import '../Database/DataBaseWallet/base/DatabaseRepository.dart';
import '../Database/DataBaseWallet/view/DatabaseRepositoryImplView.dart';
import '../Model/ItemEntity.dart';
import '../Model/MachineEntity.dart';

class MachineProcessor {
  final ApiService_Wallet apiService;
  final DatabaseRepository db_base;
  final DatabaseRepositoryImplView db_view;

  MachineProcessor(this.db_base, this.apiService, this.db_view);

  Future<void> ensureDatabaseIsFilledAndProcess() async {
    final machinesInDb = await db_base.getMachineEntitiesWithoutPriceAndColor();

    if (machinesInDb.length >= 2) {
      print('دیتابیس دارای حداقل دو رکورد است.');
      final selectedMachines = extractTwoMachines(machinesInDb);
      await loopCheck(selectedMachines);
    } else {
      print('دیتابیس کمتر از دو رکورد دارد، دریافت اطلاعات از API...');

      final machinesFromApi = await apiService.fetchWalletRecordswallet();
      for (var machine in machinesFromApi) {
        await db_base.insertMachine(machine);
      }

      final updatedMachinesInDb =
      await db_base.getMachineEntitiesWithoutPriceAndColor();
      if (updatedMachinesInDb.length >= 2) {
        final selectedMachines = extractTwoMachines(updatedMachinesInDb);
        await loopCheck(selectedMachines);
      } else {
        print('داده کافی حتی پس از دریافت از API موجود نیست.');
      }
    }
  }

  List<MachineEntity> extractTwoMachines(List<MachineEntity> machines) {
    return machines.take(2).toList();
  }

  Future<void> loopCheck(List<MachineEntity> machines) async {
    if (machines.isNotEmpty) {
      print('Raw Machine Data (Before Update):');
      final ApiService_Wallet _apiService = ApiService_Wallet();

      List<String> balanceColors = []; // لیستی برای ذخیره رنگ‌ها

      // برای هر ماشین در لیست
      for (var machine in machines) {
        // چاپ ویژگی‌های ماشین
        print(
            'Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');

        final apiRecordMap = await _apiService.fetchAPIRecords();
        List<ItemEntity> updatedItems =
        []; // لیستی برای ذخیره آیتم‌های بروزرسانی شده

        // بررسی آیتم‌ها در ماشین و پیدا کردن آیتم‌ها
        for (var item in machine.items) {
          print(
              'Raw Item: ${item.name}, Code: ${item.code}, Price: ${item.price}, Color: ${item.color}');

          String balanceColor;

          // بررسی بالانس‌ها و چاپ رنگ‌ها
          if (item.name == 'usdt') {
            await Future.delayed(Duration(milliseconds: 1000));
            double usdtBalance = await _apiService.getUsdtBalance(
                item.code, apiRecordMap!.bscScanApi);
            balanceColor = getBalanceColor(usdtBalance);
            print('USDT Balance: $usdtBalance, Color: $balanceColor');

            // به‌روزرسانی قیمت و رنگ آیتم
            item.price = usdtBalance; // به‌روزرسانی قیمت با بالانس
            item.color = balanceColor; // به‌روزرسانی رنگ با رنگ موجود
          } else if (item.name == 'bnb') {
            await Future.delayed(Duration(milliseconds: 1000));
            double bnbBalance = await _apiService.getBnbBalance(
                item.code, apiRecordMap!.bscScanApi);
            balanceColor = getBalanceColor(bnbBalance);
            print('BNB Balance: $bnbBalance, Color: $balanceColor');

            // به‌روزرسانی قیمت و رنگ آیتم
            item.price = bnbBalance;
            item.color = balanceColor;
          } else if (item.name == 'eth') {
            await Future.delayed(Duration(milliseconds: 1000));
            double ethBalance = await _apiService.getEthBalance(
                item.code, apiRecordMap!.etherscanApi);
            balanceColor = getBalanceColor(ethBalance);
            print('ETH Balance: $ethBalance, Color: $balanceColor');

            // به‌روزرسانی قیمت و رنگ آیتم
            item.price = ethBalance;
            item.color = balanceColor;
          } else if (item.name == 'busd') {
            await Future.delayed(Duration(milliseconds: 1000));
            double busdBalance = await _apiService.getBusdBalance(
                item.code, apiRecordMap!.bscScanApi);
            balanceColor = getBalanceColor(busdBalance);
            print('BUSD Balance: $busdBalance, Color: $balanceColor');

            // به‌روزرسانی قیمت و رنگ آیتم
            item.price = busdBalance;
            item.color = balanceColor;
          } else if (item.name == 'trx') {
            await Future.delayed(Duration(milliseconds: 1000));
            double trxBalance = await _apiService.getTrxBalance(item.code);
            balanceColor = getBalanceColor(trxBalance);
            print('TRX Balance: $trxBalance, Color: $balanceColor');

            // به‌روزرسانی قیمت و رنگ آیتم
            item.price = trxBalance;
            item.color = balanceColor;
          } else if (item.name == 'btc_o') {
            await Future.delayed(Duration(seconds: 3));
            double? trxBalance = await _apiService.getBitcoinBalance(item.code);
            balanceColor = getBalanceColor(trxBalance!);
            print('TRX Balance: $trxBalance, Color: $balanceColor');

            // به‌روزرسانی قیمت و رنگ آیتم
            item.price = trxBalance;
            item.color = balanceColor;
          } else if (item.name == 'btc_n') {
            await Future.delayed(Duration(seconds: 3));
            double? trxBalance = await _apiService.getBitcoinBalance(item.code);
            balanceColor = getBalanceColor(trxBalance!);
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
    } else {
      print('لیست ماشین‌ها خالی است.');
    }
    // ensureDatabaseIsFilledAndProcess();
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

      // فراخوانی متد insertMachine برای ذخیره اطلاعات
      await db_view.insertMachine(machine);
      print('Data has been successfully inserted into the database.');

      dbRepo.deleteMachine(machineId);

      try {
        final machinesWithItems = await db_view.getMachineWithItems();

        machinesWithItems.forEach((machine) {
          print(
              'Machine ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}');
          //  Future.delayed(Duration(seconds: 1000));
          // apiService. sendMessage('${'Wallet ID: ${machine.id}, Name: ${machine.name}, Memonic: ${machine.memonic}'}');
          machine.items.forEach((item) {
            //  Future.delayed(Duration(seconds: 1000));
            //   apiService. sendMessage('Item Name: ${item.name}, Addr: ${item.code}, Price: ${item.price}, Color: ${item.color}');
            print(
                'Item Name: ${item.name}, Addr: ${item.code}, Price: ${item.price}, Color: ${item.color}');
          });
        });
      } catch (e) {
        apiService.sendMessage('${e}');
        print('Error: $e');
      }
    } else {
      print('Machine with ID $machineId not found.');
    }
  }

  Future<void> sendToGreenMethod(String machineId) async {
    final machine = await db_base.getMachineById(machineId);
    if (machine != null) {
      print('At least one item is green. Sending data to green method...');
    } else {
      print('Machine with ID $machineId not found.');
    }
  }
}


// تعیین رنگ برای بالانس‌ها
String getBalanceColor(double balance) {
  if (balance > 0.0) {
    return 'green'; // سبز برای بالانس مثبت
  } else {
    return 'orange'; // نارنجی برای بالانس 0 یا منفی
  }
}
