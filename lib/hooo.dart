

// class ShapeAnimationController extends GetxController
//     with GetTickerProviderStateMixin {
//   late AnimationController circleAnimationController;
//   late AnimationController rectAnimationController;
//   late Animation<double> circleAnimation;
//   late Animation<double> rectAnimation;
//
//   var clickedPosition = Rxn<Offset>();
//   var clickedColor = Colors.blue.obs;
//
//   // وضعیت نمایش مستطیل برای هر آیتم
//   var showRectangleForIndex = List<bool>.generate(6, (index) => false).obs;
//
//   // موقعیت آیکن‌ها
//   var iconPositions =
//       List<Offset>.generate(6, (index) => Offset(50.0 + index * 70, 200)).obs;
//
//   double itemSize = 50.0; // اندازه آیتم‌ها
//   double screenWidth = 0; // عرض صفحه
//   double screenHeight = 0; // ارتفاع صفحه
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     circleAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//
//     rectAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//
//     circleAnimation = Tween<double>(begin: 0, end: 50).animate(
//       CurvedAnimation(
//         parent: circleAnimationController,
//         curve: Curves.easeOut,
//       ),
//     );
//
//     rectAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: rectAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }
//
//   // ذخیره اندازه صفحه
//   void initializeScreenSize(double width, double height) {
//     screenWidth = width;
//     screenHeight = height;
//   }
//
//   void startAnimation(int index, Offset position, MaterialColor color) {
//     // تغییر وضعیت نمایش مستطیل برای آیتم کلیک‌شده
//     showRectangleForIndex[index] = !showRectangleForIndex[index];
//     clickedPosition.value = position;
//     clickedColor.value = color; // گرفتن رنگ اصلی از MaterialColor
//
//     if (showRectangleForIndex[index]) {
//       circleAnimationController.forward().then((_) {
//         rectAnimationController.forward();
//       });
//     } else {
//       rectAnimationController.reverse().then((_) {
//         circleAnimationController.reverse();
//       });
//     }
//   }
//
//   void updateIconPosition(int index, Offset newPosition) {
//     // محدود کردن موقعیت به داخل صفحه
//     double clampedX = newPosition.dx.clamp(0.0, screenWidth - itemSize);
//     double clampedY = newPosition.dy.clamp(0.0, screenHeight - itemSize);
//     iconPositions[index] = Offset(clampedX, clampedY);
//   }
//
//   @override
//   void onClose() {
//     circleAnimationController.dispose();
//     rectAnimationController.dispose();
//     super.onClose();
//   }
// }
//
// class ShapeAnimationPage extends StatelessWidget {
//   final ShapeAnimationController controller =
//   Get.put(ShapeAnimationController());
//
//   @override
//   Widget build(BuildContext context) {
//     // گرفتن اندازه صفحه
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.initializeScreenSize(
//         MediaQuery.of(context).size.width,
//         MediaQuery.of(context).size.height,
//       );
//     });
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // آیتم‌های کلیک‌شدنی
//           Stack(
//             children: List.generate(6, (index) {
//               return Obx(() {
//                 return Positioned(
//                   left: controller.iconPositions[index].dx,
//                   top: controller.iconPositions[index].dy,
//                   child: Draggable(
//                     feedback: Container(
//                       width: controller.itemSize,
//                       height: controller.itemSize,
//                       decoration: BoxDecoration(
//                         color: Colors.primaries[index],
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     childWhenDragging: SizedBox.shrink(),
//                     onDragEnd: (details) {
//                       // موقعیت جدید را برای آیکن ذخیره می‌کنیم
//                       controller.updateIconPosition(
//                         index,
//                         details.offset,
//                       );
//                     },
//                     child: GestureDetector(
//                       onTap: () {
//                         controller.startAnimation(
//                           index,
//                           controller.iconPositions[index],
//                           Colors.primaries[index],
//                         );
//                       },
//                       child: Container(
//                         width: controller.itemSize,
//                         height: controller.itemSize,
//                         decoration: BoxDecoration(
//                           color: Colors.primaries[index],
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               });
//             }),
//           ),
//
//           // انیمیشن دایره و مستطیل
//           Obx(() {
//             return Stack(
//               children: List.generate(6, (index) {
//                 return Positioned(
//                   top: controller.iconPositions[index].dy + 60,
//                   // تغییر ارتفاع
//                   left: controller.iconPositions[index].dx - 50,
//                   // تغییر موقعیت
//                   child: AnimatedContainer(
//                     width: 150,
//                     height: controller.showRectangleForIndex[index] ? 100 : 0,
//                     duration: Duration(milliseconds: 500),
//                     curve: Curves.easeInOut,
//                     decoration: BoxDecoration(
//                       color: Colors.primaries[index].withOpacity(0.8),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: controller.showRectangleForIndex[index]
//                         ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.check_circle,
//                           size: 40,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(height: 10),
//                         GestureDetector(
//                           onTap: () {
//                             controller.startAnimation(
//                               index,
//                               controller.iconPositions[index],
//                               Colors.primaries[index],
//                             );
//                           },
//                           child: Icon(
//                             Icons.close,
//                             size: 30,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     )
//                         : null,
//                   ),
//                 );
//               }),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(GetMaterialApp(
//     home: ShapeAnimationPage(),
//   ));
// }
//
//

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

