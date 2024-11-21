import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_finder/Getx_Wallet/Controller/Login_Rigester_Controller.dart';

class RegisterPage extends StatelessWidget {
  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      backgroundColor: Colors.blue[50], // پس‌زمینه روشن
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent, // حذف پس‌زمینه ناچ بار
      //   elevation: 0, // حذف سایه
      //   centerTitle: true,
      //   automaticallyImplyLeading: false, // حذف دکمه Back
      // ),
      body: Stack(
        children: [
          // انیمیشن
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Lottie.network(
                'https://lottie.host/6ea5f828-9a74-41f5-8e06-01a20cf1648d/vkmzkakvua.json',
                height: 300,
              ),
            ),
          ),

          // متن توضیحی
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 380.0), // فاصله از انیمیشن
              child:



              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // رنگ پس‌زمینه مستطیل
                  borderRadius:
                  BorderRadius.circular(12.0), // گوشه‌های گرد
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // تنظیم سایه
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize
                      .min, // ارتفاع به اندازه محتوا تنظیم می‌شود
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(






                          'کاربر گرامی، لطفاً روی دکمه "باز کردن تلگرام" کلیک کنید و عضو ربات و چنلی که ربات معرفی می‌کند بشوید تا ثبت نام شما تکمیل شود.\nسپس لایسنس خود را از ربات گرفته و در بخش وارد کردن لایسنس وارد کنید.',


                          textAlign: TextAlign.justify,
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold ,
                            color: Colors.grey[700],
                          ),
                          speed: const Duration(
                              milliseconds: 50), // سرعت تایپ
                        ),
                      ],
                      totalRepeatCount: 1, // تعداد تکرار انیمیشن (۱ بار)
                      pause: const Duration(
                          milliseconds: 500), // مکث قبل از شروع دوباره
                      displayFullTextOnTap:
                      true, // نمایش کامل متن با کلیک
                      stopPauseOnTap: true, // توقف مکث با کلیک
                    ),
                  ],
                ),
              ),






            ),
          ),

          // دکمه‌ها
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon: Icon(Icons.arrow_back, size: 20), // آیکن بعدی
                      onPressed: () {
                        Get.toNamed('/licensePage');
                      },
                      label: Text(
                        'ثبت لایسنس',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 16), // فاصله بین دکمه‌ها
                  // دکمه "بعدی"
                  // دکمه "باز کردن تلگرام"
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      icon: Icon(Icons.telegram, size: 20), // آیکن تلگرام
                      onPressed: () async {
                        await controller.openTelegramBot();
                      },
                      label: Text(
                        'باز کردن تلگرام',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
