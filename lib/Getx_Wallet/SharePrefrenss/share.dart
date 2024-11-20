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


// import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:wallet_finder/Getx_Wallet/SharePrefrenss/DatabaseHelper.dart';

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
//     final box = GetStorage();
//     return box.read('botUrl');
//   }
//
//   // بازیابی مقدار ذخیره شده برای termsAccepted
//   Future<bool> isTermsAccepted() async {
//     final box = GetStorage();
//     return box.read('termsAccepted') ?? false;
//   }
//
//   // بازیابی اطلاعات مربوط به remaining_days
//   Future<String?> getRemainingDays() async {
//     final box = GetStorage();
//     return box.read('expiration_time');
//   }
//
//   // بازیابی اطلاعات مربوط به exists
//   Future<bool> isLicenseValid() async {
//     final box = GetStorage();
//     return box.read('exists') ?? false;
//   }
//
//   // دریافت شناسه دستگاه
//   Future<String?> getDeviceId() async {
//     final box = GetStorage();
//     String? deviceId;
//
//     if (GetPlatform.isAndroid) {
//       deviceId = box.read('androidInfo');
//     } else if (GetPlatform.isIOS) {
//       deviceId = box.read('iosInfo');
//     }
//
//     return deviceId;
//   }
// }

//
// class SharedPreferencesHelper {
//   static final SharedPreferencesHelper _instance =
//   SharedPreferencesHelper._internal();
//   factory SharedPreferencesHelper() => _instance;
//
//   SharedPreferencesHelper._internal();
//
//   final _dbHelper = DatabaseHelper(); // استفاده از DatabaseHelper
//
//   // بازیابی مقدار ذخیره شده برای botUrl
//   Future<String?> getBotUrl() async {
//     return await _dbHelper.getSetting('botUrl');
//   }
//
//   // بازیابی اطلاعات مربوط به exists
//   Future<bool> isLicenseValid() async {
//     String? exists = await _dbHelper.getSetting('exists');
//     return exists == 'true';
//   }
//
//   // بازیابی اطلاعات مربوط به expiration_time
//   Future<String?> getRemainingDays() async {
//     return await _dbHelper.getSetting('expiration_time');
//   }
//
//   // دریافت شناسه دستگاه
//   Future<String?> getDeviceId() async {
//     String? deviceId;
//
//     if (GetPlatform.isAndroid) {
//       deviceId = await _dbHelper.getSetting('androidInfo');
//     } else if (GetPlatform.isIOS) {
//       deviceId = await _dbHelper.getSetting('iosInfo');
//     }
//
//     return deviceId;
//   }
// }
import 'package:get/get.dart'; // به‌منظور استفاده از GetPlatform
import 'DatabaseHelper.dart';  // فرض بر این است که کلاس DatabaseHelper در همین مسیر است

