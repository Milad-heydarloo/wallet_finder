
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:wallet_finder/Getx_Wallet/Rout/AppRoutes.dart';
import 'package:wallet_finder/Getx_Wallet/SharePrefrenss/share.dart';

// Future<void> main() async {
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'فعال‌سازی',
//       theme: ThemeData(
//         fontFamily: 'vazir',
//       ),
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.terms,
//       getPages: AppRoutes.getPages,
//     );
//   }
//
//
//   Future<Map<String, dynamic>> _loadData() async {
//     final termsAccepted = await prefsHelper.isTermsAccepted();
//     final deviceId = await prefsHelper.getDeviceId();
//     final botUrl = await prefsHelper.getBotUrl();
//     final isLicenseValid = await prefsHelper.isLicenseValid();
//     final remainingDays = await prefsHelper.getRemainingDays();
//
//     return {
//       'termsAccepted': termsAccepted,
//       'deviceId': deviceId,
//       'botUrl': botUrl,
//       'isLicenseValid': isLicenseValid,
//       'expiration_time': remainingDays,
//     };
//   }
// }
//
//





import 'package:flutter/material.dart';
import 'dart:math';

//
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CirclePage(),
//     );
//   }
// }
//
// class CirclePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("دایره‌ها")),
//       body: Center(
//         child: CustomPaint(
//           size: Size(400, 400),
//           painter: CirclePainter(),
//         ),
//       ),
//     );
//   }
// }
//
// class CirclePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final Paint textPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;
//
//     // رسم دایره اول در وسط صفحه
//     canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
//
//     // رسم دایره بیرونی که به 7 قسمت تقسیم شده است
//     paint.color = Colors.red.withOpacity(0.5);
//     double outerRadius = 180; // شعاع دایره بیرونی
//     double angleStep = 2 * pi / 7; // تقسیم دایره به 7 قسمت
//
//     // رسم هر بخش دایره بیرونی
//     for (int i = 0; i < 7; i++) {
//       double startAngle = i * angleStep;
//       double endAngle = startAngle + angleStep;
//
//       // رسم هر بخش دایره
//       Path path = Path()
//         ..moveTo(size.width / 2, size.height / 2)
//         ..lineTo(size.width / 2 + outerRadius * cos(startAngle), size.height / 2 + outerRadius * sin(startAngle))
//         ..arcTo(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: outerRadius), startAngle, angleStep, false)
//         ..close();
//       canvas.drawPath(path, paint);
//
//       // شماره‌گذاری بخش‌ها (داخل دایره)
//       TextSpan span = TextSpan(
//         text: '${i + 1}',
//         style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//       );
//       TextPainter tp = TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr,
//       );
//       tp.layout();
//
//       // محاسبه موقعیت برای متن (داخل دایره بیرونی)
//       double textX = size.width / 2 + (outerRadius - 20) * cos(startAngle + angleStep / 2);
//       double textY = size.height / 2 + (outerRadius - 20) * sin(startAngle + angleStep / 2);
//
//       // رسم متن
//       tp.paint(canvas, Offset(textX - tp.width / 2, textY - tp.height / 2));
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
//
//
//
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CirclePage(),
//     );
//   }
// }
//
// class CirclePage extends StatefulWidget {
//   @override
//   _CirclePageState createState() => _CirclePageState();
// }
//
// class _CirclePageState extends State<CirclePage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   bool isRotating = false; // متغیر برای چک کردن وضعیت چرخش
//
//   @override
//   void initState() {
//     super.initState();
//     // ساخت AnimationController
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     );
//
//     // تعریف یک Tween برای چرخش دایره
//     _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose(); // آزادسازی منابع
//     super.dispose();
//   }
//
//   void _onTap() {
//     setState(() {
//       if (isRotating) {
//         _controller.stop(); // متوقف کردن چرخش
//       } else {
//         _controller.repeat(); // شروع چرخش
//       }
//       isRotating = !isRotating; // تغییر وضعیت چرخش
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("دایره‌ها")),
//       body: Center(
//         child: GestureDetector(
//           onTap: _onTap, // شناسایی لمس روی دایره
//           child: AnimatedBuilder(
//             animation: _rotationAnimation,
//             builder: (context, child) {
//               return CustomPaint(
//                 size: Size(400, 400),
//                 painter: CirclePainter(rotation: _rotationAnimation.value),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CirclePainter extends CustomPainter {
//   final double rotation; // متغیر چرخش
//
//   CirclePainter({required this.rotation});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final Paint textPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;
//
//     // رسم دایره آبی در وسط صفحه
//     canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
//
//     // شعاع دایره بیرونی
//     double outerRadius = 180;
//     double angleStep = 2 * pi / 7; // تقسیم دایره به 7 قسمت
//
//     // رسم هر بخش دایره بیرونی برای اعداد
//     for (int i = 0; i < 7; i++) {
//       double startAngle = i * angleStep + rotation; // افزودن چرخش به زاویه
//
//       // محاسبه موقعیت برای متن (داخل دایره بیرونی)
//       double textX = size.width / 2 + (outerRadius - 20) * cos(startAngle + angleStep / 2);
//       double textY = size.height / 2 + (outerRadius - 20) * sin(startAngle + angleStep / 2);
//
//       // رسم کارت ویو برای هر عدد
//       final Rect cardRect = Rect.fromCircle(center: Offset(textX, textY), radius: 30);
//       final Paint cardPaint = Paint()
//         ..color = Colors.white
//         ..style = PaintingStyle.fill;
//       canvas.drawRRect(RRect.fromRectAndRadius(cardRect, Radius.circular(10)), cardPaint);
//
//       // شماره‌گذاری بخش‌ها (داخل کارت)
//       TextSpan span = TextSpan(
//         text: '${i + 1}',
//         style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//       );
//       TextPainter tp = TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr,
//       );
//       tp.layout();
//
//       // رسم متن داخل کارت ویو
//       tp.paint(canvas, Offset(textX - tp.width / 2, textY - tp.height / 2));
//     }
//
//     // رسم مربع با حاشیه گرد در پایین دایره
//     double squareSize = 60;
//     double squareX = size.width / 2 - squareSize / 2; // موقعیت افقی مربع
//     double squareY = size.height / 2 + outerRadius - 49; // موقعیت عمودی مربع (یکم پایین‌تر برای وسط قرار گرفتن)
//
//     final double borderRadius = 12; // شعاع گوشه‌ها (مقدار را می‌توانید تغییر دهید)
//
//     final Paint squareBorderPaint = Paint()
//       ..color = Colors.red // رنگ حاشیه
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4; // ضخامت حاشیه
//
//     final Paint squareFillPaint = Paint()
//       ..color = Colors.transparent // رنگ داخل مربع (خالی)
//       ..style = PaintingStyle.fill;
//
//     // رسم حاشیه مربع گرد (با وسط خالی)
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(Rect.fromLTWH(squareX, squareY, squareSize, squareSize), Radius.circular(borderRadius)),
//         squareBorderPaint);
//
//     // رسم داخل مربع به رنگ شفاف (خالی)
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(squareX + 4, squareY + 4, squareSize - 8, squareSize - 8),
//             Radius.circular(borderRadius - 4)),
//         squareFillPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true; // انیمیشن همیشه نیاز به بازخوانی دارد
//   }
// }
//
//
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CirclePage(),
//     );
//   }
// }
//
// class CirclePage extends StatefulWidget {
//   @override
//   _CirclePageState createState() => _CirclePageState();
// }
//
// class _CirclePageState extends State<CirclePage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   bool isRotating = false; // متغیر برای چک کردن وضعیت چرخش
//
//   @override
//   void initState() {
//     super.initState();
//     // ساخت AnimationController
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     );
//
//     // تعریف یک Tween برای چرخش دایره
//     _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose(); // آزادسازی منابع
//     super.dispose();
//   }
//
//   void _onTap() {
//     setState(() {
//       if (isRotating) {
//         _controller.stop(); // متوقف کردن چرخش
//       } else {
//         _controller.repeat(); // شروع چرخش
//       }
//       isRotating = !isRotating; // تغییر وضعیت چرخش
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("دایره‌ها")),
//       body: Center(
//         child: GestureDetector(
//           onTap: _onTap, // شناسایی لمس روی دایره
//           child: AnimatedBuilder(
//             animation: _rotationAnimation,
//             builder: (context, child) {
//               return CustomPaint(
//                 size: Size(400, 400),
//                 painter: CirclePainter(rotation: _rotationAnimation.value),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CirclePainter extends CustomPainter {
//   final double rotation; // متغیر چرخش
//
//   CirclePainter({required this.rotation});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final Paint textPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;
//
//     // رسم دایره آبی در وسط صفحه
//     canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
//
//     // شعاع دایره بیرونی
//     double outerRadius = 180;
//     double angleStep = 2 * pi / 7; // تقسیم دایره به 7 قسمت
//
//     // رسم هر بخش دایره بیرونی برای اعداد
//     for (int i = 0; i < 7; i++) {
//       double startAngle = i * angleStep + rotation; // افزودن چرخش به زاویه
//
//       // محاسبه موقعیت برای متن (داخل دایره بیرونی)
//       double textX = size.width / 2 + (outerRadius - 20) * cos(startAngle + angleStep / 2);
//       double textY = size.height / 2 + (outerRadius - 20) * sin(startAngle + angleStep / 2);
//
//       // رسم کارت ویو برای هر عدد
//       final Rect cardRect = Rect.fromCircle(center: Offset(textX, textY), radius: 30);
//       final Paint cardPaint = Paint()
//         ..color = Colors.white
//         ..style = PaintingStyle.fill;
//       canvas.drawRRect(RRect.fromRectAndRadius(cardRect, Radius.circular(10)), cardPaint);
//
//       // شماره‌گذاری بخش‌ها (داخل کارت)
//       TextSpan span = TextSpan(
//         text: '${i + 1}',
//         style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//       );
//       TextPainter tp = TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr,
//       );
//       tp.layout();
//
//       // رسم متن داخل کارت ویو
//       tp.paint(canvas, Offset(textX - tp.width / 2, textY - tp.height / 2));
//     }
//
//     // رسم مربع با حاشیه گرد در پایین دایره
//     double squareSize = 60;
//     double squareX = size.width / 2 - squareSize / 2; // موقعیت افقی مربع
//     double squareY = size.height / 2 + outerRadius - 49; // موقعیت عمودی مربع (یکم پایین‌تر برای وسط قرار گرفتن)
//
//     final double borderRadius = 12; // شعاع گوشه‌ها (مقدار را می‌توانید تغییر دهید)
//
//     final Paint squareBorderPaint = Paint()
//       ..color = Colors.red // رنگ حاشیه
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4; // ضخامت حاشیه
//
//     final Paint squareFillPaint = Paint()
//       ..color = Colors.transparent // رنگ داخل مربع (خالی)
//       ..style = PaintingStyle.fill;
//
//     // رسم حاشیه مربع گرد (با وسط خالی)
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(Rect.fromLTWH(squareX, squareY, squareSize, squareSize), Radius.circular(borderRadius)),
//         squareBorderPaint);
//
//     // رسم داخل مربع به رنگ شفاف (خالی)
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(squareX + 4, squareY + 4, squareSize - 8, squareSize - 8),
//             Radius.circular(borderRadius - 4)),
//         squareFillPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true; // انیمیشن همیشه نیاز به بازخوانی دارد
//   }
//   }




// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:animate_do/animate_do.dart'; // افزودن پکیج animate_do
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CirclePage(),
//     );
//   }
// }
//
// class CirclePage extends StatefulWidget {
//   @override
//   _CirclePageState createState() => _CirclePageState();
// }
//
// class _CirclePageState extends State<CirclePage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   bool isRotating = false;
//   int currentNumber = 1; // شروع از عدد 1
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     );
//     _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _onTap() {
//     setState(() {
//       if (isRotating) {
//         _controller.stop();
//       } else {
//         _controller.repeat();
//       }
//       isRotating = !isRotating;
//     });
//   }
//
//   void _updateNumber() {
//     setState(() {
//       currentNumber = (currentNumber % 7) + 1;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("دایره‌ها")),
//       body: Center(
//         child: GestureDetector(
//           onTap: () {
//             _onTap();
//             _updateNumber();
//           },
//           child: AnimatedBuilder(
//             animation: _rotationAnimation,
//             builder: (context, child) {
//               return CustomPaint(
//                 size: Size(400, 400),
//                 painter: CirclePainter(rotation: _rotationAnimation.value, currentNumber: currentNumber),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CirclePainter extends CustomPainter {
//   final double rotation;
//   final int currentNumber;
//
//   CirclePainter({required this.rotation, required this.currentNumber});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final Paint textPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
//
//     double outerRadius = 180;
//     double angleStep = 2 * pi / 7;
//
//     for (int i = 0; i < 7; i++) {
//       double startAngle = i * angleStep + rotation;
//
//       double textX = size.width / 2 + (outerRadius - 20) * cos(startAngle + angleStep / 2);
//       double textY = size.height / 2 + (outerRadius - 20) * sin(startAngle + angleStep / 2);
//
//       final Rect cardRect = Rect.fromCircle(center: Offset(textX, textY), radius: 30);
//       final Paint cardPaint = Paint()
//         ..color = Colors.white
//         ..style = PaintingStyle.fill;
//       canvas.drawRRect(RRect.fromRectAndRadius(cardRect, Radius.circular(10)), cardPaint);
//
//       TextSpan span = TextSpan(
//         text: '${i + 1}',
//         style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//       );
//       TextPainter tp = TextPainter(
//         text: span,
//         textAlign: TextAlign.center,
//         textDirection: TextDirection.ltr,
//       );
//       tp.layout();
//
//       tp.paint(canvas, Offset(textX - tp.width / 2, textY - tp.height / 2));
//     }
//
//     double squareSize = 60;
//     double squareX = size.width / 2 - squareSize / 2;
//     double squareY = size.height / 2 + outerRadius - 49;
//
//     final double borderRadius = 12;
//
//     final Paint squareBorderPaint = Paint()
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4;
//
//     final Paint squareFillPaint = Paint()
//       ..color = Colors.transparent
//       ..style = PaintingStyle.fill;
//
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(Rect.fromLTWH(squareX, squareY, squareSize, squareSize), Radius.circular(borderRadius)),
//         squareBorderPaint);
//
//     canvas.drawRRect(
//         RRect.fromRectAndRadius(
//             Rect.fromLTWH(squareX + 4, squareY + 4, squareSize - 8, squareSize - 8),
//             Radius.circular(borderRadius - 4)),
//         squareFillPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
//

