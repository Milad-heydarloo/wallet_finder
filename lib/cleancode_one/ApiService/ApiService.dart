
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wallet_finder/cleancode_one/ApiService/ApiServiceBase.dart';

import '../../view_front_farbod/model/model_api_records.dart';
import '../Model/MachineEntity.dart';

class ApiService_Wallet implements ApiServiceBase {
  static final Dio dio = Dio();

  static const String _baseUrlFetchWalletRecords =
      'http://49.13.74.101:4000/assign';

  @override
  Future<List<MachineEntity>> fetchWalletRecords(String userId) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }

    print('Sending user_id: $userId');
    try {
      final response = await dio.post(
        _baseUrlFetchWalletRecords,
        data: {'user_id': userId},
        options: Options(headers: {'Content-Type': 'application/json'}),
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
        throw Exception(
            'Failed to fetch wallet records. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // چاپ جزئیات خطا
      if (e.response != null) {
        print('Response status: ${e.response!.statusCode}');
        print('Response data: ${e.response!.data}');
      } else {
        print('Error: $e');
      }
      rethrow;
    }
  }

  @override
  Future<double> getEthBalance(String address, String apiKey) async {
    final url =
        'https://api.etherscan.io/api?module=account&action=balance&address=$address&apikey=$apiKey';
    return _fetchBalance(url);
  }

  @override
  Future<double> getBnbBalance(String address, String apiKey) async {
    final url =
        'https://api.bscscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
    return _fetchBalance(url);
  }

  @override
  Future<double> getMaticBalance(String address, String apiKey) async {
    final url =
        'https://api.polygonscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
    return _fetchBalance(url);
  }

  @override
  Future<double> getTrxBalance(String address) async {
    final url = 'https://apilist.tronscanapi.com/api/account?address=$address';
    return _fetchTrxBalance(url);
  }

  @override
  Future<double> getUsdtBalance(String address, String apiKey) async {
    final url =
        'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0x55d398326f99059fF775485246999027B3197955&address=$address&tag=latest&apikey=$apiKey';
    return _fetchBalance(url);
  }

  @override
  Future<double> getBusdBalance(String address, String apiKey) async {
    final url =
        'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0xe9e7cea3dedca5984780bafc599bd69add087d56&address=$address&tag=latest&apikey=$apiKey';
    return _fetchBalance(url);
  }

  @override
  Future<double?> getBitcoinBalance(String address) async {
    final dio = Dio();
    final url =
        'https://api.blockcypher.com/v1/btc/main/addrs/$address/balance';

    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        // ارسال درخواست به API
        final response = await dio.get(url);
        // تأخیر 2 ثانیه‌ای بین درخواست‌ها
        await Future.delayed(Duration(seconds: 2));

        if (response.statusCode == 200) {
          // دریافت موجودی به صورت ساتوشی
          int balanceSatoshi = response.data['balance'];
          double balanceBtc = balanceSatoshi / 1e8; // تبدیل ساتوشی به بیت‌کوین
          return balanceBtc;
        } else {
          sendMessage('${response.statusCode}');
          print('Error fetching balance for $address: ${response.statusCode}');
          return null;
        }
      } catch (e) {
        sendMessage('${e}');
        print('Exception occurred: $e');
        return null;
      }
    }

    return null;
  }

  Future<double> _fetchBalance(String url) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == '1' && data['result'] != null) {
          return int.parse(data['result']) / 1e18;
        }
      }
    } catch (e) {
      sendMessage('${e}');
      print('Error fetching balance: $e');
    }
    return 0.0;
  }

  Future<double> _fetchTrxBalance(String url) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['balance'] != null) {
          return data['balance'] / 1e6;
        }
      }
    } catch (e) {
      sendMessage('${e}');
      print('Error fetching TRX balance: $e');
    }
    return 0.0;
  }

  static const String _baseUrlFetchAPIRecords =
      'http://49.13.74.101:5000/assign';

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
        sendMessage('${response.statusCode}');
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      sendMessage('${e}');
      print('Error fetching data: $e');
      return null;
    }
  }

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
        sendMessage('${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      sendMessage('${e}');
      throw Exception('Error fetching data: $e');
    }
  }

// متد ارسال پیام به چت
  Future<void> sendMessage(String dis) async {
    const url = 'http://49.13.74.101:5060/send_message';

    // داده‌ها برای ارسال
    final data = {
      'message': '${dis}',
      'chat_id': '-1002477741342',
    };

    try {
      // ایجاد نمونه Dio
      Dio dio = Dio();

      // ارسال درخواست POST
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // بررسی وضعیت پاسخ
      if (response.statusCode == 200) {
        print('پیام ارسال شد');
      } else {
        print('خطا در ارسال پیام: ${response.statusCode}');
      }
    } catch (e) {
      print('خطا: $e');
    }
  }
}