//
// void main() {
//   runApp(
//     MyApp(),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.green, // Set the app's primary theme color
//       ),
//       debugShowCheckedModeBanner: false,
//       home: BounceAnimationDemo(),
//     );
//   }
// }
//
// class BounceAnimationDemo extends StatefulWidget {
//   @override
//   _BounceAnimationDemoState createState() => _BounceAnimationDemoState();
// }
//
// class _BounceAnimationDemoState extends State<BounceAnimationDemo> {
//   double height = 100.0; // Initial height of the box
//
//   void _startBounceAnimation() {
//     setState(() {
//       height = 200.0; // Set the target height for the bounce animation
//     });
//
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         height = 100.0; // Reset the height after the bounce animation
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bounce Animation Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             AnimatedContainer(
//               duration: Duration(milliseconds: 500),
//               curve: Curves.bounceOut, // Use the bounce curve for animation
//               width: 100,
//               height: height, // Height of the box animated with a bounce effect
//               color: Colors.blue,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _startBounceAnimation,
//               child: Text('Start Bounce Animation'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//
// class CarromBall extends StatefulWidget {
//   @override
//   _CarromBallState createState() => _CarromBallState();
// }
//
// class _CarromBallState extends State<CarromBall> {
//   AlignmentGeometry alignment = Alignment.center;
//   Duration animationDuration = Duration(milliseconds: 500);
//   Color color = Colors.deepOrange;
//   Curve animationCurve = Curves.easeInOutBack;
//
//   AlignmentGeometry randomAlign() {
//     Map boolToSign = {
//       true: 1,
//       false: -1,
//     };
//     double x = boolToSign[Random().nextBool()] * Random().nextDouble();
//     double y = boolToSign[Random().nextBool()] * Random().nextDouble();
//     return Alignment(x, y);
//   }
//
//   Color randomColor() {
//     Map intToColor = {
//       0: Colors.deepOrange,
//       1: Colors.black,
//       2: Colors.deepPurple,
//       3: Colors.pink,
//       4: Colors.teal,
//       5: Colors.green[800],
//       6: Colors.blueAccent,
//     };
//     return intToColor[Random().nextInt(7)];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           // color: Colors.blueAccent,
//           child: AnimatedAlign(
//             duration: animationDuration,
//             curve: animationCurve,
//             alignment: alignment,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   alignment = randomAlign();
//                   color = randomColor();
//                 });
//               },
//               child: Card(
//                 elevation: 10.0,
//                 shape: CircleBorder(),
//                 child: AnimatedContainer(
//                   curve: animationCurve,
//                   duration: animationDuration,
//                   width: 80.0,
//                   height: 80.0,
//                   decoration: BoxDecoration(
//                     color: color,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text('PRESS',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20.0,
//                           fontWeight: FontWeight.bold,
//                         )),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Animations',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: CarromBall(),
//     );
//   }
// }



//
// void main() {
//   runApp(const MainApp());
// }
//
// class MainApp extends StatefulWidget {
//   const MainApp({super.key});
//
//   @override
//   State<MainApp> createState() => _MainAppState();
// }
//
// class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
//   bool _isAnimationInProgress = false;
//
//   /// لیست از توپ‌ها که شامل موقعیت و انیمیشن کنترلر هر کدام است
//   final List<Ball> _balls = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeBalls(); // توپ‌ها را مقداردهی اولیه می‌کند
//   }
//
//   void _initializeBalls() {
//     // موقعیت اولیه دو توپ
//     _balls.addAll([
//       Ball(position: const Offset(150, 150), radius: 25),
//       Ball(position: const Offset(250, 250), radius: 25),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final canvasSize = MediaQuery.of(context).size;
//
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: SizedBox(
//             height: canvasSize.height,
//             width: canvasSize.width,
//             child: GestureDetector(
//               onPanStart: (details) {
//                 _checkBallHit(details.localPosition);
//               },
//               onPanUpdate: (details) {
//                 _updateBallPosition(details.localPosition);
//               },
//               onPanEnd: (details) {
//                 _startBallAnimation(details.velocity.pixelsPerSecond, canvasSize);
//               },
//               child: ColoredBox(
//                 color: Colors.amber,
//                 child: CustomPaint(
//                   painter: BallPainter(_balls),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// بررسی می‌کند که آیا کاربر روی یک توپ کلیک کرده است یا نه
//   void _checkBallHit(Offset position) {
//     for (var ball in _balls) {
//       if ((position - ball.position).distance <= ball.radius) {
//         ball.isSelected = true;
//         _isAnimationInProgress = false;
//       }
//     }
//   }
//
//   /// موقعیت توپ انتخاب‌شده را به‌روزرسانی می‌کند
//   void _updateBallPosition(Offset position) {
//     for (var ball in _balls) {
//       if (ball.isSelected) {
//         setState(() {
//           ball.position = position;
//         });
//       }
//     }
//   }
//
//   /// شروع انیمیشن توپ
//   void _startBallAnimation(Offset velocity, Size canvasSize) {
//     for (var ball in _balls) {
//       if (ball.isSelected) {
//         ball.isSelected = false;
//         _runAnimation(ball, velocity, canvasSize);
//       }
//     }
//   }
//
//   /// اجرای انیمیشن با FrictionSimulation
//   void _runAnimation(Ball ball, Offset pixelsPerSecond, Size canvasSize) {
//     final controller = AnimationController.unbounded(vsync: this);
//     final simulation = FrictionSimulation(0.05, 0, pixelsPerSecond.distance);
//     var direction = pixelsPerSecond.direction;
//
//     double walkedDistance = 0.0;
//
//     controller.addListener(() {
//       setState(() {
//         final differentialOffset =
//         Offset.fromDirection(direction, controller.value - walkedDistance);
//         ball.position += differentialOffset;
//         walkedDistance = controller.value;
//
//         // برخورد به دیواره‌ها
//         if (ball.position.dx - ball.radius < 0 || ball.position.dx + ball.radius > canvasSize.width) {
//           direction = pi - direction;
//           ball.position = Offset(
//             ball.position.dx.clamp(ball.radius, canvasSize.width - ball.radius),
//             ball.position.dy,
//           );
//         }
//         if (ball.position.dy - ball.radius < 0 || ball.position.dy + ball.radius > canvasSize.height) {
//           direction = -direction;
//           ball.position = Offset(
//             ball.position.dx,
//             ball.position.dy.clamp(ball.radius, canvasSize.height - ball.radius),
//           );
//         }
//       });
//     });
//
//     controller.animateWith(simulation).whenComplete(controller.dispose);
//   }
// }
//
// class Ball {
//   Offset position; // موقعیت توپ
//   final double radius; // شعاع توپ
//   bool isSelected; // آیا این توپ انتخاب‌شده است؟
//
//   Ball({
//     required this.position,
//     required this.radius,
//     this.isSelected = false,
//   });
// }
//
// class BallPainter extends CustomPainter {
//   final List<Ball> balls;
//
//   BallPainter(this.balls);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xff995588)
//       ..style = PaintingStyle.fill;
//
//     for (var ball in balls) {
//       canvas.drawCircle(ball.position, ball.radius, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//
// void main() {
//   runApp(const MainApp());
// }
//
// class MainApp extends StatefulWidget {
//   const MainApp({super.key});
//
//   @override
//   State<MainApp> createState() => _MainAppState();
// }
//
// class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
//   final List<Ball> balls = [];
//   final double ballRadius = 25.0;
//
//   @override
//   void initState() {
//     super.initState();
//     // ایجاد دو توپ با موقعیت اولیه و سرعت تصادفی
//     balls.add(Ball(position: Offset(100, 100), velocity: Offset(5, 3), radius: ballRadius));
//     balls.add(Ball(position: Offset(300, 300), velocity: Offset(-4, -2), radius: ballRadius));
//     _startSimulation();
//   }
//
//   void _startSimulation() {
//     // تایمر برای بروزرسانی موقعیت توپ‌ها
//     Ticker((elapsed) {
//       setState(() {
//         for (var ball in balls) {
//           ball.updatePosition();
//           ball.checkBounds(MediaQuery.of(context).size);
//
//           // چک کردن برخورد بین توپ‌ها
//           for (var otherBall in balls) {
//             if (ball != otherBall) {
//               ball.checkCollisionWithOtherBall(otherBall);
//             }
//           }
//         }
//       });
//     }).start();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: ColoredBox(
//           color: Colors.amber,
//           child: CustomPaint(
//             painter: BallPainter(balls),
//             child: const SizedBox.expand(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Ball {
//   Offset position;
//   Offset velocity;
//   final double radius;
//
//   Ball({required this.position, required this.velocity, required this.radius});
//
//   void updatePosition() {
//     position += velocity;
//   }
//
//   void checkBounds(Size canvasSize) {
//     if (position.dx - radius < 0 || position.dx + radius > canvasSize.width) {
//       velocity = Offset(-velocity.dx, velocity.dy); // تغییر جهت در محور X
//     }
//     if (position.dy - radius < 0 || position.dy + radius > canvasSize.height) {
//       velocity = Offset(velocity.dx, -velocity.dy); // تغییر جهت در محور Y
//     }
//   }
//
//   void checkCollisionWithOtherBall(Ball other) {
//     final distance = (position - other.position).distance;
//     if (distance <= radius + other.radius) {
//       // تغییر جهت سرعت توپ‌ها هنگام برخورد
//       final tempVelocity = velocity;
//       velocity = other.velocity;
//       other.velocity = tempVelocity;
//     }
//   }
// }
//
// class BallPainter extends CustomPainter {
//   final List<Ball> balls;
//
//   BallPainter(this.balls);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.blue;
//     for (var ball in balls) {
//       canvas.drawCircle(ball.position, ball.radius, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
//


//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Floating Balloon',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Home(),
//     );
//   }
// }
// class AnimatedBalloon extends StatefulWidget {
//   const AnimatedBalloon({Key? key}) : super(key: key);
//
//   @override
//   _AnimatedBalloonState createState() => _AnimatedBalloonState();
// }
//
// class _AnimatedBalloonState extends State<AnimatedBalloon> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animationFloatUp;
//   late Animation<double> _animationGrowSize;
//
//   late double _balloonHeight;
//   late double _balloonWidth;
//   late double _balloonBottomLocation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(duration: Duration(seconds: 4), vsync: this);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     _balloonHeight = MediaQuery.of(context).size.height / 2;
//     _balloonWidth = MediaQuery.of(context).size.height / 3;
//     _balloonBottomLocation = MediaQuery.of(context).size.height - _balloonHeight;
//
//     _animationFloatUp = Tween(begin: _balloonBottomLocation, end: 0.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
//       ),
//     );
//
//     _animationGrowSize = Tween(begin: 50.0, end: _balloonWidth).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Interval(0.0, 0.75, curve: Curves.elasticInOut),
//       ),
//     );
//
//     if (_controller.isCompleted) {
//       _controller.reverse();
//     } else {
//       _controller.forward();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animationFloatUp,
//       builder: (context, child) {
//         return Container(
//           child: child,
//           margin: EdgeInsets.only(
//             top: _animationFloatUp.value,
//             left: _animationGrowSize.value * 0.25,
//           ),
//           width: _animationGrowSize.value,
//         );
//       },
//       child: GestureDetector(
//         child: Image.asset('images/superhanter.jpeg',
//           height: _balloonHeight,
//           width: _balloonWidth,
//         ),
//         onTap: () {
//           if (_controller.isCompleted) {
//             _controller.reverse();
//           } else {
//             _controller.forward();
//           }
//         },
//       ),
//     );
//   }
// }
// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue.shade50,
//       appBar: AppBar(
//         title: Text(
//           'Animated Balloon',
//           textAlign: TextAlign.center,
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: AnimatedBalloon(),
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';
// //
// void main() {
//   runApp(BilliardApp());
// }
//
// class BilliardApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Billiard Game',
//       home: Scaffold(
//         body: BilliardTable(),
//       ),
//     );
//   }
// }
//
// class BilliardTable extends StatefulWidget {
//   @override
//   _BilliardTableState createState() => _BilliardTableState();
// }
//
// class _BilliardTableState extends State<BilliardTable> {
//   // لیست موقعیت توپ‌ها
//   List<Offset> ballPositions = [];
//   List<Offset> ballVelocities = [];
//   static const double ballRadius = 15;
//   final int ballCount = 8;
//   Offset? draggingBall;
//   Timer? movementTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeBalls();
//     movementTimer = Timer.periodic(Duration(milliseconds: 16), _updateBallPositions);
//   }
//
//   @override
//   void dispose() {
//     movementTimer?.cancel();
//     super.dispose();
//   }
//
//   void _initializeBalls() {
//     Random random = Random();
//     ballPositions = List.generate(ballCount, (index) {
//       return Offset(
//         100 + random.nextDouble() * 200,
//         100 + random.nextDouble() * 400,
//       );
//     });
//     ballVelocities = List.generate(ballCount, (index) => Offset(0, 0));
//   }
//
//   void _onPanStart(DragStartDetails details) {
//     final touchPosition = details.localPosition;
//     for (var position in ballPositions) {
//       if ((position - touchPosition).distance <= ballRadius) {
//         setState(() {
//           draggingBall = position;
//         });
//         break;
//       }
//     }
//   }
//
//   void _onPanUpdate(DragUpdateDetails details) {
//     if (draggingBall != null) {
//       setState(() {
//         final newPosition = details.localPosition;
//         final index = ballPositions.indexOf(draggingBall!);
//         ballVelocities[index] = (newPosition - draggingBall!) * 0.5;
//         ballPositions[index] = newPosition;
//         draggingBall = newPosition;
//       });
//     }
//   }
//
//   void _onPanEnd(DragEndDetails details) {
//     setState(() {
//       draggingBall = null;
//     });
//   }
//
//   void _updateBallPositions(Timer timer) {
//     setState(() {
//       for (int i = 0; i < ballPositions.length; i++) {
//         ballPositions[i] += ballVelocities[i];
//         ballVelocities[i] *= 0.98; // اصطکاک کاهش سرعت
//
//         // برخورد توپ به دیوارها
//         if (ballPositions[i].dx - ballRadius < 20 || ballPositions[i].dx + ballRadius > MediaQuery.of(context).size.width - 20) {
//           ballVelocities[i] = Offset(-ballVelocities[i].dx, ballVelocities[i].dy);
//         }
//         if (ballPositions[i].dy - ballRadius < 20 || ballPositions[i].dy + ballRadius > MediaQuery.of(context).size.height - 20) {
//           ballVelocities[i] = Offset(ballVelocities[i].dx, -ballVelocities[i].dy);
//         }
//
//         // بررسی برخورد توپ‌ها به هم
//         for (int j = i + 1; j < ballPositions.length; j++) {
//           if ((ballPositions[i] - ballPositions[j]).distance < ballRadius * 2) {
//             _resolveCollision(i, j);
//           }
//         }
//       }
//     });
//   }
//
//   void _resolveCollision(int i, int j) {
//     Offset delta = ballPositions[i] - ballPositions[j];
//     double distance = delta.distance;
//     if (distance == 0) return;
//
//     // تصحیح موقعیت توپ‌ها برای جلوگیری از هم‌پوشانی
//     Offset correction = delta * ((ballRadius * 2 - distance) / distance / 2);
//     ballPositions[i] += correction;
//     ballPositions[j] -= correction;
//
//     // محاسبه تبادل سرعت بین توپ‌ها
//     Offset relativeVelocity = ballVelocities[i] - ballVelocities[j];
//     double velocityAlongDelta = (relativeVelocity.dx * delta.dx + relativeVelocity.dy * delta.dy) / (distance * distance);
//
//     if (velocityAlongDelta > 0) return; // برخورد نداشته باشند
//
//     Offset impulse = delta * velocityAlongDelta;
//     ballVelocities[i] -= impulse;
//     ballVelocities[j] += impulse;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanStart: _onPanStart,
//       onPanUpdate: _onPanUpdate,
//       onPanEnd: _onPanEnd,
//       child: Container(
//         color: Colors.green[700], // رنگ میز بیلیارد
//         child: CustomPaint(
//           painter: BilliardPainter(ballPositions, ballRadius),
//           child: Container(),
//         ),
//       ),
//     );
//   }
// }
//
// class BilliardPainter extends CustomPainter {
//   final List<Offset> ballPositions;
//   final double ballRadius;
//
//   BilliardPainter(this.ballPositions, this.ballRadius);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paintTableBorder = Paint()
//       ..color = Colors.brown[700]!
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 10;
//
//     final ballPaint = Paint()..color = Colors.white;
//     final pocketPaint = Paint()..color = Colors.black;
//
//     // رسم کادر میز
//     canvas.drawRect(Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), paintTableBorder);
//
//     // رسم سوراخ‌های میز
//     double pocketRadius = 20;
//     List<Offset> pockets = [
//       Offset(30, 30),
//       Offset(size.width / 2, 30),
//       Offset(size.width - 30, 30),
//       Offset(30, size.height - 30),
//       Offset(size.width / 2, size.height - 30),
//       Offset(size.width - 30, size.height - 30),
//     ];
//     for (var pocket in pockets) {
//       canvas.drawCircle(pocket, pocketRadius, pocketPaint);
//     }
//
//     // رسم توپ‌ها
//     for (var position in ballPositions) {
//       canvas.drawCircle(position, ballRadius, ballPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

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
//       title: 'ایده شما',
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('صفحه اصلی')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SecondPage()),
//           );
//         },
//         child: Icon(Icons.arrow_forward),
//       ),
//       body: Center(child: Text('به صفحه اصلی خوش آمدید')),
//     );
//   }
// }
//
// class SecondPage extends StatefulWidget {
//   @override
//   _SecondPageState createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   String buttonText = 'کلوز';
//   TextEditingController _controller = TextEditingController();
//   List<FileItem> fileItems = []; // لیست فایل‌ها
//   double dx = 0, dy = 0; // تغییرات شتاب‌سنج
//
//   @override
//   void initState() {
//     super.initState();
//     accelerometerEvents.listen((event) {
//       setState(() {
//         dx = event.x;
//         dy = event.y;
//       });
//     });
//   }
//
//   void _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       String? fileName = result.files.single.name;
//       String? fileExtension = result.files.single.extension;
//
//       setState(() {
//         fileItems.add(FileItem(name: fileName ?? 'بدون نام', extension: fileExtension ?? 'unk'));
//       });
//     }
//   }
//
//   void _handleButtonPress() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         buttonText = buttonText == 'ثبت سفارش' ? 'به روز رسانی' : 'ثبت سفارش';
//       });
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/sky_background.png'), // بک‌گراند آسمان
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // نمایش فایل‌ها
//             ...fileItems.map((file) => DraggableFileItem(file: file, dx: dx, dy: dy)).toList(),
//
//             // کادر پایین صفحه
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.all(16),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: _controller,
//                       onChanged: (value) {
//                         setState(() {
//                           buttonText = value.isNotEmpty ? 'ثبت سفارش' : 'کلوز';
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'اینجا چیزی بنویسید',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _pickFile,
//                           child: Text('افزودن فایل'),
//                         ),
//                         ElevatedButton(
//                           onPressed: _handleButtonPress,
//                           child: Text(buttonText),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FileItem {
//   final String name;
//   final String extension;
//
//   FileItem({required this.name, required this.extension});
// }
//
// class DraggableFileItem extends StatelessWidget {
//   final FileItem file;
//   final double dx;
//   final double dy;
//
//   DraggableFileItem({required this.file, required this.dx, required this.dy});
//
//   @override
//   Widget build(BuildContext context) {
//     double positionX = 100 + dx * 10; // موقعیت بر اساس سنسور
//     double positionY = 200 + dy * 10;
//
//     return Positioned(
//       left: positionX,
//       top: positionY,
//       child: GestureDetector(
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) => Container(
//               height: 150,
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.delete),
//                     title: Text('حذف'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.download),
//                     title: Text('دانلود'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         child: CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.blueAccent,
//           child: Text(
//             file.extension.toUpperCase(),
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }
//


