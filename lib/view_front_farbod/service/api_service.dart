import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wallet_finder/view_front_farbod/model/model_balance_record.dart';
import 'package:wallet_finder/view_front_farbod/model/model_api_records.dart';

import '../../cleancode_one/cleannewedameh.dart';


class ApiService {

  static final Dio dio = Dio();


  static const String _baseUrlFetchWalletRecords = 'http://49.13.74.101:4000/assign';
  static const String _baseUrlFetchAPIRecords = 'http://49.13.74.101:5000/assign';
  Future<List<MachineEntity>> fetchWalletRecordswallet() async {
    try {
      final response = await dio.post(
        _baseUrlFetchWalletRecords,
        data: jsonEncode({'user_id': 'user123'}), // تبدیل به JSON
        options: Options(
          headers: {'Content-Type': 'application/json'}, // ارسال به عنوان JSON
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['assigned_records'];
        print('Number of records fetched: ${data.length}');
        print('${data.toList()}');

        // تبدیل داده‌ها به لیست MachineEntity
        return data.map((record) {
          return MachineEntity.fromJson(
              record); // تبدیل هر رکورد به MachineEntity
        }).toList();
      } else {
        print('Error: ${response.statusCode}');
        print('Response data: ${response.data}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<BalanceRecord>> fetchWalletRecords() async {
    try {
      final response = await dio.post(
        _baseUrlFetchWalletRecords,
        data: {'user_id': 'user123'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['assigned_records'];
        print('Number of records fetched: ${data.length}');
        print('${data.toList()}');
        print(response.data['assigned_records']);
        return data.map((record) => BalanceRecord.fromJson(record)).toList();


      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<API_Record?> fetchAPIRecords() async {
    try {
      final response = await dio.post(
        _baseUrlFetchAPIRecords,
        data: {'user_id': 'userId'},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return API_Record.fromJson(data['assigned_record']);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }






// متد برای دریافت موجودی ETH
  Future<double> getEthBalance(String address, String apiKey) async {
    String url =
        'https://api.etherscan.io/api?module=account&action=balance&address=$address&apikey=$apiKey';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == '1') {
          String result = data['result'];
          double etherBalance = int.parse(result) / 1e18; // Wei to Ether
          return etherBalance;
        } else {
          print("Error: ${data['message']}");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return 0.0;
  }

// متد برای دریافت موجودی BNB
  Future<double> getBnbBalance(String address, String apiKey) async {
    String url =
        'https://api.bscscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == '1') {
          double bnbBalance = int.parse(data['result']) / 1e18; // Wei to BNB
          return bnbBalance;
        } else {
          print("Error: ${data['message']}");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return 0.0;
  }

// متد برای دریافت موجودی MATIC
  Future<double> getMaticBalance(String address, String apiKey) async {
    String url =
        'https://api.polygonscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == '1') {
          double maticBalance = int.parse(data['result']) / 1e18; // Wei to MATIC
          return maticBalance;
        } else {
          print("Error: ${data['message']}");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return 0.0;
  }

// متد برای دریافت موجودی TRX
  Future<double> getTrxBalance(String address) async {
    String url = 'https://apilist.tronscanapi.com/api/account?address=$address';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['balance'] != null) {
          double balanceInTrx = data['balance'] / 1e6; // Sun to TRX
          return balanceInTrx;
        } else {
          print("Error: No balance found for the address");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return 0.0;
  }

// متد عمومی برای دریافت موجودی
  Future<double> getBalance(String url) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == '1' && data['result'] != null) {
          double balance = int.parse(data['result']) / 1e18; // Wei to main unit
          return balance;
        } else {
          print("Error: Invalid response or result is null.");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    return 0.0;
  }

// متد برای دریافت موجودی USDT
  Future<double> getUsdtBalance(String address, String apiKey) async {
    String url =
        'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0x55d398326f99059fF775485246999027B3197955&address=$address&tag=latest&apikey=$apiKey';
    return await getBalance(url);
  }

// متد برای دریافت موجودی BUSD
  Future<double> getBusdBalance(String address, String apiKey) async {
    String url =
        'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0xe9e7cea3dedca5984780bafc599bd69add087d56&address=$address&tag=latest&apikey=$apiKey';
    return await getBalance(url);
  }

// متد برای دریافت موجودی BTC
  Future<double> getBtcBalance(String address) async {
    String url = 'https://blockchain.info/q/addressbalance/$address';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        double balance = int.parse(response.data.toString()) / 1e8; // Satoshi to BTC
        return balance;
      }
    } catch (e) {
      print("Error: $e");
    }
    return 0.0;
  }

}



//
// import 'package:wallet_finder/view_front_farbod/api_service.dart';
//
// void main() async {
//   try {
//     // Fetch wallet records
//     List<BalanceRecord> walletRecords = await ApiService().fetchWalletRecords();
//     print('Wallet Records: $walletRecords');
//
//     // Fetch API records
//     API_Record? apiRecord = await ApiService().fetchAPIRecords();
//     print('API Record: $apiRecord');
//   } catch (e) {
//     print('Error: $e');
//   }
// }
