import 'dart:async';
import 'package:get/get.dart';
import 'package:wallet_finder/view_front_farbod/model/model_api_records.dart';
import 'package:wallet_finder/view_front_farbod/model/model_balance_record.dart';
import 'package:wallet_finder/view_front_farbod/service/api_service.dart';
import 'package:wallet_finder/view_front_farbod/database/DatabaseHelper_Transaction.dart';
//
// class BalanceController extends GetxController {
//   final ApiService _apiService = ApiService();
//   final DatabaseHelper _dbService = DatabaseHelper();
//
//   RxList<BalanceRecord> balanceList = <BalanceRecord>[].obs;
//
//   RxList<MapEntry<String, String>> balances = <MapEntry<String, String>>[].obs;
//
//   var isSwitchEnabled = false.obs;
//
//   var totalItemsFetched = 0.obs;
//
//   var statusMessage = ''.obs;
//
//   Timer? _fetchTimer;
//
//   RxInt maxItems = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     checkDatabase();
//   }
//
//   Future<void> checkDatabase() async {
//     final dbItems = await _dbService.getAllTransactions();
//     balanceList.assignAll(dbItems);
//     maxItems.value = balanceList.length;
//
//     if (balanceList.isEmpty) {
//       statusMessage.value = 'Fetching new records from server...';
//       final fetchedRecords = await _apiService.fetchWalletRecords();
//
//       for (var record in fetchedRecords) {
//         if (!balanceList.any((item) => item.id == record.id)) {
//           balanceList.add(record);
//         }
//       }
//       maxItems.value = balanceList.length;
//       await _dbService.insertTransactions(fetchedRecords);
//
//
//       balanceList.addAll(fetchedRecords);
//
//       statusMessage.value = 'Data fetched successfully!';
//     }
//   }
//
//   Future<void> handleSwitchAction() async {
//     if (_fetchTimer != null) {
//       _fetchTimer!.cancel();
//       _fetchTimer = null;
//     }
//
//     if (isSwitchEnabled.value) {
//       _fetchTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
//         if (balanceList.isNotEmpty) {
//
//           final currentRecord = balanceList.first;
//
//           balances.assignAll(currentRecord
//               .toJson()
//               .entries
//               .map((entry) => MapEntry(entry.key,
//                   entry.value.toString()))
//               .toList());
//
//           final apiRecord = await _apiService.fetchAPIRecords();
//
//           if (apiRecord != null) {
//             print('Fetched API Record: ${apiRecord.toJson()}');
//           }
//
//           await deleteRecord(currentRecord.id);
//           balanceList.removeAt(0);
//
//           totalItemsFetched.value += 1;
//
//           if (balanceList.isEmpty) {
//             await checkDatabase();
//           }
//
//           if (!isSwitchEnabled.value && balanceList.isEmpty) {
//             timer.cancel();
//             print('All records processed and switch is turned off.');
//           }
//         } else {
//           await checkDatabase();
//         }
//       });
//     }
//   }
//
//   Future<void> deleteRecord(String id) async {
//     await _dbService.delete(id);
//   }
//
//   @override
//   void onClose() {
//     _fetchTimer?.cancel();
//     super.onClose();
//   }
// }
//


class BalanceController extends GetxController {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbService = DatabaseHelper();

  RxList<BalanceRecord> balanceList = <BalanceRecord>[].obs;
  RxList<MapEntry<String, String>> balances = <MapEntry<String, String>>[].obs;