// class SharedPreferencesHelper {
//   static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
//   factory SharedPreferencesHelper() => _instance;
//
//   SharedPreferencesHelper._internal();
//
//   final _dbHelper = DatabaseHelper(); // استفاده از DatabaseHelper برای ذخیره‌سازی داده‌ها
//
//   // بازیابی مقدار ذخیره شده برای botUrl
//   Future<String?> getBotUrl() async {
//     return await _dbHelper.getSetting('botUrl');
//   }
//
//   // بازیابی اطلاعات مربوط به exists
//   Future<bool> isLicenseValid() async {
//     String? exists = await _dbHelper.getSetting('exists');
//     return exists == 'true'; // اگر exists مقدار 'true' داشت، یعنی لایسنس معتبر است
//   }
//
//   // بازیابی اطلاعات مربوط به expiration_time
//   Future<String?> getRemainingDays() async {
//     return await _dbHelper.getSetting('expiration_time');
//   }
//
//   // دریافت شناسه دستگاه
//   Future<String?> getDeviceId() async {
//     String? deviceId;
//
//     // بررسی پلتفرم و دریافت شناسه متناسب
//     if (GetPlatform.isAndroid) {
//       deviceId = await _dbHelper.getSetting('androidInfo');  // بازیابی اطلاعات مختص اندروید
//     } else if (GetPlatform.isIOS) {
//       deviceId = await _dbHelper.getSetting('iosInfo');  // بازیابی اطلاعات مختص iOS
//     }
//
//     return deviceId;
//   }
//
//   // بررسی اینکه آیا کاربر شرایط را پذیرفته است
//   Future<bool> isTermsAccepted() async {
//     String? termsAccepted = await _dbHelper.getSetting('termsAccepted');
//     return termsAccepted == 'true'; // اگر مقدار 'true' داشت، یعنی شرایط پذیرفته شده
//   }
//
//   // ذخیره کردن داده‌ها در پایگاه داده
//   Future<void> saveBotUrl(String botUrl) async {
//     await _dbHelper.saveSetting('botUrl', botUrl);  // ذخیره‌سازی آدرس URL ربات تلگرام
//   }
//
//   Future<void> saveLicenseValid(bool isValid) async {
//     await _dbHelper.saveSetting('exists', isValid ? 'true' : 'false');  // ذخیره وضعیت لایسنس
//   }
//
//   Future<void> saveRemainingDays(String expirationTime) async {
//     await _dbHelper.saveSetting('expiration_time', expirationTime);  // ذخیره زمان انقضا
//   }
//
//   Future<void> saveDeviceId(String deviceId) async {
//     if (GetPlatform.isAndroid) {
//       await _dbHelper.saveSetting('androidInfo', deviceId);  // ذخیره اطلاعات مختص اندروید
//     } else if (GetPlatform.isIOS) {
//       await _dbHelper.saveSetting('iosInfo', deviceId);  // ذخیره اطلاعات مختص iOS
//     }
//   }
//
//   // ذخیره کردن وضعیت پذیرش شرایط
//   Future<void> saveTermsAccepted(bool accepted) async {
//     await _dbHelper.saveSetting('termsAccepted', accepted ? 'true' : 'false'); // ذخیره وضعیت پذیرش شرایط
//   }
// }
// SharedPreferencesHelper.dart
// class SharedPreferencesHelper {
//   static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
//   factory SharedPreferencesHelper() => _instance;
//
//   SharedPreferencesHelper._internal();
//
//   final _dbHelper = DatabaseHelper(); // استفاده از DatabaseHelper برای ذخیره‌سازی داده‌ها
//
//   // بازیابی مقدار ذخیره شده برای botUrl
//   Future<String?> getBotUrl() async {
//     return await _dbHelper.getBotUrl(); // استفاده از getBotUrl برای دریافت URL ربات
//   }
//
//   // بازیابی اطلاعات مربوط به exists
//   Future<bool> isLicenseValid() async {
//     String? exists = await _dbHelper.getSetting('exists');
//     return exists == 'true'; // اگر exists مقدار 'true' داشت، یعنی لایسنس معتبر است
//   }
//
//   // بازیابی اطلاعات مربوط به expiration_time
//   Future<String?> getRemainingDays() async {
//     return await _dbHelper.getSetting('expiration_time');
//   }
//
//   // دریافت شناسه دستگاه
//   Future<String?> getDeviceId() async {
//     String? deviceId;
//
//     // بررسی پلتفرم و دریافت شناسه متناسب
//     if (GetPlatform.isAndroid) {
//       deviceId = await _dbHelper.getSetting('androidInfo');  // بازیابی اطلاعات مختص اندروید
//     } else if (GetPlatform.isIOS) {
//       deviceId = await _dbHelper.getSetting('iosInfo');  // بازیابی اطلاعات مختص iOS
//     }
//
//     return deviceId;
//   }
//
//   // بررسی اینکه آیا کاربر شرایط را پذیرفته است
//   Future<bool> isTermsAccepted() async {
//     String? termsAccepted = await _dbHelper.getSetting('termsAccepted');
//     return termsAccepted == 'true'; // اگر مقدار 'true' داشت، یعنی شرایط پذیرفته شده
//   }
//
//   // ذخیره کردن داده‌ها در پایگاه داده
//   Future<void> saveBotUrl(String botUrl) async {
//     await _dbHelper.saveBotUrl(botUrl);  // ذخیره‌سازی آدرس URL ربات تلگرام
//   }
//
//   Future<void> saveLicenseValid(bool isValid) async {
//     await _dbHelper.saveSetting('exists', isValid ? 'true' : 'false');  // ذخیره وضعیت لایسنس
//   }
//
//   Future<void> saveRemainingDays(String expirationTime) async {
//     await _dbHelper.saveSetting('expiration_time', expirationTime);  // ذخیره زمان انقضا
//   }
//
//   Future<void> saveDeviceId(String deviceId) async {
//     if (GetPlatform.isAndroid) {
//       await _dbHelper.saveSetting('androidInfo', deviceId);  // ذخیره اطلاعات مختص اندروید
//     } else if (GetPlatform.isIOS) {
//       await _dbHelper.saveSetting('iosInfo', deviceId);  // ذخیره اطلاعات مختص iOS
//     }
//   }
//
//   // ذخیره کردن وضعیت پذیرش شرایط
//   Future<void> saveTermsAccepted(bool accepted) async {
//     await _dbHelper.saveSetting('termsAccepted', accepted ? 'true' : 'false'); // ذخیره وضعیت پذیرش شرایط
//   }
// }