//
// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'dart:async';
// import 'dart:math';
//
// void main() {
//   runApp(BilliardApp());
// }
//
// class BilliardApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Billiard Game',
//       home: Scaffold(
//         body: BilliardTable(),
//       ),
//     );
//   }
// }
//
// class BilliardTable extends StatefulWidget {
//   @override
//   _BilliardTableState createState() => _BilliardTableState();
// }
//
// class _BilliardTableState extends State<BilliardTable> {
//   List<Offset> ballPositions = [];
//   List<Offset> ballVelocities = [];
//   static const double ballRadius = 15;
//   final int ballCount = 8;
//   Timer? movementTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeBalls();
//     movementTimer = Timer.periodic(Duration(milliseconds: 16), _updateBallPositions);
//     _initializeAccelerometer();
//   }
//
//   @override
//   void dispose() {
//     movementTimer?.cancel();
//     super.dispose();
//   }
//
//   void _initializeBalls() {
//     Random random = Random();
//     ballPositions = List.generate(ballCount, (index) {
//       return Offset(
//         100 + random.nextDouble() * 200,
//         100 + random.nextDouble() * 400,
//       );
//     });
//     ballVelocities = List.generate(ballCount, (index) => Offset(0, 0));
//   }
//
//   void _initializeAccelerometer() {
//     accelerometerEvents.listen((event) {
//       // شتاب‌سنج به توپ‌ها سرعت می‌دهد
//       _applyAccelerometerMovement(event.x, event.y);
//     });
//   }
//
//   // حرکت توپ‌ها با استفاده از شتاب‌سنج
//   void _applyAccelerometerMovement(double ax, double ay) {
//     setState(() {
//       for (int i = 0; i < ballPositions.length; i++) {
//         // شتاب‌سنج را به عنوان نیروی حرکت توپ‌ها اعمال می‌کنیم
//         ballVelocities[i] += Offset(ax * 0.1, ay * 0.1);
//       }
//     });
//   }
//
//   void _updateBallPositions(Timer timer) {
//     setState(() {
//       for (int i = 0; i < ballPositions.length; i++) {
//         ballPositions[i] += ballVelocities[i];
//         ballVelocities[i] *= 0.98; // اصطکاک کاهش سرعت
//
//         // برخورد توپ به دیوارها
//         if (ballPositions[i].dx - ballRadius < 20 || ballPositions[i].dx + ballRadius > MediaQuery.of(context).size.width - 20) {
//           ballVelocities[i] = Offset(-ballVelocities[i].dx, ballVelocities[i].dy);
//         }
//         if (ballPositions[i].dy - ballRadius < 20 || ballPositions[i].dy + ballRadius > MediaQuery.of(context).size.height - 20) {
//           ballVelocities[i] = Offset(ballVelocities[i].dx, -ballVelocities[i].dy);
//         }
//
//         // بررسی برخورد توپ‌ها به هم
//         for (int j = i + 1; j < ballPositions.length; j++) {
//           if ((ballPositions[i] - ballPositions[j]).distance < ballRadius * 2) {
//             _resolveCollision(i, j);
//           }
//         }
//       }
//     });
//   }
//
//   // حل برخورد توپ‌ها
//   void _resolveCollision(int i, int j) {
//     Offset delta = ballPositions[i] - ballPositions[j];
//     double distance = delta.distance;
//     if (distance == 0) return;
//
//     // تصحیح موقعیت توپ‌ها برای جلوگیری از هم‌پوشانی
//     Offset correction = delta * ((ballRadius * 2 - distance) / distance / 2);
//     ballPositions[i] += correction;
//     ballPositions[j] -= correction;
//
//     // محاسبه تبادل سرعت بین توپ‌ها
//     Offset relativeVelocity = ballVelocities[i] - ballVelocities[j];
//     double velocityAlongDelta = (relativeVelocity.dx * delta.dx + relativeVelocity.dy * delta.dy) / (distance * distance);
//
//     if (velocityAlongDelta > 0) return; // برخورد نداشته باشند
//
//     Offset impulse = delta * velocityAlongDelta;
//     ballVelocities[i] -= impulse;
//     ballVelocities[j] += impulse;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//         color: Colors.green[700], // رنگ میز بیلیارد
//         child: CustomPaint(
//           painter: BilliardPainter(ballPositions, ballRadius),
//           child: Container(),
//         ),
//       ),
//     );
//   }
// }
//
// class BilliardPainter extends CustomPainter {
//   final List<Offset> ballPositions;
//   final double ballRadius;
//
//   BilliardPainter(this.ballPositions, this.ballRadius);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paintTableBorder = Paint()
//       ..color = Colors.brown[700]!
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 10;
//
//     final ballPaint = Paint()..color = Colors.white;
//     final pocketPaint = Paint()..color = Colors.black;
//
//     // رسم کادر میز
//     canvas.drawRect(Rect.fromLTWH(20, 20, size.width - 40, size.height - 40), paintTableBorder);
//
//     // رسم سوراخ‌های میز
//     double pocketRadius = 20;
//     List<Offset> pockets = [
//       Offset(30, 30),
//       Offset(size.width / 2, 30),
//       Offset(size.width - 30, 30),
//       Offset(30, size.height - 30),
//       Offset(size.width / 2, size.height - 30),
//       Offset(size.width - 30, size.height - 30),
//     ];
//     for (var pocket in pockets) {
//       canvas.drawCircle(pocket, pocketRadius, pocketPaint);
//     }
//
//     // رسم توپ‌ها
//     for (var position in ballPositions) {
//       canvas.drawCircle(position, ballRadius, ballPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
//
//


