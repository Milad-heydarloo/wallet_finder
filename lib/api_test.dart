


import 'dart:convert';
import 'package:http/http.dart' as http;


// Future<double> getEthBalance(String address, String apiKey) async {
//   // URL API Etherscan برای دریافت موجودی ETH
//   String url = 'https://api.etherscan.io/api?module=account&action=balance&address=$address&apikey=$apiKey';
//
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // بررسی اینکه آیا پاسخ موفقیت‌آمیز است
//       if (data['status'] == '1') {
//         String result = data['result'];
//         // تبدیل نتیجه از Wei به Ether
//         int weiBalance = int.parse(result);
//         //print("Error: ${data['result']}");
//         double etherBalance = weiBalance / 1e18; // استفاده صحیح از 1e18
//         return etherBalance;
//       } else {
//         print("Error: ${data['message']}");
//       }
//     } else {
//       print("Failed to load data. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
//   return 0.0; // در صورت بروز خطا یا عدم دریافت داده، مقدار پیش‌فرض 0 برگشت داده می‌شود.
// }
//
//
// Future<double> getBnbBalance(String address, String apiKey) async {
//   // URL API BscScan برای دریافت موجودی BNB
//   String url = 'https://api.bscscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
//
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // بررسی اینکه آیا پاسخ موفقیت‌آمیز است
//       if (data['status'] == '1') {
//         String result = data['result'];
//         // تبدیل نتیجه از Wei به BNB
//         int weiBalance = int.parse(result);
//         double bnbBalance = weiBalance / 1e18; // استفاده صحیح از 1e18
//         return bnbBalance;
//       } else {
//         print("Error: ${data['message']}");
//       }
//     } else {
//       print("Failed to load data. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
//   return 0.0; // در صورت بروز خطا یا عدم دریافت داده، مقدار پیش‌فرض 0 برگشت داده می‌شود.
// }
//
//
// Future<double> getMaticBalance(String address, String apiKey) async {
//   // URL API PolygonScan برای دریافت موجودی MATIC
//   String url = 'https://api.polygonscan.com/api?module=account&action=balance&address=$address&apikey=$apiKey';
//
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // بررسی اینکه آیا پاسخ موفقیت‌آمیز است
//       if (data['status'] == '1') {
//         String result = data['result'];
//         // تبدیل نتیجه از Wei به MATIC
//         int weiBalance = int.parse(result);
//         double maticBalance = weiBalance / 10e18;
//         return maticBalance;
//       } else {
//         print("Error: ${data['message']}");
//       }
//     } else {
//       print("Failed to load data. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
//   return 0.0; // در صورت بروز خطا یا عدم دریافت داده، مقدار پیش‌فرض 0 برگشت داده می‌شود.
// }
//
// Future<double> getTrxBalance(String address) async {
//   // URL API TronScan برای دریافت موجودی TRX
//   String url = 'https://apilist.tronscanapi.com/api/account?address=$address';
//
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // بررسی اینکه آیا پاسخ موفقیت‌آمیز است
//       if (data['balance'] != null) {
//         int balanceInSun = data['balance'];
//         double balanceInTrx = balanceInSun / 1e6;  // تبدیل از Sun به TRX
//         return balanceInTrx;
//       } else {
//         print("Error: No balance found for the address");
//       }
//     } else {
//       print("Failed to load data. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
//   return 0.0; // در صورت بروز خطا یا عدم دریافت داده، مقدار پیش‌فرض 0 برگشت داده می‌شود.
// }
//
//
//
// Future<double> getBalance(String address, String apiKey, String url) async {
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['status'] == '1' && data['result'] != null) {
//         int result = int.parse(data['result']);
//         return result / 1e18; // تبدیل از Wei یا Token unit به واحد اصلی
//       } else {
//         print("Error: Invalid response or result is null.");
//       }
//     } else {
//       print("Failed to load data. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
//   return 0.0; // در صورت بروز خطا یا عدم دریافت داده، مقدار پیش‌فرض 0 برگشت داده می‌شود.
// }
//
// // متد برای دریافت موجودی BNB
// Future<double> getBnbBalancee(String address, String apiKey) async {
//   String url = 'https://api.bscscan.com/api?module=account&action=balance&address=$address&tag=latest&apikey=$apiKey';
//   return await getBalance(address, apiKey, url);
// }
//
// // متد برای دریافت موجودی USDT
// Future<double> getUsdtBalance(String address, String apiKey) async {
//   String url = 'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0x55d398326f99059fF775485246999027B3197955&address=$address&tag=latest&apikey=$apiKey';
//   return await getBalance(address, apiKey, url);
// }
//
// // متد برای دریافت موجودی BUSD
// Future<double> getBusdBalance(String address, String apiKey) async {
//   String url = 'https://api.bscscan.com/api?module=account&action=tokenbalance&contractaddress=0xe9e7cea3dedca5984780bafc599bd69add087d56&address=$address&tag=latest&apikey=$apiKey';
//   return await getBalance(address, apiKey, url);
// }
//
//
// Future<double> getBtcBalance(String address) async {
//   try {
//     // ایجاد URL برای درخواست موجودی بیت‌کوین
//     String url = 'https://blockchain.info/q/addressbalance/$address';
//
//     // ارسال درخواست GET به API
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       // دریافت داده‌ها و تبدیل موجودی به مقدار قابل استفاده
//       int balance = int.parse(response.body);
//       return balance / 1e8; // تبدیل از satoshi به بیت‌کوین (1 BTC = 100,000,000 satoshi)
//     } else {
//       print("Failed to load data. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error: $e");
//   }
//   return 0.0; // در صورت بروز خطا یا عدم دریافت داده، مقدار پیش‌فرض 0 برگشت داده می‌شود.
// }

import 'package:dio/dio.dart';

final Dio dio = Dio();

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


void main() async {

  String address = "0x5bd441E835f7433BEd0d224dC7e77C1d7db3479e";
  String apiKey = "R6DM7H7H8KV8PFJ4H4131JG2KDE2Q5B582";

  double balance = await getEthBalance(address, apiKey);
  print("ETH Balance: $balance ETH");


  String address_bnb = "0x4F4b64706174Ec0E05485a8Cb325A1Bb2345816c";
  String apiKey_bscscan = "H82GYHNCD9K57BH1HK8KACXYQTIZQYIGHS";

  double balancee = await getBnbBalance(address_bnb, apiKey_bscscan);
  print("BNB Balance: $balancee BNB");

  String address_tron = "TFAG3BjKVDqs3C4fnciputw7UBkYMavFKc";  // آدرس TRX شما

  double balance_tron = await getTrxBalance(address_tron);
  print("TRX Balance: $balance_tron TRX");


  String address_bscscan = "0x4F4b64706174Ec0E05485a8Cb325A1Bb2345816c";  // آدرس BNB شما
  String apiKey_bscscan_ = "N1HG69CMFSYKRZVMA6V8Y1DR5J4URQ68SA";  // کلید API BscScan شما

  double bnbBalance = await getBnbBalance(address_bscscan, apiKey_bscscan_);
  double usdtBalance = await getUsdtBalance(address_bscscan, apiKey_bscscan_);
  double busdBalance = await getBusdBalance(address_bscscan, apiKey_bscscan_);

  print("BNB Balance: $bnbBalance BNB");
  print("USDT Balance: $usdtBalance USDT");
  print("BUSD Balance: $busdBalance BUSD");



  //etrum kar mikoneh
  // String address_matic = "0x5bd441E835f7433BEd0d224dC7e77C1d7db3479e";
  // String apiKey_polygonscan = "WRR2PXMSAM94UI1NZ8AVKPDTW9ZWPND3J5";
  //
  // double balanceee = await getMaticBalance(address_matic, apiKey_polygonscan);
  // print("MATIC Balance: $balanceee MATIC");

  // //
  // String addressO = "TFAG3BjKVDqs3C4fnciputw7UBkYMavFKc";  // آدرس اول بیت‌کوین
  // String addressN = "TFAG3BjKVDqs3C4fnciputw7UBkYMavFKc";  // آدرس دوم بیت‌کوین
  //
  // // دریافت موجودی برای هر آدرس
  // double btcBalanceO = await getBtcBalance(addressO);
  // double btcBalanceN = await getBtcBalance(addressN);
  //
  // print("BTC Balance (Address O): $btcBalanceO BTC");
  // print("BTC Balance (Address N): $btcBalanceN BTC");
}