import 'package:flutter/foundation.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
  factory SharedPreferencesHelper() => _instance;

  SharedPreferencesHelper._internal();

  final _dbHelper = DatabaseHelper(); // استفاده از DatabaseHelper برای ذخیره‌سازی داده‌ها

  // بازیابی مقدار ذخیره شده برای botUrl
  Future<String?> getBotUrl() async {
    try {
      final botUrl = await _dbHelper.getBotUrl();
      debugPrint('Bot URL retrieved successfully');
      return botUrl;
    } catch (e, stackTrace) {
      debugPrint('Error retrieving Bot URL: $e');
      debugPrint('StackTrace: $stackTrace');
      return null; // بازگرداندن مقدار پیش‌فرض
    }
  }

  // بررسی لایسنس معتبر
  Future<bool> isLicenseValid() async {
    try {
      String? exists = await _dbHelper.getSetting('exists');
      final isValid = exists == 'true';
      debugPrint('License validity checked: $isValid');
      return isValid;
    } catch (e, stackTrace) {
      debugPrint('Error checking license validity: $e');
      debugPrint('StackTrace: $stackTrace');
      return false; // بازگرداندن مقدار پیش‌فرض
    }
  }

  // بازیابی زمان باقی‌مانده
  Future<String?> getRemainingDays() async {
    try {
      final expirationTime = await _dbHelper.getSetting('expiration_time');
      debugPrint('Expiration time retrieved successfully');
      return expirationTime;
    } catch (e, stackTrace) {
      debugPrint('Error retrieving expiration time: $e');
      debugPrint('StackTrace: $stackTrace');
      return null; // بازگرداندن مقدار پیش‌فرض
    }
  }

  // دریافت شناسه دستگاه
  Future<String?> getDeviceId() async {
    try {
      String? deviceId;
      if (GetPlatform.isAndroid) {
        deviceId = await _dbHelper.getSetting('androidInfo');
      } else if (GetPlatform.isIOS) {
        deviceId = await _dbHelper.getSetting('iosInfo');
      }
      debugPrint('Device ID retrieved successfully');
      return deviceId;
    } catch (e, stackTrace) {
      debugPrint('Error retrieving Device ID: $e');
      debugPrint('StackTrace: $stackTrace');
      return null; // بازگرداندن مقدار پیش‌فرض
    }
  }

  // بررسی وضعیت پذیرش شرایط
  Future<bool> isTermsAccepted() async {
    try {
      String? termsAccepted = await _dbHelper.getSetting('termsAccepted');
      final isAccepted = termsAccepted == 'true';
      debugPrint('Terms accepted status checked: $isAccepted');
      return isAccepted;
    } catch (e, stackTrace) {
      debugPrint('Error checking terms accepted status: $e');
      debugPrint('StackTrace: $stackTrace');
      return false; // بازگرداندن مقدار پیش‌فرض
    }
  }

  // ذخیره‌سازی URL ربات
  // Future<void> saveBotUrl(String botUrl) async {
  //   try {
  //     await _dbHelper.saveBotUrl(botUrl);
  //     debugPrint('Bot URL saved successfully');
  //   } catch (e, stackTrace) {
  //     debugPrint('Error saving Bot URL: $e');
  //     debugPrint('StackTrace: $stackTrace');
  //   }
  // }
  Future<void> saveBotUrl(String botUrl) async {
    try {
      // ذخیره‌سازی URL ربات
      await _dbHelper.saveSetting('botUrl', botUrl);
      debugPrint('Bot URL successfully saved.');
    } catch (e, stackTrace) {
      // لاگ خطا در صورت بروز مشکل در ذخیره‌سازی
      debugPrint('Error saving Bot URL: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  // ذخیره وضعیت لایسنس
  Future<void> saveLicenseValid(bool isValid) async {
    try {
      await _dbHelper.saveSetting('exists', isValid ? 'true' : 'false');
      debugPrint('License validity status saved: $isValid');
    } catch (e, stackTrace) {
      debugPrint('Error saving license validity status: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  // ذخیره زمان باقی‌مانده
  Future<void> saveRemainingDays(String expirationTime) async {
    try {
      await _dbHelper.saveSetting('expiration_time', expirationTime);
      debugPrint('Expiration time saved successfully');
    } catch (e, stackTrace) {
      debugPrint('Error saving expiration time: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  // ذخیره شناسه دستگاه
  Future<void> saveDeviceId(String deviceId) async {
    try {
      if (GetPlatform.isAndroid) {
        await _dbHelper.saveSetting('androidInfo', deviceId);
      } else if (GetPlatform.isIOS) {
        await _dbHelper.saveSetting('iosInfo', deviceId);
      }
      debugPrint('Device ID saved successfully');
    } catch (e, stackTrace) {
      debugPrint('Error saving Device ID: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  // ذخیره وضعیت پذیرش شرایط
  // Future<void> saveTermsAccepted(bool accepted) async {
  //   try {
  //     await _dbHelper.saveSetting('termsAccepted', accepted ? 'true' : 'false');
  //     debugPrint('Terms accepted status saved: $accepted');
  //   } catch (e, stackTrace) {
  //     debugPrint('Error saving terms accepted status: $e');
  //     debugPrint('StackTrace: $stackTrace');
  //   }
  // }
  Future<void> saveTermsAccepted() async {
    try {
      // ذخیره وضعیت پذیرش شرایط
      await _dbHelper.saveSetting('termsAccepted', 'true');
      debugPrint('Terms Accepted successfully saved.');
    } catch (e, stackTrace) {
      // لاگ خطا در صورت بروز مشکل
      debugPrint('Error saving Terms Accepted: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }
}