import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sensors_plus/sensors_plus.dart'; // برای دسترسی به شتاب‌سنج
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sensors_plus/sensors_plus.dart'; // برای دسترسی به شتاب‌سنج
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ایده شما',
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('صفحه اصلی')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SecondPage()),
//           );
//         },
//         child: Icon(Icons.arrow_forward),
//       ),
//       body: Center(child: Text('به صفحه اصلی خوش آمدید')),
//     );
//   }
// }
//
// class SecondPage extends StatefulWidget {
//   @override
//   _SecondPageState createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   String buttonText = 'کلوز';
//   TextEditingController _controller = TextEditingController();
//   List<FileItem> fileItems = []; // لیست فایل‌ها
//   double dx = 0, dy = 0; // تغییرات شتاب‌سنج
//
//   @override
//   void initState() {
//     super.initState();
//     accelerometerEvents.listen((event) {
//       setState(() {
//         dx = event.x;
//         dy = event.y;
//       });
//     });
//   }
//
//   void _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       String? fileName = result.files.single.name;
//       String? fileExtension = result.files.single.extension;
//
//       setState(() {
//         fileItems.add(FileItem(name: fileName ?? 'بدون نام', extension: fileExtension ?? 'unk'));
//       });
//     }
//   }
//
//   void _handleButtonPress() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         buttonText = buttonText == 'ثبت سفارش' ? 'به روز رسانی' : 'ثبت سفارش';
//       });
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/sky_background.png'), // بک‌گراند آسمان
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // نمایش فایل‌ها
//             ListView.builder(
//               itemCount: fileItems.length,
//               itemBuilder: (context, index) {
//                 FileItem file = fileItems[index];
//                 return DraggableFileItem(file: file, dx: dx, dy: dy);
//               },
//             ),
//
//             // کادر پایین صفحه
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.all(16),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: _controller,
//                       onChanged: (value) {
//                         setState(() {
//                           buttonText = value.isNotEmpty ? 'ثبت سفارش' : 'کلوز';
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'اینجا چیزی بنویسید',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _pickFile,
//                           child: Text('افزودن فایل'),
//                         ),
//                         ElevatedButton(
//                           onPressed: _handleButtonPress,
//                           child: Text(buttonText),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FileItem {
//   final String name;
//   final String extension;
//
//   FileItem({required this.name, required this.extension});
// }
//
// class DraggableFileItem extends StatelessWidget {
//   final FileItem file;
//   final double dx;
//   final double dy;
//
//   DraggableFileItem({required this.file, required this.dx, required this.dy});
//
//   @override
//   Widget build(BuildContext context) {
//     double positionX = 100 + dx * 10; // موقعیت بر اساس سنسور
//     double positionY = 200 + dy * 10;
//
//     return Positioned(
//       left: positionX,
//       top: positionY,
//       child: GestureDetector(
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) => Container(
//               height: 150,
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.delete),
//                     title: Text('حذف'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.download),
//                     title: Text('دانلود'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         child: CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.blueAccent,
//           child: Text(
//             file.extension.toUpperCase(),
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sensors_plus/sensors_plus.dart'; // برای دسترسی به شتاب‌سنج


