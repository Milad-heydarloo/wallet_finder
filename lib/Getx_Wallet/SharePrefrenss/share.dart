//
//
//
//
//
//
// import 'package:get/get_utils/src/platform/platform.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPreferencesHelper {
//   static final SharedPreferencesHelper _instance =
//   SharedPreferencesHelper._internal();
//
//   factory SharedPreferencesHelper() {
//     return _instance;
//   }
//
//   SharedPreferencesHelper._internal();
//
//   // بازیابی مقدار ذخیره شده برای botUrl
//   Future<String?> getBotUrl() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('botUrl');
//   }
//
//   // بازیابی مقدار ذخیره شده برای termsAccepted
//   Future<bool> isTermsAccepted() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('termsAccepted') ?? false;
//   }
//
//   // بازیابی اطلاعات مربوط به remaining_days
//   Future<String?> getRemainingDays() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('expiration_time');
//   }
//
//   // بازیابی اطلاعات مربوط به exists
//   Future<bool> isLicenseValid() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('exists') ?? false;
//   }
//
//   // // بازیابی اطلاعات مربوط به دستگاه برای Android
//   // Future<String?> getAndroidDeviceId() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return prefs.getString('androidInfo');
//   // }
//   //
//   // // بازیابی اطلاعات مربوط به دستگاه برای iOS
//   // Future<String?> getIosDeviceId() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return prefs.getString('iosInfo');
//   // }
//
//   Future<String?> getDeviceId() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? deviceId;
//
//     if (GetPlatform.isAndroid) {
//       deviceId = prefs.getString('androidInfo');
//     } else if (GetPlatform.isIOS) {
//       deviceId = prefs.getString('iosInfo');
//     }
//
//     return deviceId;
//   }
//
// }
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
  SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();

  // بازیابی مقدار ذخیره شده برای botUrl
  Future<String?> getBotUrl() async {
    final box = GetStorage();
    return box.read('botUrl');
  }

  // بازیابی مقدار ذخیره شده برای termsAccepted
  Future<bool> isTermsAccepted() async {
    final box = GetStorage();
    return box.read('termsAccepted') ?? false;
  }

  // بازیابی اطلاعات مربوط به remaining_days
  Future<String?> getRemainingDays() async {
    final box = GetStorage();
    return box.read('expiration_time');
  }

  // بازیابی اطلاعات مربوط به exists
  Future<bool> isLicenseValid() async {
    final box = GetStorage();
    return box.read('exists') ?? false;
  }

  // دریافت شناسه دستگاه
  Future<String?> getDeviceId() async {
    final box = GetStorage();
    String? deviceId;

    if (GetPlatform.isAndroid) {
      deviceId = box.read('androidInfo');
    } else if (GetPlatform.isIOS) {
      deviceId = box.read('iosInfo');
    }

    return deviceId;
  }
}
