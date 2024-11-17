import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wallet_finder/Getx_Wallet/Controller/Login_Rigester_Controller.dart';
import 'package:lottie/lottie.dart';

class LicensePage extends StatelessWidget {
  final AppController appController = Get.put(AppController());
  final TextEditingController _licenseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // تنظیم رنگ پس‌زمینه
      appBar: AppBar(
        backgroundColor: Colors.blue[50], // رنگ ناچ بار
        elevation: 0, // حذف سایه ناچ بار
      ),
      body: SingleChildScrollView( // اضافه کردن ScrollView برای جلوگیری از overflow
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // انیمیشن
            Lottie.network(
              'https://lottie.host/095d97b1-6749-45b7-be24-07eb2628fe12/hXevKgZKf3.json',
              height: 220, // تغییر ارتفاع انیمیشن
              width: double.infinity, // تنظیم عرض انیمیشن
            ),
            SizedBox(height: 20),
            // فیلد ورودی کد لایسنس

            // TextField with dynamic border color
            TextFormField(
              controller: _licenseController,
              decoration: InputDecoration(
                
                labelText: 'کد لایسنس',
                labelStyle: TextStyle(color: Colors.blue), // رنگ برچسب
                enabledBorder: OutlineInputBorder(

                  borderSide: BorderSide(

                    color: _licenseController.text.isEmpty
                        ? Colors.orange // زمانی که فیلد خالی است
                        : Colors.green, // زمانی که فیلد پر است
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.0), // گوشه‌های گرد
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green, // رنگ هنگام فوکوس
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, // رنگ هنگام خطا
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 20),

            // دکمه بررسی لایسنس
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: appController.isLoading.value
                      ? null
                      : () async {
                    final licenseCode = _licenseController.text.trim();
                    if (licenseCode.isEmpty) {
                      // نمایش پیام خطا
                      return;
                    }
                    await appController.verifyLicense(context, licenseCode);
                  },
                  child: appController.isLoading.value
                      ? CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  )
                      : Text('بررسی لایسنس', style: TextStyle(fontSize: 16)),
                ),
              );
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// void _showDialog(BuildContext context, String title, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(title),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text('تایید'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

