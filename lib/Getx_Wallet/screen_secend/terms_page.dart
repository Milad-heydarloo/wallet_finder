// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wallet_finder/Getx_Wallet/Controller/Login_Rigester_Controller.dart';

// class TermsPage extends StatefulWidget {
//   @override
//   State<TermsPage> createState() => _TermsPageState();
// }

// class _TermsPageState extends State<TermsPage> {
//   @override
//   void initState() {
//     super.initState();
//     controller.getDeviceId();
//   }

//   final controller = Get.put(AppController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('شرایط و قوانین')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('متن شرایط و قوانین اینجا قرار می‌گیرد.'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Get.toNamed('/register'); // انتقال به صفحه ثبت دستگاه
//               },
//               child: Text('پذیرفتن و ادامه'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wallet_finder/Getx_Wallet/Controller/Login_Rigester_Controller.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TermsPage extends StatefulWidget {
  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final controller = Get.put(AppController());
  bool isChecked = false; // وضعیت چک‌باکس
  bool isLoading = false; // وضعیت بارگذاری

  @override
  void initState() {
    super.initState();
    controller.getDeviceId(); // مقداردهی شناسه دستگاه
  }

  Future<void> _handleButtonPress() async {
    setState(() {
      isLoading = true; // شروع بارگذاری
    });

    try {
      await controller.saveTermsAccepted(); // ذخیره پذیرش شرایط
      await controller.registerDevice(); // ثبت دستگاه در سرور
      Get.toNamed('/register'); // انتقال به صفحه ثبت دستگاه
    } catch (e) {
      // مدیریت خطا (در صورت نیاز)
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false; // پایان بارگذاری
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.blue[50], // تنظیم رنگ پس‌زمینه
          appBar: AppBar(
            backgroundColor: Colors.blue[50], // رنگ ناچ بار
            elevation: 0, // حذف سایه ناچ بار
            automaticallyImplyLeading: false, // حذف دکمه Back
          ),
          body: Stack(
            children: [
              // لایه اسکرول‌شونده
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                    bottom: 120), // فضای کافی برای چک‌باکس و دکمه
                child: Column(
                  children: [
                    SizedBox(height: 15), // فاصله از بالا
                    SizedBox(
                      height: 200.0,
                      width: 200.0,
                      child: Lottie.network(
                        'https://lottie.host/50c1c90f-849c-45cb-a89b-b16e11e0ceb1/4zVmrTUHWL.json',
                      ),
                    ),
                    SizedBox(height: 20),

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
                          Text(
                            'خوش آمدید و از انتخاب شما سپاسگزاریم!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 10),
                          AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'قبل از استفاده از این برنامه لازم است بدانید که استفاده از آن برای مقاصد نادرست و غیرقانونی مجاز نیست. این برنامه صرفاً به‌عنوان ابزاری جهت افزایش آگاهی و ارتقای سطح امنیت طراحی شده است. هدف ما از ارائه این ابزار، آموزش و بهبود دانش امنیتی کاربران است. مسئولیت کامل نحوه استفاده از این برنامه و پیامدهای آن بر عهده شما خواهد بود.',
                                textAlign: TextAlign.justify,
                                textStyle: TextStyle(
                                  fontSize: 16,
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

                    SizedBox(height: 20),
                  ],
                ),
              ),
              // لایه چک‌باکس و دکمه
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color:
                  Colors.white, // پس‌زمینه سفید برای جدا کردن لایه پایینی
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              'متن فوق را مطالعه کرده و آن را می‌پذیرم',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF8128).withOpacity(1.0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                        isChecked && !isLoading ? _handleButtonPress : null,
                        // غیرفعال کردن دکمه در صورت بارگذاری یا عدم انتخاب چک‌باکس
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 5,
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: isLoading
                            ? SizedBox(

                          width: 20,
                          height: 20,

                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                            : Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center, // چینش در مرکز
                          children: [
                            Text(
                              'پذیرفتن و ادامه',
                              style:
                              TextStyle(fontSize: 16), // استایل متن
                            ),
                            SizedBox(width: 8), // فاصله بین متن و آیکون
                            Icon(
                              Icons.verified, // آیکون پیش‌فرض با سپر تیک
                              color: Colors.white, // رنگ آیکون
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
