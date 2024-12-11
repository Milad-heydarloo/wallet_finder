
import 'package:get/get.dart';
import 'package:wallet_finder/Getx_Wallet/SharePrefrenss/DatabaseHelper.dart';


import 'package:flutter/foundation.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._internal();
  factory SharedPreferencesHelper() => _instance;

  SharedPreferencesHelper._internal();

  final _dbHelper = DatabaseHelper(); // استفاده از DatabaseHelper برای ذخیره‌سازی داده‌ها


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

// دریافت شناسه دستگاه
  Future<String?> getDeviceId() async {
    try {
      String? deviceId;
      if (GetPlatform.isAndroid) {
        deviceId = await _dbHelper.getSetting('androidInfo');
      } else if (GetPlatform.isIOS) {
        deviceId = await _dbHelper.getSetting('iosInfo');
      }
      print(deviceId);
      debugPrint('Device ID retrieved successfully');
      return deviceId;
    } catch (e, stackTrace) {
      debugPrint('Error retrieving Device ID: $e');
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