//
// import 'dart:math';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Circular Motion',
//       debugShowCheckedModeBanner: false,
//       home: WheelOfFortune(),
//     );
//   }
// }
//
// class WheelOfFortune extends StatefulWidget {
//   @override
//   State<WheelOfFortune> createState() => _WheelOfFortuneState();
// }
//
// class _WheelOfFortuneState extends State<WheelOfFortune> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   int _currentNumber = 1;
//
//   final List<int> numbers = [1, 2, 3, 4, 5, 6, 7];
//   bool _isSpinning = false;
//   final int _delayTime = 3; // مکث 3 ثانیه‌ای
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 15),
//       vsync: this,
//     );
//
//     _rotationAnimation = Tween<double>(begin: 0, end: -2 * pi * 3).animate( // تغییر علامت زاویه
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // محاسبه عدد در موقعیت ثابت
//   int _getCurrentNumber(double rotationValue) {
//     int sections = numbers.length;
//     double anglePerSection = 2 * pi / sections;
//
//     int index = ((rotationValue / anglePerSection) % sections).floor();
//     if (index < 0) {
//       index += sections;
//     }
//     return numbers[index];
//   }
//
//   // تابع برای شروع چرخش و مکث
//   void _startSpin() async {
//     if (_isSpinning) return; // جلوگیری از چرخش دوباره در حال چرخش
//
//     setState(() {
//       _isSpinning = true;
//     });
//
//     _controller.reset();
//     _controller.forward();
//
//     // بعد از 3 ثانیه مکث، انیمیشن ادامه پیدا کند
//     _controller.addListener(() {
//       setState(() {
//         _currentNumber = _getCurrentNumber(_rotationAnimation.value);
//       });
//     });
//
//     // مکث بین دو چرخش
//     await Future.delayed(Duration(seconds: _delayTime)); // مکث 3 ثانیه‌ای
//
//     setState(() {
//       _isSpinning = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Circular Motion',
//           style: TextStyle(color: Colors.black),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 // اعداد چرخشی
//                 Stack(
//                   alignment: Alignment.center,
//                   children: List.generate(7, (index) {
//                     double angle = (360 / 7) * index * pi / 180;
//                     double radius = 150;
//
//                     return AnimatedBuilder(
//                       animation: _rotationAnimation,
//                       builder: (context, child) {
//                         return Transform.translate(
//                           offset: Offset(
//                             radius * cos(angle - _rotationAnimation.value), // تغییر علامت زاویه
//                             radius * sin(angle - _rotationAnimation.value), // تغییر علامت زاویه
//                           ),
//                           child: child,
//                         );
//                       },
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: Colors.primaries[index],
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Text(
//                             '${numbers[index]}',
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 20),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//
//                 // مرکز دایره (دکمه شروع چرخش)
//                 GestureDetector(
//                   onTap: _startSpin,
//                   child: Container(
//                     width: 90,
//                     height: 90,
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Spin',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 150), // فضای بیشتر برای مستطیل
//             // مستطیل نمایش عدد
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 'Number: $_currentNumber',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//