  var isSwitchEnabled = false.obs;
  var isLoading = false.obs;
  var totalItemsFetched = 0.obs;
  var statusMessage = ''.obs;
  Timer? _fetchTimer;
  var isProcessing = false.obs;
  RxInt maxItems = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkDatabase();
  }

  Future<void> checkDatabase() async {
    isLoading.value = true;

    final dbItems = await _dbService.getAllTransactions();
    balanceList.assignAll(dbItems);
    maxItems.value = balanceList.length;

    if (balanceList.isEmpty) {
      final fetchedRecords = await _apiService.fetchWalletRecords();

      for (var record in fetchedRecords) {
        if (!balanceList.any((item) => item.id == record.id)) {
          balanceList.add(record);
        }
      }

      await _dbService.insertTransactions(fetchedRecords);
      maxItems.value = balanceList.length;
    }

    isLoading.value = false;
  }

  Future<void> handleSwitchAction() async {
    if (_fetchTimer != null) {
      _fetchTimer!.cancel();
      _fetchTimer = null;
    }

    if (isSwitchEnabled.value) {
      _fetchTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
        if (balanceList.isNotEmpty && !isProcessing.value) {
          isProcessing.value = true;

          final currentRecord = balanceList.first;


          balances.assignAll(
            currentRecord
                .toJson()
                .entries
                .where((entry) => entry.key != 'id' &&entry.key!='btc_n'&&entry.key!='btc_o') // حذف id
                .map((entry) => MapEntry(entry.key, entry.value.toString())) // تبدیل مقدار به String
                .toList(),
          );





          final apiRecordMap = await _apiService.fetchAPIRecords();

          if (apiRecordMap != null) {

            // final ethEntry = balances.firstWhere(
            //       (entry) => entry.key == 'eth',
            //   orElse: () => MapEntry('eth', ''), // مقدار پیش‌فرض
            // );
            // double balance = await _apiService.getEthBalance(ethEntry.value, apiRecordMap.etherscanApi);
            // print("ETH Balance: $balance ETH");
            //
            // final bnbEntry = balances.firstWhere(
            //       (entry) => entry.key == 'bnb',
            //   orElse: () => MapEntry('bnb', ''), // مقدار پیش‌فرض
            // );
            //
            // double balancee = await _apiService.getBnbBalance(bnbEntry.value, apiRecordMap.bscScanApi);
            // print("BNB Balance: $balancee BNB");
            //
            //
            // final trxEntry = balances.firstWhere(
            //       (entry) => entry.key == 'trx',
            //   orElse: () => MapEntry('trx', ''), // مقدار پیش‌فرض
            // );
            // double balance_tron = await _apiService.getTrxBalance(trxEntry.value);
            // print("TRX Balance: $balance_tron TRX");
            //
            //
            // final usdtEntry = balances.firstWhere(
            //       (entry) => entry.key == 'usdt',
            //   orElse: () => MapEntry('usdt', ''), // مقدار پیش‌فرض
            // );
            // double bnbBalance = await _apiService.getBnbBalance(usdtEntry.value, apiRecordMap.bscScanApi);
            // double usdtBalance = await _apiService.getUsdtBalance(usdtEntry.value, apiRecordMap.bscScanApi);
            // double busdBalance = await _apiService.getBusdBalance(usdtEntry.value, apiRecordMap.bscScanApi);
            //
            // print("BNB Balance: $bnbBalance BNB");
            // print("USDT Balance: $usdtBalance USDT");
            // print("BUSD Balance: $busdBalance BUSD");
            //
            // پردازش BNB
            double bnbBalance = await _apiService.getBnbBalance('wallet_address', apiRecordMap.bscScanApi);
            _updateOrAddBalance('bnb', bnbBalance.toString());
            // پردازش ETH
            double ethBalance = await _apiService.getEthBalance('wallet_address', apiRecordMap.etherscanApi);
            _updateOrAddBalance('eth', ethBalance.toString());

            double busdBalance = await _apiService.getBusdBalance('wallet_address', apiRecordMap.bscScanApi);
            _updateOrAddBalance('busd', busdBalance.toString());

            // پردازش TRX
            double trxBalance = await _apiService.getTrxBalance('wallet_address');
            _updateOrAddBalance('trx', trxBalance.toString());

            // پردازش USDT
            double usdtBalance = await _apiService.getUsdtBalance('wallet_address', apiRecordMap.bscScanApi);
            _updateOrAddBalance('usdt', usdtBalance.toString());



            await Future.delayed(Duration(seconds: 3));
          } else {
            print('No API record found.');
          }


          await deleteRecord(currentRecord.id);
          balanceList.removeAt(0);

          totalItemsFetched.value += 1;

          if (balanceList.isEmpty) {
            statusMessage.value = 'Fetching new records from server...';

            final fetchedRecords = await _apiService.fetchWalletRecords();

            for (var record in fetchedRecords) {
              if (!balanceList.any((item) => item.id == record.id)) {
                balanceList.add(record);
              }
            }

            await _dbService.insertTransactions(fetchedRecords);
            balanceList.addAll(fetchedRecords);
            maxItems.value = balanceList.length;
            statusMessage.value = 'Data fetched successfully!';
          }

          isProcessing.value = false;

          if (!isSwitchEnabled.value && balanceList.isEmpty) {
            timer.cancel();
            print('All records processed and switch is turned off.');
          }
        }
      });
    }
  }
  void _updateOrAddBalance(String key, String value) {
    final index = balances.indexWhere((entry) => entry.key == key);
    if (index != -1) {
      balances[index] = MapEntry(key, value);
    } else {
      balances.add(MapEntry(key, value));
    }
  }
  Future<void> deleteRecord(String id) async {
    await _dbService.delete(id);
  }

  @override
  void onClose() {
    _fetchTimer?.cancel();
    super.onClose();
  }
}