//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ایده شما',
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('صفحه اصلی')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SecondPage()),
//           );
//         },
//         child: Icon(Icons.arrow_forward),
//       ),
//       body: Center(child: Text('به صفحه اصلی خوش آمدید')),
//     );
//   }
// }
//
// class SecondPage extends StatefulWidget {
//   @override
//   _SecondPageState createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   String buttonText = 'کلوز';
//   TextEditingController _controller = TextEditingController();
//   List<FileItem> fileItems = []; // لیست فایل‌ها
//   List<Offset> filePositions = []; // لیست موقعیت‌های فایل‌ها
//   double dx = 0, dy = 0; // تغییرات شتاب‌سنج
//
//   @override
//   void initState() {
//     super.initState();
//     accelerometerEvents.listen((event) {
//       setState(() {
//         dx = event.x;
//         dy = event.y;
//       });
//     });
//   }
//
//   void _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       String? fileName = result.files.single.name;
//       String? fileExtension = result.files.single.extension;
//
//       setState(() {
//         fileItems.add(FileItem(name: fileName ?? 'بدون نام', extension: fileExtension ?? 'unk'));
//         // موقعیت تصادفی برای هر فایل جدید
//         filePositions.add(Offset(
//           100 + (fileItems.length * 60).toDouble(), // فاصله برای جلوگیری از همپوشانی
//           200 + (fileItems.length * 40).toDouble(),
//         ));
//       });
//     }
//   }
//
//   void _handleButtonPress() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         buttonText = buttonText == 'ثبت سفارش' ? 'به روز رسانی' : 'ثبت سفارش';
//       });
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/sky_background.png'), // بک‌گراند آسمان
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // نمایش فایل‌ها با موقعیت آزاد
//             ...fileItems.asMap().entries.map((entry) {
//               int index = entry.key;
//               FileItem file = entry.value;
//               Offset position = filePositions[index];
//               return DraggableFileItem(file: file, position: position, dx: dx, dy: dy);
//             }).toList(),
//
//             // کادر پایین صفحه
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.all(16),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: _controller,
//                       onChanged: (value) {
//                         setState(() {
//                           buttonText = value.isNotEmpty ? 'ثبت سفارش' : 'کلوز';
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'اینجا چیزی بنویسید',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _pickFile,
//                           child: Text('افزودن فایل'),
//                         ),
//                         ElevatedButton(
//                           onPressed: _handleButtonPress,
//                           child: Text(buttonText),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FileItem {
//   final String name;
//   final String extension;
//
//   FileItem({required this.name, required this.extension});
// }
//
// class DraggableFileItem extends StatelessWidget {
//   final FileItem file;
//   final Offset position;
//   final double dx;
//   final double dy;
//
//   DraggableFileItem({required this.file, required this.position, required this.dx, required this.dy});
//
//   @override
//   Widget build(BuildContext context) {
//     // مقیاس حرکت دایره‌ها برای کالیبره کردن
//     double scaleFactor = 30.0; // تنظیم مقیاس حرکت
//     double positionX = position.dx + dx * scaleFactor; // موقعیت افقی
//     double positionY = position.dy + dy * scaleFactor; // موقعیت عمودی
//
//     // محدود کردن دایره‌ها در محدوده صفحه
//     positionX = positionX.clamp(0.0, MediaQuery.of(context).size.width - 80); // عرض صفحه
//     positionY = positionY.clamp(0.0, MediaQuery.of(context).size.height - 80); // ارتفاع صفحه
//
//     return Positioned(
//       left: positionX,
//       top: positionY,
//       child: GestureDetector(
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) => Container(
//               height: 150,
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.delete),
//                     title: Text('حذف'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.download),
//                     title: Text('دانلود'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         child: CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.blueAccent,
//           child: Text(
//             file.extension.toUpperCase(),
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sensors_plus/sensors_plus.dart'; // برای دسترسی به شتاب‌سنج
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ایده شما',
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('صفحه اصلی')),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SecondPage()),
//           );
//         },
//         child: Icon(Icons.arrow_forward),
//       ),
//       body: Center(child: Text('به صفحه اصلی خوش آمدید')),
//     );
//   }
// }
//
// class SecondPage extends StatefulWidget {
//   @override
//   _SecondPageState createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   String buttonText = 'کلوز';
//   TextEditingController _controller = TextEditingController();
//   List<FileItem> fileItems = []; // لیست فایل‌ها
//   List<Offset> filePositions = []; // لیست موقعیت‌های فایل‌ها
//   double dx = 0, dy = 0; // تغییرات شتاب‌سنج
//
//   @override
//   void initState() {
//     super.initState();
//     accelerometerEvents.listen((event) {
//       setState(() {
//         dx = event.x;
//         dy = event.y;
//       });
//     });
//   }
//
//   void _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       String? fileName = result.files.single.name;
//       String? fileExtension = result.files.single.extension;
//
//       setState(() {
//         fileItems.add(FileItem(name: fileName ?? 'بدون نام', extension: fileExtension ?? 'unk'));
//         // موقعیت تصادفی برای هر فایل جدید
//         filePositions.add(Offset(
//           100 + (fileItems.length * 100).toDouble(), // فاصله برای جلوگیری از همپوشانی
//           200 + (fileItems.length * 60).toDouble(),
//         ));
//       });
//     }
//   }
//
//   void _handleButtonPress() {
//     if (_controller.text.isNotEmpty) {
//       setState(() {
//         buttonText = buttonText == 'ثبت سفارش' ? 'به روز رسانی' : 'ثبت سفارش';
//       });
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/sky_background.png'), // بک‌گراند آسمان
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // نمایش فایل‌ها با موقعیت آزاد
//             ...fileItems.asMap().entries.map((entry) {
//               int index = entry.key;
//               FileItem file = entry.value;
//               Offset position = filePositions[index];
//               return DraggableFileItem(file: file, position: position, dx: dx, dy: dy);
//             }).toList(),
//
//             // کادر پایین صفحه
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 margin: EdgeInsets.all(16),
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: _controller,
//                       onChanged: (value) {
//                         setState(() {
//                           buttonText = value.isNotEmpty ? 'ثبت سفارش' : 'کلوز';
//                         });
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'اینجا چیزی بنویسید',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _pickFile,
//                           child: Text('افزودن فایل'),
//                         ),
//                         ElevatedButton(
//                           onPressed: _handleButtonPress,
//                           child: Text(buttonText),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FileItem {
//   final String name;
//   final String extension;
//
//   FileItem({required this.name, required this.extension});
// }
//
// class DraggableFileItem extends StatelessWidget {
//   final FileItem file;
//   final Offset position;
//   final double dx;
//   final double dy;
//
//   DraggableFileItem({required this.file, required this.position, required this.dx, required this.dy});
//
//   @override
//   Widget build(BuildContext context) {
//     // مقیاس حرکت دایره‌ها برای کالیبره کردن
//     double scaleFactor = 30.0; // تنظیم مقیاس حرکت
//     double positionX = position.dx + dx * scaleFactor; // موقعیت افقی
//     double positionY = position.dy + dy * scaleFactor; // موقعیت عمودی
//
//     // محدود کردن دایره‌ها در محدوده صفحه
//     positionX = positionX.clamp(0.0, MediaQuery.of(context).size.width - 80); // عرض صفحه
//     positionY = positionY.clamp(0.0, MediaQuery.of(context).size.height - 80); // ارتفاع صفحه
//
//     return Positioned(
//       left: positionX,
//       top: positionY,
//       child: GestureDetector(
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             builder: (context) => Container(
//               height: 150,
//               child: Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.delete),
//                     title: Text('حذف'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.download),
//                     title: Text('دانلود'),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         child: CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.blueAccent,
//           child: Text(
//             file.extension.toUpperCase(),
//             style: TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:sensors_plus/sensors_plus.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ایده شما',
//       home: SecondPage(),
//     );
//   }
// }
//
// class SecondPage extends StatefulWidget {
//   @override
//   _SecondPageState createState() => _SecondPageState();
// }
//
// class _SecondPageState extends State<SecondPage> {
//   List<FileItem> fileItems = []; // لیست فایل‌ها
//   List<Offset> filePositions = []; // موقعیت فایل‌ها
//   double dx = 0, dy = 0; // تغییرات شتاب‌سنج
//   final double cloudSize = 80.0; // اندازه هر ابر
//
//   @override
//   void initState() {
//     super.initState();
//     accelerometerEvents.listen((event) {
//       setState(() {
//         dx = event.x;
//         dy = event.y;
//         _updateCloudPositions();
//       });
//     });
//   }
//
//   void _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       String? fileName = result.files.single.name;
//       String? fileExtension = result.files.single.extension;
//
//       setState(() {
//         fileItems.add(FileItem(name: fileName ?? 'بدون نام', extension: fileExtension ?? 'unk'));
//         filePositions.add(_generateRandomPosition());
//       });
//     }
//   }
//
//   Offset _generateRandomPosition() {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     Random random = Random();
//
//     // تولید موقعیت تصادفی اولیه
//     double x = random.nextDouble() * (screenWidth - cloudSize);
//     double y = random.nextDouble() * (screenHeight - cloudSize);
//
//     return Offset(x, y);
//   }
//
//   void _updateCloudPositions() {
//     for (int i = 0; i < filePositions.length; i++) {
//       Offset newPosition = filePositions[i];
//       newPosition = Offset(
//         newPosition.dx + dx * 5,
//         newPosition.dy - dy * 5,
//       );
//
//       // محدود کردن به صفحه
//       final screenWidth = MediaQuery.of(context).size.width;
//       final screenHeight = MediaQuery.of(context).size.height;
//
//       newPosition = Offset(
//         newPosition.dx.clamp(0, screenWidth - cloudSize),
//         newPosition.dy.clamp(0, screenHeight - cloudSize),
//       );
//
//       // جلوگیری از برخورد
//       for (int j = 0; j < filePositions.length; j++) {
//         if (i == j) continue;
//         if (_checkCollision(newPosition, filePositions[j])) {
//           // حرکت به سمت مخالف
//           newPosition = Offset(
//             newPosition.dx + cloudSize,
//             newPosition.dy + cloudSize,
//           );
//         }
//       }
//
//       filePositions[i] = newPosition;
//     }
//   }
//
//   bool _checkCollision(Offset position1, Offset position2) {
//     double distance = sqrt(pow(position1.dx - position2.dx, 2) + pow(position1.dy - position2.dy, 2));
//     return distance < cloudSize;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // نمایش ابرها
//             ...fileItems.asMap().entries.map((entry) {
//               int index = entry.key;
//               FileItem file = entry.value;
//               Offset position = filePositions[index];
//
//               return Positioned(
//                 left: position.dx,
//                 top: position.dy,
//                 child: GestureDetector(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       builder: (context) => Container(
//                         height: 150,
//                         child: Column(
//                           children: [
//                             ListTile(
//                               leading: Icon(Icons.delete),
//                               title: Text('حذف'),
//                               onTap: () {
//                                 setState(() {
//                                   fileItems.removeAt(index);
//                                   filePositions.removeAt(index);
//                                 });
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                   child: Image.asset(
//                     'images/m.png', // تصویر ابر
//                     width: cloudSize,
//                     height: cloudSize,
//                   ),
//                 ),
//               );
//             }).toList(),
//
//             // دکمه اضافه کردن فایل
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: ElevatedButton(
//                   onPressed: _pickFile,
//                   child: Text('افزودن فایل'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FileItem {
//   final String name;
//   final String extension;
//
//   FileItem({required this.name, required this.extension});
// }
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FileUploadPage(),
    );
  }
}


