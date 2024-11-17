import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppController extends GetxController {
  var deviceId = ''.obs;
  var botUrl = ''.obs;
  var licenseCode = ''.obs;

  var isLoading = false.obs; // وضعیت بارگذاری

  // Future<void> verifyLicense(BuildContext context, String licenseCode) async {
  //   isLoading.value = true; // فعال کردن پروگرس بار
  //   bool isValid = await checkLicense(licenseCode);

  //   if (isValid) {
  //     Get.offAllNamed('/main'); // انتقال به صفحه اصلی
  //     isLoading.value = false; // غیرفعال کردن پروگرس بار
  //   } else {
  //     showStyledDialog(context, 'کد لایسنس معتبر نیست');
  //     isLoading.value = false; // غیرفعال کردن پروگرس بار
  //   }
  // }
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
              // Lottie.asset(
              //   'assets/error.json', // فایل Lottie انیمیشن خطا
              //   height: 120,
              //   width: 120,
              // ),
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
                  minimumSize: Size(double.infinity, 50), // اندازه دکمه
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

  // Future<bool> checkLicense(String licenseCode) async {
  //   final url = Uri.parse('http://168.119.109.181:5000/check_license');
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"license_code": licenseCode}),
  //   );

  //   if (response.statusCode == 200) {
  //     final prefs = await SharedPreferences.getInstance();
  //     final data = jsonDecode(response.body);
  //     print('hooooooy');
  //     print(data);
  //     await prefs.setBool('exists', data['exists']);
  //     await prefs.setString('expiration_time', data['expiration_time']);

  //     return data['exists'];
  //   } else {
  //     throw Exception('Failed to check license');
  //   }
  // }
  Future<bool> checkLicense(String licenseCode) async {
    try {
      final url = Uri.parse('http://168.119.109.181:5000/check_license');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"license_code": licenseCode}),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = jsonDecode(response.body);
        print('Response Data: $data');
        await prefs.setBool('exists', data['exists']);
        await prefs.setString('expiration_time', data['expiration_time']);
        return data['exists'];
      } else {
        print('Server returned error: ${response.statusCode}');
        return false; // یا پیام مناسبی برای کاربر نشان دهید
      }
    } catch (e) {
      print('Error during license check: $e');
      return false; // از کرش کردن جلوگیری می‌کند
    }
  }

  Future<void> saveBotUrl(String botUrl) async {
    final prefs = await SharedPreferences.getInstance();
    print(botUrl);
    await prefs.setString('botUrl', botUrl);
  }

  Future<void> openTelegramBot() async {
    // دریافت لینک ربات از SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? botUrl =
        prefs.getString('botUrl'); // 'botUrl' باید از قبل ذخیره شده باشد

    if (botUrl != null) {
      // حذف متن اضافه و تمیز کردن لینک
      botUrl = botUrl
          .replaceFirst("You are already registered!Your link:", "")
          .trim();

      // تغییر پروتکل لینک به tg://resolve?domain= برای باز کردن تلگرام
      final botDomain = botUrl
          .replaceFirst("https://t.me/", "")
          .split('?')[0]; // دریافت نام ربات
      final startParameter = botUrl.split('?')[1]; // دریافت پارامتر start
      final telegramUrl =
          "tg://resolve?domain=$botDomain&$startParameter"; // ساخت لینک برای تلگرام

      print("Telegram bot URL: $telegramUrl");

      try {
        final Uri url = Uri.parse(telegramUrl);

        if (await canLaunchUrl(url)) {
          final launched =
              await launchUrl(url, mode: LaunchMode.externalApplication);
          if (!launched) {
            print('Could not open Telegram bot');
          }
        } else {
          print('Could not launch URL: $telegramUrl');
        }
      } catch (e) {
        print("Error parsing URL: $e");
      }
    } else {
      print("botUrl is null or empty");
    }
  }

  // سیو کردن شرایط و قوانین
  Future<void> saveTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('termsAccepted', true);
  }

  // چک کردن اینکه شرایط و قوانین قبلاً پذیرفته شده است یا نه
  Future<bool> isTermsAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('termsAccepted') ?? false;
  }

  // دریافت شناسه دستگاه
  Future<void> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      await prefs.setString('androidInfo', androidInfo.id!);
      deviceId.value = androidInfo.id!;
    } else if (GetPlatform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      await prefs.setString('iosInfo', iosInfo.identifierForVendor!);
      deviceId.value = iosInfo.identifierForVendor!;
    }
  }

  // ثبت دستگاه در سرور
  Future<void> registerDevice() async {
    final url = Uri.parse('http://168.119.109.181:5000/submit_code');
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
