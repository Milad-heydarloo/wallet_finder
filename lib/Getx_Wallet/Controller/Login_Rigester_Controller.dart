
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_finder/Getx_Wallet/SharePrefrenss/DatabaseHelper.dart';



class AppController extends GetxController {
  var deviceId = ''.obs;
  var botUrl = ''.obs;
  var licenseCode = ''.obs;

  var isLoading = false.obs; // وضعیت بارگذاری

  final _dbHelper = DatabaseHelper(); // استفاده از DatabaseHelper

  // متد verifyLicense برای تایید کد لایسنس
  Future<void> verifyLicense(BuildContext context, String licenseCode) async {
    isLoading.value = true;
    try {
      bool isValid = await checkLicense(licenseCode);
      if (isValid) {
        Get.offAllNamed('/main');
      } else {
        showStyledDialog(context, 'کد لایسنس معتبر نیست');
      }
    } finally {
      isLoading.value = false; // غیرفعال کردن پروگرس بار در هر شرایط
    }
  }

  // چک کردن لایسنس
  Future<bool> checkLicense(String licenseCode) async {
    try {
      final url = Uri.parse('http://49.13.74.101:5005/check_license');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"license_code": licenseCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _dbHelper.saveSetting('exists', data['exists'].toString());
        await _dbHelper.saveSetting('expiration_time', data['expiration_time'].toString());
        return data['exists'];
      } else {
        print('Server returned error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during license check: $e');
      return false;
    }
  }


  // ذخیره‌سازی Bot URL
  Future<void> saveBotUrl(String botUrl) async {
    print('saveBotUrl');
    try {
      await _dbHelper.saveBotUrl( botUrl);
      debugPrint('Bot URL successfully saved.');
    } catch (e, stackTrace) {
      debugPrint('Error saving Bot URL: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

// ذخیره وضعیت پذیرش شرایط
  Future<void> saveTermsAccepted() async {
    try {
      await _dbHelper.saveSetting('termsAccepted', 'true');
      debugPrint('Terms accepted status successfully saved.');
    } catch (e, stackTrace) {
      debugPrint('Error saving terms accepted status: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  Future<bool> isTermsAccepted() async {
    String? termsAccepted = await _dbHelper.getSetting('termsAccepted');
    return termsAccepted == 'true';
  }



  // بازیابی مقدار ذخیره‌شده برای botUrl
  Future<String?> getBotUrl() async {
    return await _dbHelper.getSetting('botUrl');
  }

  // دریافت شناسه دستگاه
  Future<String?> getDeviceId() async {
    String? deviceId;

    if (GetPlatform.isAndroid) {
      deviceId = await _dbHelper.getSetting('androidInfo');
    } else if (GetPlatform.isIOS) {
      deviceId = await _dbHelper.getSetting('iosInfo');
    }

    return deviceId;
  }

//   // نمایش دیالوگ خطا
  Future<void> showStyledDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 140.0,
                  width: 140.0,
                  child: Lottie.network(
                      'https://lottie.host/81faac88-8514-404c-a0ca-1f37657ea6a5/45r23b84Bn.json')),
              SizedBox(height: 6),
              Text(
                'خطا',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD32F2F),
                ),
              ),
              SizedBox(height: 2),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600]),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'تایید',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }





  Future<void> openTelegramBot() async {
    // استفاده از دیتابیس برای گرفتن URL ربات
    final botUrl = await DatabaseHelper().getBotUrl();

    // لاگ برای بررسی URL دریافتی
    print('Received bot URL: $botUrl');

    if (botUrl != null) {
      String cleanedBotUrl = botUrl
          .replaceFirst("You are already registered!Your link:", "")
          .trim();

      // لاگ برای بررسی URL تمیز شده
      print('Cleaned bot URL: $cleanedBotUrl');

      final botDomain = cleanedBotUrl.replaceFirst("https://t.me/", "").split('?')[0];
      final startParameter = cleanedBotUrl.contains('?') ? cleanedBotUrl.split('?')[1] : '';

      // لاگ برای بررسی پارامترها
      print('Bot domain: $botDomain');
      print('Start parameter: $startParameter');

      // ساخت URL برای تلگرام
      final telegramUrl = "tg://resolve?domain=$botDomain&$startParameter";

      // لاگ برای بررسی URL نهایی
      print('Telegram URL: $telegramUrl');

      try {
        final Uri url = Uri.parse(telegramUrl);

        // بررسی قابلیت باز کردن URL
        if (await canLaunchUrl(url)) {
          print('Launching Telegram bot...');
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch URL: $telegramUrl');
        }
      } catch (e) {
        print("Error parsing URL: $e");
      }
    } else {
      print('Bot URL is null');
    }
  }

  // ثبت دستگاه در سرور
  Future<void> registerDevice() async {
    print('urlme');
    final url = Uri.parse('http://49.13.74.101:5005/submit_code');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"imei": deviceId.value}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      botUrl.value = data['message'];
      saveBotUrl(botUrl.value);
    } else {
      throw Exception('Failed to register device');
    }
  }
}


 // curl -X POST http://127.0.0.1:5000/assign ^
 // -H "Content-Type: application/json" ^
 // -d "{\"user_id\": \"user123\"}"