class FileUploadPage extends StatelessWidget {
  final FileUploadController controller = Get.put(FileUploadController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text("File Upload"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            // بخش آپلود فایل
            Column(
              children: [
                Icon(Icons.file_upload, size: 80, color: Colors.blue),
                SizedBox(height: 10),
                Text("Select Files to Upload",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.pickFiles,
                  child: Text("Browse Files"),
                ),
              ],
            ),
            SizedBox(height: 20),

            // لیست فایل‌های آپلود
            Expanded(
              child: Obx(
                    () => controller.files.isEmpty
                    ? Center(
                  child: Text("No Files Selected",
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey[600])),
                )
                    : ListView.builder(
                  itemCount: controller.files.length,
                  itemBuilder: (context, index) {
                    final uploadFile = controller.files[index];
                    final file = uploadFile.file;

                    return Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularPercentIndicator(
                              radius: 30.0,
                              lineWidth: 4.0,
                              percent: uploadFile.progress.value,
                              center: Text(
                                file.extension?.toUpperCase() ?? "FILE",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              progressColor: uploadFile.isUploaded.value
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                            if (uploadFile.isUploaded.value)
                              Icon(Icons.check_circle,
                                  color: Colors.green, size: 32),
                          ],
                        ),
                        title: Text(
                          file.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          "${(file.size / 1024).toStringAsFixed(2)} KB",
                          style: TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon:
                          Icon(Icons.cancel, color: Colors.red[300]),
                          onPressed: () => controller.removeFile(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileUploadController extends GetxController {
  var files = <UploadFile>[].obs;

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        files.add(UploadFile(
          file: file,
          progress: 0.0.obs,
          isUploaded: false.obs,
        ));
        uploadFileSimulated(files.last);
      }
    }
  }

  void uploadFileSimulated(UploadFile uploadFile) async {
    while (uploadFile.progress.value < 1.0) {
      await Future.delayed(Duration(milliseconds: 4000));
      uploadFile.progress.value += 0.1;
    }
    uploadFile.isUploaded.value = true;
  }

  void removeFile(int index) {
    files.removeAt(index);
  }
}

class UploadFile {
  PlatformFile file;
  RxDouble progress;
  RxBool isUploaded;

  UploadFile({
    required this.file,
    required this.progress,
    required this.isUploaded,
  });
}
