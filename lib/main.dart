// // import 'package:flutter/material.dart';
// // import 'package:device_info_plus/device_info_plus.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:url_launcher/url_launcher.dart';
// // import 'dart:convert';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: HomePage(),
// //     );
// //   }
// // }
// //
// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   String? deviceId;
// //   String? licenseCode;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     showTermsDialog(context, () async {
// //       deviceId = await getDeviceId();
// //       String botUrl = await registerDevice(deviceId!);
// //       await openTelegramBot(botUrl);
// //     });
// //   }
// //
// //   // متد نمایش دیالوگ شرایط و قوانین
// //   void showTermsDialog(BuildContext context, Function onAccept) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     bool? isAccepted = prefs.getBool('termsAccepted');
// //
// //     if (isAccepted != true) {
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (context) => AlertDialog(
// //           title: Text('شرایط و قوانین'),
// //           content: Text('متن شرایط و قوانین اینجا قرار می‌گیرد.'),
// //           actions: [
// //             TextButton(
// //               onPressed: () async {
// //                 await prefs.setBool('termsAccepted', true);
// //                 onAccept();
// //                 Navigator.of(context).pop();
// //               },
// //               child: Text('پذیرفتن'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }
// //
// //   // دریافت شناسه دستگاه بسته به سیستم عامل
// //   Future<String> getDeviceId() async {
// //     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
// //     String deviceId;
// //
// //     if (Theme.of(context).platform == TargetPlatform.android) {
// //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
// //       deviceId = androidInfo.id!;
// //     } else if (Theme.of(context).platform == TargetPlatform.iOS) {
// //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
// //       deviceId = iosInfo.identifierForVendor!;
// //     } else {
// //       throw UnsupportedError("Unsupported platform");
// //     }
// //
// //     return deviceId;
// //   }
// //
// //   // ارسال شناسه دستگاه به سرور
// //   Future<String> registerDevice(String deviceId) async {
// //     final url = Uri.parse('http://168.119.109.181:5000/submit_code');
// //     final response = await http.post(
// //       url,
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode({"imei": deviceId}),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['message'];
// //     } else {
// //       throw Exception('Failed to register device');
// //     }
// //   }
// //
// //   // باز کردن لینک روبات تلگرام
// //   Future<void> openTelegramBot(String botUrl) async {
// //     if (await canLaunch(botUrl)) {
// //       await launch(botUrl);
// //     } else {
// //       throw 'Could not open Telegram bot';
// //     }
// //   }
// //
// //   // بررسی کد لایسنس
// //   Future<bool> checkLicense(String licenseCode) async {
// //     final url = Uri.parse('http://168.119.109.181:5000/check_license');
// //     final response = await http.post(
// //       url,
// //       headers: {"Content-Type": "application/json"},
// //       body: jsonEncode({"license_code": licenseCode}),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       return data['exists'];
// //     } else {
// //       throw Exception('Failed to check license');
// //     }
// //   }
// //
// //   // تایید لایسنس و هدایت به صفحه اصلی
// //   Future<void> verifyLicense() async {
// //     bool isValid = await checkLicense(licenseCode!);
// //     if (isValid) {
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(builder: (context) => MainScreen()),
// //       );
// //     } else {
// //       showDialog(
// //         context: context,
// //         builder: (context) => AlertDialog(
// //           title: Text('خطا'),
// //           content: Text('کد لایسنس معتبر نیست'),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(),
// //               child: Text('تایید'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("فعال‌سازی")),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextField(
// //               decoration: InputDecoration(labelText: "کد لایسنس"),
// //               onChanged: (value) {
// //                 licenseCode = value;
// //               },
// //             ),
// //             ElevatedButton(
// //               onPressed: verifyLicense,
// //               child: Text("تایید"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class MainScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("صفحه اصلی")),
// //       body: Center(child: Text("خوش آمدید!")),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:convert';
//
//
// void main() {
//   runApp(MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }
//
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   String? deviceId;
//   String? licenseCode;
//   String? botUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     showTermsDialog(context, () async {
//       deviceId = await getDeviceId();
//       botUrl = await registerDevice(deviceId!);
//
//       print('botUrl');
//       print(botUrl);
//       saveBotUrl(botUrl!);
//       setState(() {}); // بازخوانی ویجت برای نشان دادن لینک ذخیره شده
//     });
//   }
//
//   // متد نمایش دیالوگ شرایط و قوانین
//   void showTermsDialog(BuildContext context, Function onAccept) async {
//     final prefs = await SharedPreferences.getInstance();
//     bool? isAccepted = prefs.getBool('termsAccepted');
//
//     if (isAccepted != true) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => AlertDialog(
//           title: Text('شرایط و قوانین'),
//           content: Text('متن شرایط و قوانین اینجا قرار می‌گیرد.'),
//           actions: [
//             TextButton(
//               onPressed: () async {
//                 await prefs.setBool('termsAccepted', true);
//                 onAccept();
//                 Navigator.of(context).pop();
//               },
//               child: Text('پذیرفتن'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   // ذخیره لینک ربات در SharedPreferences
//   Future<void> saveBotUrl(String botUrl) async {
//     final prefs = await SharedPreferences.getInstance();
//     print(botUrl);
//     await prefs.setString('botUrl', botUrl);
//   }
//
//   // دریافت شناسه دستگاه بسته به سیستم عامل
//   Future<String> getDeviceId() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     String deviceId;
//
//     if (Theme.of(context).platform == TargetPlatform.android) {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       deviceId = androidInfo.id!;
//     } else if (Theme.of(context).platform == TargetPlatform.iOS) {
//       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       deviceId = iosInfo.identifierForVendor!;
//     } else {
//       throw UnsupportedError("Unsupported platform");
//     }
//
//     return deviceId;
//   }
//
//   // ارسال شناسه دستگاه به سرور
//   Future<String> registerDevice(String deviceId) async {
//     final url = Uri.parse('http://168.119.109.181:5000/submit_code');
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"imei": deviceId}),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['message'];
//     } else {
//       throw Exception('Failed to register device');
//     }
//   }
//
//
//
//
//   Future<void> openTelegramBot() async {
//     // دریافت لینک ربات از SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     String? botUrl = prefs.getString('botUrl');  // 'botUrl' باید از قبل ذخیره شده باشد
//
//     if (botUrl != null) {
//       // حذف متن اضافه و تمیز کردن لینک
//       botUrl = botUrl.replaceFirst("You are already registered!Your link:", "").trim();
//
//       // تغییر پروتکل لینک به tg://resolve?domain= برای باز کردن تلگرام
//       final botDomain = botUrl.replaceFirst("https://t.me/", "").split('?')[0];  // دریافت نام ربات
//       final startParameter = botUrl.split('?')[1];  // دریافت پارامتر start
//       final telegramUrl = "tg://resolve?domain=$botDomain&$startParameter"; // ساخت لینک برای تلگرام
//
//       print("Telegram bot URL: $telegramUrl");
//
//       try {
//         final Uri url = Uri.parse(telegramUrl);
//
//         if (await canLaunchUrl(url)) {
//           final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
//           if (!launched) {
//             print('Could not open Telegram bot');
//           }
//         } else {
//           print('Could not launch URL: $telegramUrl');
//         }
//       } catch (e) {
//         print("Error parsing URL: $e");
//       }
//     } else {
//       print("botUrl is null or empty");
//     }
//   }
//
//
//   // بررسی کد لایسنس
//   Future<bool> checkLicense(String licenseCode) async {
//     final url = Uri.parse('http://168.119.109.181:5000/check_license');
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"license_code": licenseCode}),
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['exists'];
//     } else {
//       throw Exception('Failed to check license');
//     }
//   }
//
//   // تایید لایسنس و هدایت به صفحه اصلی
//   Future<void> verifyLicense() async {
//     bool isValid = await checkLicense(licenseCode!);
//     if (isValid) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => MainScreen()),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('خطا'),
//           content: Text('کد لایسنس معتبر نیست'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('تایید'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("فعال‌سازی")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (botUrl != null)
//               ElevatedButton(
//                 onPressed: openTelegramBot,
//                 child: Text("باز کردن ربات تلگرام"),
//               ),
//             TextField(
//               decoration: InputDecoration(labelText: "کد لایسنس"),
//               onChanged: (value) {
//                 licenseCode = value;
//               },
//             ),
//             ElevatedButton(
//               onPressed: verifyLicense,
//               child: Text("تایید"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class MainScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("صفحه اصلی")),
//       body: Center(child: Text("خوش آمدید!")),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

import 'package:wallet_finder/Getx_Wallet/Rout/AppRoutes.dart';

Future<void> main() async {
  // await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'فعال‌سازی',
      theme: ThemeData(
        fontFamily: 'dm',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.terms,
      getPages: AppRoutes.getPages,
    );
  }
}