// import 'dart:math';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Circular Motion',
//       debugShowCheckedModeBanner: false,
//       home: WheelOfFortune(),
//     );
//   }
// }
//
// class WheelOfFortune extends StatefulWidget {
//   @override
//   State<WheelOfFortune> createState() => _WheelOfFortuneState();
// }
//
// class _WheelOfFortuneState extends State<WheelOfFortune> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   int _currentNumber = 1;
//
//   final List<int> numbers = [1, 2, 3, 4, 5, 6, 7];
//   bool _isSpinning = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 15),
//       vsync: this,
//     );
//
//     _rotationAnimation = Tween<double>(begin: 0, end: -2 * pi).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.linear),
//     );
//
//     // افزودن Listener به انیمیشن برای بروزرسانی عدد
//     _controller.addListener(() {
//       setState(() {
//         _currentNumber = _getCurrentNumber(_rotationAnimation.value);
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   // محاسبه عدد در موقعیت ثابت
//   int _getCurrentNumber(double rotationValue) {
//     int sections = numbers.length;
//     double anglePerSection = 2 * pi / sections;
//
//     int index = ((rotationValue / anglePerSection) % sections).floor();
//     if (index < 0) {
//       index += sections;
//     }
//     return numbers[index];
//   }
//
//   // تابع برای شروع و استپ انیمیشن
//   void _toggleSpin() {
//     if (_isSpinning) {
//       // اگر انیمیشن در حال پخش است، آن را متوقف کنیم
//       _controller.stop();
//     } else {
//       // اگر انیمیشن متوقف است، آن را از موقعیت کنونی ادامه دهیم
//       _controller.repeat(); // این دستور باعث می‌شود که انیمیشن به صورت بی‌پایان تکرار شود
//     }
//
//     setState(() {
//       _isSpinning = !_isSpinning; // وضعیت چرخش را تغییر می‌دهیم
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Circular Motion',
//           style: TextStyle(color: Colors.black),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 // اعداد چرخشی
//                 Stack(
//                   alignment: Alignment.center,
//                   children: List.generate(7, (index) {
//                     double angle = (360 / 7) * index * pi / 180;
//                     double radius = 150;
//
//                     return AnimatedBuilder(
//                       animation: _rotationAnimation,
//                       builder: (context, child) {
//                         return Transform.translate(
//                           offset: Offset(
//                             radius * cos(angle - _rotationAnimation.value),
//                             radius * sin(angle - _rotationAnimation.value),
//                           ),
//                           child: child,
//                         );
//                       },
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: Colors.primaries[index],
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Text(
//                             '${numbers[index]}',
//                             style: const TextStyle(
//                                 color: Colors.white, fontSize: 20),
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//
//                 // مرکز دایره (دکمه شروع چرخش)
//                 GestureDetector(
//                   onTap: _toggleSpin,
//                   child: Container(
//                     width: 90,
//                     height: 90,
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                     child: Center(
//                       child: Text(
//                         _isSpinning ? 'Stop' : 'Spin', // تغییر متن دکمه
//                         style: const TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 150), // فضای بیشتر برای مستطیل
//             // مستطیل نمایش عدد
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 'Number: $_currentNumber',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



class FortuneWheelController<T> extends ChangeNotifier {
  FortuneWheelChild<T>? value;
  bool isAnimating = false;
  bool shouldStartAnimation = false;

  void rotateTheWheel() {
    shouldStartAnimation = true;
    notifyListeners();
  }

  void animationStarted() {
    shouldStartAnimation = false;
    isAnimating = true;
  }

  void setValue(FortuneWheelChild<T> fortuneWheelChild) {
    value = fortuneWheelChild;
    notifyListeners();
  }

  void animationFinished() {
    isAnimating = false;
    shouldStartAnimation = false;
    notifyListeners();
  }
}

class TrianglePainter extends CustomPainter {
  final Color fillColor;
  TrianglePainter({this.fillColor = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return true;
  }
}

class WheelOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.33)
      ..strokeWidth = size.width / 25
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      (size.height / 2) - strokePaint.strokeWidth / 2,
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
class WheelSlice extends StatelessWidget {
  final int index;
  final double size;
  final List<FortuneWheelChild> fortuneWheelChildren;

  WheelSlice({
    required this.index,
    required this.size,
    required this.fortuneWheelChildren,
  });

  @override
  Widget build(BuildContext context) {
    int childCount = fortuneWheelChildren.length;
    double pieceAngle = (index / childCount) * pi * 2;
    double pieceWidth = (childCount == 2) ? size : sin(pi / childCount) * size / 2;
    double pieceHeight = size / 2;

    return Stack(
      children: [
        _getSliceBackground(pieceAngle, childCount),
        _getSliceForeground(pieceAngle, pieceWidth, pieceHeight),
      ],
    );
  }

  Widget _getSliceForeground(double pieceAngle, double pieceWidth, double pieceHeight) {
    double centerOffset = pi / fortuneWheelChildren.length;
    double leftRotationOffset = -pi / 2;

    return Transform.rotate(
      angle: leftRotationOffset + pieceAngle + centerOffset,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Positioned(
            top: size / 2,
            left: size / 2 - pieceWidth / 2,
            child: Container(
              padding: EdgeInsets.all(size / fortuneWheelChildren.length / 4),
              height: pieceHeight,
              width: pieceWidth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: -pieceAngle - leftRotationOffset * 2,
                  child: fortuneWheelChildren[index].foreground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Transform _getSliceBackground(double pieceAngle, int childCount) {
    return Transform.rotate(
      angle: pieceAngle,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            child: CustomPaint(
              painter: WheelSlicePainter(
                divider: childCount,
                number: index,
                color: fortuneWheelChildren[index].background,
              ),
              size: Size(size, size),
            ),
          ),
        ],
      ),
    );
  }
}


class WheelSlicePainter extends CustomPainter {
  final int divider;
  final int number;
  final Color? color;

  WheelSlicePainter({required this.divider, required this.number, required this.color});

  Paint? currentPaint;
  double angleWidth = 0;

  @override
  void paint(Canvas canvas, Size size) {
    _initializeFill();
    _drawSlice(canvas, size);
    _initializeStroke();
    _drawSlice(canvas, size);
  }

  void _initializeStroke() {
    currentPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
  }

  void _initializeFill() {
    currentPaint = Paint()
      ..color = color ?? Color.lerp(Colors.red, Colors.orange, number / (divider - 1))!;
    angleWidth = pi * 2 / divider;
  }

  void _drawSlice(Canvas canvas, Size size) {
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        height: size.height,
        width: size.width,
      ),
      0,
      angleWidth,
      true,
      currentPaint!,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class FortuneWheelChild<T> {
  final Widget foreground;
  final Color? background;
  final T value;

  FortuneWheelChild({
    required this.foreground,
    this.background,
    required this.value,
  });
}

class WheelResultIndicator extends StatelessWidget {
  final double wheelSize;
  final AnimationController animationController;
  final int childCount;

  WheelResultIndicator({
    required this.wheelSize,
    required this.animationController,
    required this.childCount,
  });

  @override
  Widget build(BuildContext context) {
    double indicatorSize = wheelSize / 10;
    Color indicatorColor = Colors.black;

    return Stack(
      children: [
        _getCenterIndicatorCircle(indicatorColor, indicatorSize),
        _getCenterIndicatorTriangle(wheelSize, indicatorSize, indicatorColor),
      ],
    );
  }

  Positioned _getCenterIndicatorTriangle(double wheelSize, double indicatorSize, Color indicatorColor) {
    return Positioned(
      top: wheelSize / 2 - indicatorSize,
      left: wheelSize / 2 - (indicatorSize / 2),
      child: AnimatedBuilder(
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            origin: Offset(0, indicatorSize / 2),
            angle: (animationController.value * pi * 2) - (pi / (childCount)),
            child: CustomPaint(
              painter: TrianglePainter(fillColor: indicatorColor),
              size: Size(indicatorSize, indicatorSize),
            ),
          );
        },
        animation: animationController,
      ),
    );
  }

  Center _getCenterIndicatorCircle(Color indicatorColor, double indicatorSize) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: indicatorColor,
        ),
        width: indicatorSize,
        height: indicatorSize,
      ),
    );
  }
}

class FortuneWheel<T> extends StatefulWidget {
  final FortuneWheelController<T> controller;
  final List<FortuneWheelChild<T>> children;
  final int turnsPerSecond;
  final int rotationTimeLowerBound;
  final int rotationTimeUpperBound;

  FortuneWheel({
    required this.controller,
    this.turnsPerSecond = 8,
    this.rotationTimeLowerBound = 2000,
    this.rotationTimeUpperBound = 4000,
    required this.children,
  }) : assert(children.length > 1, 'List with at least two elements must be given');

  @override
  _FortuneWheelState createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double size;

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initiateAnimation();
    _initiateControllerSubscription();
  }

  void _initiateAnimation() {
    _animationController = AnimationController(vsync: this, lowerBound: 0, upperBound: double.infinity);
    _animationController.addListener(() {
      widget.controller.setValue(
        widget.children[((widget.children.length) * (_animationController.value % 1)).floor()],
      );
      if (_animationController.isCompleted) {
        widget.controller.animationFinished();
      }
    });
  }

  void _initiateControllerSubscription() {
    widget.controller.addListener(() {
      if (!widget.controller.shouldStartAnimation || widget.controller.isAnimating) return;
      _startAnimation();
    });
  }

  void _startAnimation() {
    widget.controller.animationStarted();

    int milliseconds = Random().nextInt(widget.rotationTimeUpperBound - widget.rotationTimeLowerBound) +
        widget.rotationTimeLowerBound;

    double rotateDistance = (milliseconds / 1000) * widget.turnsPerSecond;
    _animationController.duration = Duration(milliseconds: milliseconds);

    _animationController.animateTo(_animationController.value + rotateDistance, curve: Curves.easeInOut);
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      size = min(constraints.maxHeight, constraints.maxWidth);
      return SizedBox(width: size, height: size, child: _getWheelContent());
    });
  }

  Stack _getWheelContent() {
    return Stack(
      children: [
        _getSlices(),
        _getCircleOutline(),
        _getIndicator(),
      ],
    );
  }

  WheelResultIndicator _getIndicator() => WheelResultIndicator(
    wheelSize: size,
    animationController: _animationController,
    childCount: widget.children.length,
  );

  Stack _getSlices() {
    double fourthCircleAngle = pi / 2;
    double pieceAngle = pi * 2 / widget.children.length;

    return Stack(
      children: [
        for (int index = 0; index < widget.children.length; index++)
          Transform.rotate(
            angle: (-fourthCircleAngle) - (pieceAngle / 2),
            child: WheelSlice(
                index: index,
                size: size,
                fortuneWheelChildren: widget.children
            ),
          ),
      ],
    );
  }

  CustomPaint _getCircleOutline() {
    return CustomPaint(painter: WheelOutlinePainter(), size: Size(size, size));
  }
}

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  FortuneWheelController<int> fortuneWheelController = FortuneWheelController();
  FortuneWheelChild<int>? currentWheelChild;
  int currentBalance = 0;

  @override
  void initState() {
    super.initState();
    fortuneWheelController.addListener(() {
      if (fortuneWheelController.value == null) return;

      setState(() {
        currentWheelChild = fortuneWheelController.value;
      });

      if (fortuneWheelController.isAnimating || fortuneWheelController.shouldStartAnimation) return;

      setState(() {
        currentBalance += fortuneWheelController.value!.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: currentBalance.isNegative ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Current balance: $currentBalance €',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 24),
            Divider(color: Colors.black87),
            SizedBox(height: 16),
            if (currentWheelChild != null)
              SizedBox(
                height: 80,
                width: 80,
                child: currentWheelChild!.foreground,
              ),
            SizedBox(height: 16),
            SizedBox(
              width: 350,
              height: 350,
              child: FortuneWheel<int>(
                controller: fortuneWheelController,
                children: [
                  _createFortuneWheelChild(-50),
                  _createFortuneWheelChild(1000),
                  _createFortuneWheelChild(-50),
                  _createFortuneWheelChild(-500),
                  _createFortuneWheelChild(-100),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => fortuneWheelController.rotateTheWheel(),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('ROTATE', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FortuneWheelChild<int> _createFortuneWheelChild(int value) {
    Color color = value.isNegative ? Colors.red : Colors.green;
    return FortuneWheelChild(
      foreground: _getWheelContentCircle(color, '${value.isNegative ? "Lose" : "Win"}\n${value.abs()} €'),
      value: value,
    );
  }

  Container _getWheelContentCircle(Color backgroundColor, String text) {
    return Container(
      width: 72,
      height: 72,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 4),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fortune Wheel',
      debugShowCheckedModeBanner: false,
      home: DemoScreen(),
    );
  }
}
