// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'package:get/get.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'ماشین‌ها',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MachineView(),
//     );
//   }
// }
//
// abstract class MachineEntity {
//   String get name;
//
//   List<MachinePartEntity> get parts;
// }
//
// abstract class MachinePartEntity {
//   String get name;
//
//   double get price;
// }
//
// class Machine extends MachineEntity {
//   final String _name; // تغییر نام متغیر به _name
//   final List<MachinePart> _parts; // تغییر نام متغیر به _parts
//
//   Machine({required String name, required List<MachinePart> parts})
//       : _name = name,
//         _parts = parts;
//
//   @override
//   String get name => _name; // استفاده از getter برای بازگرداندن _name
//
//   @override
//   List<MachinePart> get parts =>
//       _parts; // استفاده از getter برای بازگرداندن _parts
// }
//
// class MachinePart extends MachinePartEntity {
//   final String _name; // تغییر نام متغیر به _name
//   final double _price; // تغییر نام متغیر به _price
//
//   MachinePart({required String name, required double price})
//       : _name = name,
//         _price = price;
//
//   @override
//   String get name => _name; // استفاده از getter برای بازگرداندن _name
//
//   @override
//   double get price => _price; // استفاده از getter برای بازگرداندن _price
// }
//
// class MachineRepository {
//   List<Machine> fetchMachines() {
//     return [
//       Machine(name: 'ماشین ۱', parts: [
//         MachinePart(name: 'لاستیک', price: 500),
//         MachinePart(name: 'درها', price: 1500),
//         MachinePart(name: 'موتور', price: 10000),
//         MachinePart(name: 'بدنه', price: 20000),
//       ]),
//       Machine(name: 'ماشین ۲', parts: [
//         MachinePart(name: 'لاستیک', price: 600),
//         MachinePart(name: 'درها', price: 1400),
//         MachinePart(name: 'موتور', price: 9000),
//         MachinePart(name: 'بدنه', price: 18000),
//       ]),
//     ];
//   }
// }
//
// class GetMachinesUseCase {
//   final MachineRepository repository;
//
//   GetMachinesUseCase(this.repository);
//
//   List<MachineEntity> execute() {
//     return repository.fetchMachines();
//   }
// }
//
// class MachineController extends GetxController
//     with SingleGetTickerProviderMixin {
//   final GetMachinesUseCase getMachinesUseCase;
//
//   final RxList<MachineEntity> machines = <MachineEntity>[].obs;
//   final RxInt currentMachineIndex = 0.obs;
//   final RxInt currentPartIndex = (-1).obs;
//
//   late AnimationController animationController; // تعریف کنترلر انیمیشن
//   late Animation<Offset> slideAnimation; // انیمیشن برای حرکت از چپ به راست
//
//   MachineController(this.getMachinesUseCase);
//
//   @override
//   void onInit() {
//     super.onInit();
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300), // مدت زمان انیمیشن
//     );
//     slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeInOut,
//     ));
//     loadMachines();
//     startAnimation();
//   }
//
//   @override
//   void onClose() {
//     animationController.dispose(); // آزادسازی منابع
//     super.onClose();
//   }
//
//   void loadMachines() {
//     machines.value = getMachinesUseCase.execute();
//   }
//
//   void startAnimation() async {
//     while (true) {
//       for (int i = 0; i < machines.length; i++) {
//         currentMachineIndex.value = i;
//         for (int j = 0; j < machines[i].parts.length; j++) {
//           currentPartIndex.value = j;
//           await Future.delayed(const Duration(seconds: 1));
//         }
//         await Future.delayed(const Duration(seconds: 2));
//         currentPartIndex.value = -1; // حذف تمام آیتم‌ها
//         await Future.delayed(const Duration(seconds: 1));
//       }
//     }
//   }
// }
//
// class MachineView extends StatelessWidget {
//   final MachineController controller = Get.put(MachineController(
//     GetMachinesUseCase(MachineRepository()),
//   ));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ماشین‌ها')),
//       body: Obx(() {
//         final currentMachine =
//             controller.machines[controller.currentMachineIndex.value];
//
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 currentMachine.name,
//                 style: const TextStyle(fontSize: 24),
//               ),
//               const SizedBox(height: 20),
//               RotatingMachineCircleWidget(
//                 parts: currentMachine.parts,
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class MachineCircleWidget extends StatelessWidget {
//   final List<MachinePartEntity> parts;
//   final int activeIndex;
//
//   const MachineCircleWidget({
//     Key? key,
//     required this.parts,
//     required this.activeIndex,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       width: 200,
//       child: Stack(
//         alignment: Alignment.center,
//         children: List.generate(parts.length, (index) {
//           final part = parts[index];
//           final isActive = index <= activeIndex;
//
//           return Transform.rotate(
//             angle: (index / parts.length) * 2 * 3.14,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: AnimatedOpacity(
//                 opacity: isActive ? 1.0 : 0.0,
//                 duration: const Duration(milliseconds: 500),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundColor: Colors.blue,
//                       child: Text(
//                         part.name[0],
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     if (isActive)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text('${part.price} تومان'),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
// class RotatingMachineCircleWidget extends StatefulWidget {
//   final List<MachinePartEntity> parts;
//
//   const RotatingMachineCircleWidget({Key? key, required this.parts})
//       : super(key: key);
//
//   @override
//   _RotatingMachineCircleWidgetState createState() =>
//       _RotatingMachineCircleWidgetState();
// }
//
// class _RotatingMachineCircleWidgetState
//     extends State<RotatingMachineCircleWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat(); // انیمیشن به‌صورت مداوم تکرار می‌شود.
//
//     _rotationAnimation =
//         Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     ));
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
//       animation: _rotationAnimation,
//       builder: (context, child) {
//         return SizedBox(
//           height: 300,
//           width: 300,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               // دایره مرکزی
//               CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.blue,
//                 child: const Text(
//                   'ماشین‌ها',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               // چرخش آبجکت‌ها دور دایره
//               ...List.generate(widget.parts.length, (index) {
//                 final angle = (index / widget.parts.length) * 2 * pi +
//                     _rotationAnimation.value;
//                 final x = 100 * cos(angle); // فاصله افقی از مرکز
//                 final y = 100 * sin(angle); // فاصله عمودی از مرکز
//
//                 final part = widget.parts[index];
//
//                 return Transform.translate(
//                   offset: Offset(x, y),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.orange,
//                         child: Text(
//                           part.name[0],
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${part.price} تومان',
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'package:get/get.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'ماشین‌ها',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MachineView(),
//     );
//   }
// }
//
// abstract class MachineEntity {
//   String get name;
//
//   List<MachinePartEntity> get parts;
// }
//
// abstract class MachinePartEntity {
//   String get name;
//   double get price;
//   Color get color; // اضافه کردن ویژگی color
//   set color(Color color); // اضافه کردن setter برای color
// }
//
// class Machine extends MachineEntity {
//   final String _name; // تغییر نام متغیر به _name
//   final List<MachinePart> _parts; // تغییر نام متغیر به _parts
//
//   Machine({required String name, required List<MachinePart> parts})
//       : _name = name,
//         _parts = parts;
//
//   @override
//   String get name => _name; // استفاده از getter برای بازگرداندن _name
//
//   @override
//   List<MachinePart> get parts =>
//       _parts; // استفاده از getter برای بازگرداندن _parts
// }
//
// class MachinePart extends MachinePartEntity {
//   final String _name;
//   final double _price;
//   Color _color; // اضافه کردن ویژگی رنگ
//
//   MachinePart({
//     required String name,
//     required double price,
//     Color color = Colors.grey, // مقدار پیش‌فرض رنگ
//   })  : _name = name,
//         _price = price,
//         _color = color;
//
//   @override
//   String get name => _name;
//
//   @override
//   double get price => _price;
//
//   @override
//   Color get color => _color; // getter برای color
//
//   @override
//   set color(Color color) => _color = color; // setter برای color
// }
//
// class MachineRepository {
//   List<Machine> fetchMachines() {
//     return [
//       Machine(name: 'ماشین ۱', parts: [
//         MachinePart(name: 'لاستیک', price: 500),
//         MachinePart(name: 'درها', price: 1500),
//         MachinePart(name: 'موتور', price: 10000),
//         MachinePart(name: 'بدنه', price: 20000),
//         MachinePart(name: 'gh', price: 60000),
//         MachinePart(name: 'gh', price: 60000),
//         MachinePart(name: 'gh', price: 60000),
//         MachinePart(name: 'gh', price: 60000),
//         MachinePart(name: 'gh', price: 60000),
//         MachinePart(name: 'gh', price: 60000),
//       ]),
//       Machine(name: 'ماشین ۲', parts: [
//         MachinePart(name: 'لاستیک', price: 600),
//         MachinePart(name: 'درها', price: 1400),
//         MachinePart(name: 'موتور', price: 9000),
//         MachinePart(name: 'بدنه', price: 78000),
//         MachinePart(name: 'hg', price: 98000),
//         MachinePart(name: 'hg', price: 98000),
//         MachinePart(name: 'hg', price: 98000),
//         MachinePart(name: 'hg', price: 98000),
//         MachinePart(name: 'hg', price: 98000),
//         MachinePart(name: 'hg', price: 98000),
//         MachinePart(name: 'hg', price: 98000),
//       ]),
//     ];
//   }
// }
//
// class GetMachinesUseCase {
//   final MachineRepository repository;
//
//   GetMachinesUseCase(this.repository);
//
//   List<MachineEntity> execute() {
//     return repository.fetchMachines();
//   }
// }
//
//
//
// class MachineView extends StatelessWidget {
//   final MachineController controller = Get.put(MachineController(
//     GetMachinesUseCase(MachineRepository()),
//   ));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('ماشین‌ها')),
//       body: GestureDetector(
//         onTap: controller.startMachineProcess,
//         child: Obx(() {
//           final currentMachine = controller.machines.isNotEmpty
//               ? controller.machines[controller.currentMachineIndex.value]
//               : null;
//
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   currentMachine!.name,
//                   style: const TextStyle(fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//                 RotatingMachineCircleWidget(
//                   parts: currentMachine.parts,
//                   activeIndex: controller.currentPartIndex.value,
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
// class MachineController extends GetxController with SingleGetTickerProviderMixin {
//   final GetMachinesUseCase getMachinesUseCase;
//   final RxList<MachineEntity> machines = <MachineEntity>[].obs;
//   final RxInt currentMachineIndex = 0.obs;
//   final RxInt currentPartIndex = (-1).obs;
//
//   late AnimationController animationController;
//   late Animation<Offset> slideAnimation;
//
//   MachineController(this.getMachinesUseCase);
//
//   @override
//   void onInit() {
//     super.onInit();
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
//         .animate(CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeInOut,
//     ));
//     loadMachines();
//   }
//
//   void loadMachines() {
//     machines.value = getMachinesUseCase.execute();
//   }
//
//   void startMachineProcess() async {
//     // نمایش قطعات ماشین‌ها یکی یکی
//     await Future.delayed(const Duration(seconds: 2));
//     for (int i = 0; i < machines.length; i++) {
//       currentMachineIndex.value = i;
//       currentPartIndex.value = -1; // بازنشانی قطعه
//
//       // نمایش قطعات یکی یکی با تغییر رنگ به نارنجی
//       for (int j = 0; j < machines[i].parts.length; j++) {
//         currentPartIndex.value = j;
//
//         // تغییر رنگ قطعه به نارنجی
//         machines[i].parts[j].color = Colors.orange; // تغییر رنگ به نارنجی
//
//         // آپدیت UI
//         update();
//
//         await Future.delayed(const Duration(seconds: 2));
//       }
//
//       // حذف قطعات یکی یکی با تغییر رنگ به خاکستری
//       for (int j = machines[i].parts.length - 1; j >= 0; j--) {
//         currentPartIndex.value = j;
//
//         // تغییر رنگ قطعه به خاکستری
//         machines[i].parts[j].color = Colors.grey; // تغییر رنگ به خاکستری
//
//
//
//         // آپدیت UI
//         update();
//
//         await Future.delayed(const Duration(seconds: 1));
//       }
//
//
//
//       // مکث 2 ثانیه بعد از حذف قطعات
//       await Future.delayed(const Duration(seconds: 3));
//     }
//   }
//
//
// }
//
// class RotatingMachineCircleWidget extends StatefulWidget {
//   final List<MachinePartEntity> parts;
//   final int activeIndex;
//
//   const RotatingMachineCircleWidget({
//     Key? key,
//     required this.parts,
//     required this.activeIndex,
//   }) : super(key: key);
//
//   @override
//   _RotatingMachineCircleWidgetState createState() =>
//       _RotatingMachineCircleWidgetState();
// }
//
// class _RotatingMachineCircleWidgetState
//     extends State<RotatingMachineCircleWidget> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 5),
//     )..repeat();
//
//     _rotationAnimation =
//         Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(
//           parent: _controller,
//           curve: Curves.linear,
//         ));
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
//       animation: _rotationAnimation,
//       builder: (context, child) {
//         return SizedBox(
//           height: 300,
//           width: 300,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Colors.blue,
//                 child: const Text(
//                   'ماشین‌ها',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               ...List.generate(widget.parts.length, (index) {
//                 final angle = (index / widget.parts.length) * 2 * pi +
//                     _rotationAnimation.value;
//                 final x = 100 * cos(angle);
//                 final y = 100 * sin(angle);
//
//                 final part = widget.parts[index];
//                 final isActive = index <= widget.activeIndex;
//
//                 return Transform.translate(
//                   offset: Offset(x, y),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: isActive ? part.color : Colors.grey, // استفاده از رنگ قطعه
//                         child: Text(
//                           part.name[0],
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       if (isActive && part.color != Colors.grey) // اضافه کردن چک برای رنگ خاکستری
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Text(
//                             '${part.price} تومان',
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'dart:math';
//
// import 'package:get/get.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'ماشین‌ها',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MachineView(),
//     );
//   }
// }
//
// abstract class MachineEntity {
//   String get name;
//
//   List<MachinePartEntity> get parts;
// }
//
// abstract class MachinePartEntity {
//   String get name;
//
//   double get price;
//
//   Color get color;
//
//   set color(Color color);
// }
//
// class Machine extends MachineEntity {
//   final String _name;
//   final List<MachinePart> _parts;
//
//   Machine({required String name, required List<MachinePart> parts})
//       : _name = name,
//         _parts = parts;
//
//   @override
//   String get name => _name;
//
//   @override
//   List<MachinePart> get parts => _parts;
// }
//
// class MachinePart extends MachinePartEntity {
//   final String _name;
//   final double _price;
//   Color _color;
//
//   MachinePart({
//     required String name,
//     required double price,
//     Color color = Colors.grey,
//   })  : _name = name,
//         _price = price,
//         _color = color;
//
//   @override
//   String get name => _name;
//
//   @override
//   double get price => _price;
//
//   @override
//   Color get color => _color;
//
//   @override
//   set color(Color color) => _color = color;
// }
//
// class MachineRepository {
//   List<Machine> fetchMachines() {
//     return [
//       Machine(name: 'ماشین ۱', parts: [
//         MachinePart(name: 'لاستیک', price: 0),
//         MachinePart(name: 'درها', price: 111111),
//         MachinePart(name: 'موتور', price: 111111),
//         MachinePart(name: 'موتور', price: 111111),
//         MachinePart(name: 'bada', price: 0),
//       ]),
//       Machine(name: 'ماشین ۲', parts: [
//         MachinePart(name: 'لاستیک', price: 0),
//         MachinePart(name: 'درها', price: 0),
//         MachinePart(name: 'موتور', price: 0),
//         MachinePart(name: 'موتور', price: 0),
//         MachinePart(name: 'موتور', price: 0),
//       ]),
//       Machine(name: 'ماشین ۳', parts: [
//         MachinePart(name: 'لاستیک', price: 333333),
//         MachinePart(name: 'درها', price: 33333333),
//         MachinePart(name: 'موتور', price: 333),
//         MachinePart(name: 'موتور', price: 33333),
//         MachinePart(name: 'موتور', price: 3333),
//       ]),
//       Machine(name: 'ماشین 4', parts: [
//         MachinePart(name: 'لاستیک', price: 44444),
//         MachinePart(name: 'درها', price: 4444),
//         MachinePart(name: 'موتور', price: 4444),
//         MachinePart(name: 'موتور', price: 444444),
//         MachinePart(name: 'موتور', price: 4444444444),
//       ]),
//     ];
//   }
// }
//
// class GetMachinesUseCase {
//   final MachineRepository repository;
//
//   GetMachinesUseCase(this.repository);
//
//   List<MachineEntity> execute() {
//     return repository.fetchMachines();
//   }
// }
//
// class MachineController extends GetxController {
//   final GetMachinesUseCase getMachinesUseCase;
//
//   MachineController(this.getMachinesUseCase);
//
//   final RxInt currentMachineIndex = 0.obs;
//   final RxInt currentPartIndex = (-1).obs;
//
//   final RxBool isRunning = false.obs; // Track if machine process is running
//   final RxBool shouldStop = false.obs; // Stop flag
//
//   List<MachineEntity> machines_database = [];
//
//   final List<MachinePartEntity> machines_list_view = [];
//   final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
//
//
//   final int batchSize = 2; // تعداد ماشین‌هایی که در هر بار پردازش می‌شوند
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadMachines();
//   }
//
//   Future<void> loadMachines() async {
//     // بارگذاری ماشین‌ها از منبع داده
//     machines_database.addAll(getMachinesUseCase.execute());
//     loadAndProcessMachines();
//   }
//
//   void loadAndProcessMachines() async {
//     while (machines_database.isNotEmpty) {
//       // گرفتن دوتا ماشین برای پردازش
//       List<MachineEntity> selectedMachines =
//       machines_database.take(batchSize).toList();
//
//       // حذف ماشین‌های انتخاب‌شده از لیست
//       machines_database.removeRange(0, selectedMachines.length);
//
//       // پردازش ماشین‌های انتخاب‌شده
//       await processMachines(selectedMachines);
//
//       print("Remaining machines: ${machines_database.length}");
//     }
//
//     // اگر ماشین‌ها تمام شدند، ماشین‌های جدید بارگذاری کنید
//     if (machines_database.isEmpty) {
//       await loadMachines();
//     }
//   }
//
//
//   Future<void> processMachines(List<MachineEntity> selectedMachines) async {
//     for (var machine in selectedMachines) {
//       // پردازش قطعات ماشین و دریافت نتیجه
//       bool hasGreenPart = await processMachineParts(machine);
//
//       // تصمیم‌گیری بر اساس رنگ قطعات
//       for (var part in machine.parts) {
//         if (part.color == Colors.green) {
//           if (hasGreenPart) {
//             await progresCar(part); // ارسال به متد اصلی
//           }
//         } else {
//           processCarWithNoGreenParts(part); // ارسال به متد دیگر
//         }
//       }
//     }
//   }
//
//
//
//   Future<bool> processMachineParts(MachineEntity machine) async {
//     bool hasGreenPart = false;
//
//     for (var part in machine.parts) {
//       // تنظیم رنگ قطعات بر اساس قیمت
//       part.color = part.price > 0 ? Colors.green : Colors.orange;
//
//       // اگر رنگ سبز باشد، مقدار بولی true می‌شود
//       if (part.color == Colors.green) {
//         hasGreenPart = true;
//       }
//
//       // شبیه‌سازی زمان پردازش با تأخیر
//       await Future.delayed(const Duration(milliseconds: 500));
//     }
//
//     return hasGreenPart; // برگرداندن نتیجه پردازش
//   }
//
//   Future<void> progresCar(MachinePartEntity part) async {
//     print("Processing part: ${part.name}");
//     print("ارسال اطلاعات به سرور...");
//
//     try {
//       await Future.delayed(const Duration(seconds: 4));
//       machines_list_view.add(part);
//     } catch (e) {
//       print("خطا در ارتباط با سرور: $e");
//     }
//   }
//
//   void processCarWithNoGreenParts(MachinePartEntity part) {
//     print("شییی");
//     machines_list_view.add(part);
//   }
//
//
//
//
//   Future<void> startview() async {
//     for (var machine in machines_list_view) {
//       // اضافه کردن ماشین به ویو
//       update(['machines']);  // بروزرسانی ویو
//       await Future.delayed(const Duration(seconds: 2));  // زمان تا بعدی ماشین
//
//       // حذف ماشین از ویو
//       machines_list_view.remove(machine);
//       update(['machines']);  // بروزرسانی دوباره بعد از حذف
//       await Future.delayed(const Duration(seconds: 1));  // زمان تا حذف بعدی
//     }
//
//     // بررسی اینکه آیا لیست ماشین‌ها تمام شده یا نه
//     if (machines_list_view.isEmpty) {
//       print('تمام ماشین‌ها پردازش شدند.');
//     }
//   }
//
//
//
//
// }





import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ماشین‌ها',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MachineView(),
    );
  }
}

abstract class MachineEntity {
  String get name;

  List<MachinePartEntity> get parts;
}

abstract class MachinePartEntity {
  String get name;
  double get price;
  Color get color;
  set color(Color color);
}

class Machine extends MachineEntity {
  final String _name;
  final List<MachinePart> _parts;

  Machine({required String name, required List<MachinePart> parts})
      : _name = name,
        _parts = parts;

  @override
  String get name => _name;

  @override
  List<MachinePart> get parts => _parts;
}

class MachinePart extends MachinePartEntity {
  final String _name;
  final double _price;
  Color _color;

  MachinePart({
    required String name,
    required double price,
    Color color = Colors.grey,
  })  : _name = name,
        _price = price,
        _color = color;

  @override
  String get name => _name;

  @override
  double get price => _price;

  @override
  Color get color => _color;

  @override
  set color(Color color) => _color = color;
}

class MachineRepository {
  List<Machine> fetchMachines() {
    return [
  Machine(name: 'ماشین ۱', parts: [
        MachinePart(name: 'لاستیک', price: 0),
        MachinePart(name: 'درها', price: 111111),
        MachinePart(name: 'موتور', price: 111111),
        MachinePart(name: 'موتور', price: 111111),
        MachinePart(name: 'bada', price: 0),
      ]),
      Machine(name: 'ماشین ۲', parts: [
        MachinePart(name: 'لاستیک', price: 0),
        MachinePart(name: 'درها', price: 0),
        MachinePart(name: 'موتور', price: 0),
        MachinePart(name: 'موتور', price: 0),
        MachinePart(name: 'موتور', price: 0),
      ]),
      Machine(name: 'ماشین ۳', parts: [
        MachinePart(name: 'لاستیک', price: 333333),
        MachinePart(name: 'درها', price: 33333333),
        MachinePart(name: 'موتور', price: 333),
        MachinePart(name: 'موتور', price: 33333),
        MachinePart(name: 'موتور', price: 3333),
      ]),
      Machine(name: 'ماشین 4', parts: [
        MachinePart(name: 'لاستیک', price: 44444),
        MachinePart(name: 'درها', price: 4444),
        MachinePart(name: 'موتور', price: 4444),
        MachinePart(name: 'موتور', price: 444444),
        MachinePart(name: 'موتور', price: 4444444444),

      ]),
    ];
  }
}

class GetMachinesUseCase {
  final MachineRepository repository;

  GetMachinesUseCase(this.repository);

  List<MachineEntity> execute() {
    return repository.fetchMachines();
  }
}

class MachineController extends GetxController {
  final GetMachinesUseCase getMachinesUseCase;
  final List<MachineEntity> machines_database= [];
  final RxInt currentMachineIndex = 0.obs;
  final RxInt currentPartIndex = (-1).obs;
  final RxBool isRunning = false.obs; // Track if machine process is running
  final RxBool shouldStop = false.obs; // Stop flag
  final List<MachinePartEntity> machines_list_view = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final int batchSize = 2; // تعداد ماشین‌هایی که در هر بار پردازش می‌شوند
  MachineController(this.getMachinesUseCase);

  @override
  void onInit() {
    super.onInit();
    loadMachines();
  }


    Future<void> loadMachines() async {
    // بارگذاری ماشین‌ها از منبع داده
    machines_database.addAll(getMachinesUseCase.execute());
    loadAndProcessMachines();
  }

  void loadAndProcessMachines() async {
    while (machines_database.isNotEmpty) {
      // گرفتن دوتا ماشین برای پردازش
      List<MachineEntity> selectedMachines =
      machines_database.take(batchSize).toList();

      // حذف ماشین‌های انتخاب‌شده از لیست
      machines_database.removeRange(0, selectedMachines.length);

      // پردازش ماشین‌های انتخاب‌شده
      await processMachines(selectedMachines);

      print("Remaining machines: ${machines_database.length}");
    }

    // اگر ماشین‌ها تمام شدند، ماشین‌های جدید بارگذاری کنید
    if (machines_database.isEmpty) {
      await loadMachines();
    }
  }


  Future<void> processMachines(List<MachineEntity> selectedMachines) async {
    for (var machine in selectedMachines) {
      // پردازش قطعات ماشین و دریافت نتیجه
      bool hasGreenPart = await processMachineParts(machine);

      // تصمیم‌گیری بر اساس رنگ قطعات
      for (var part in machine.parts) {
        if (part.color == Colors.green) {
          if (hasGreenPart) {
            await progresCar(part); // ارسال به متد اصلی
          }
        } else {
          processCarWithNoGreenParts(part); // ارسال به متد دیگر
        }
      }
    }
  }



  Future<bool> processMachineParts(MachineEntity machine) async {
    bool hasGreenPart = false;

    for (var part in machine.parts) {
      // تنظیم رنگ قطعات بر اساس قیمت
      part.color = part.price > 0 ? Colors.green : Colors.orange;

      // اگر رنگ سبز باشد، مقدار بولی true می‌شود
      if (part.color == Colors.green) {
        hasGreenPart = true;
      }

      // شبیه‌سازی زمان پردازش با تأخیر
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return hasGreenPart; // برگرداندن نتیجه پردازش
  }

  Future<void> progresCar(MachinePartEntity part) async {
    print("Processing part: ${part.name}");
    print("ارسال اطلاعات به سرور...");

    try {
      await Future.delayed(const Duration(seconds: 4));
      machines_list_view.add(part);
    } catch (e) {
      print("خطا در ارتباط با سرور: $e");
    }
  }

  void processCarWithNoGreenParts(MachinePartEntity part) {
    print("شییی");
    machines_list_view.add(part);
  }








  Future<void> startview() async {
    // اگر عملیات در حال اجراست، توقف درخواست می‌شود و تنها وقتی که عملیات جاری تمام شود متوقف می‌شود
    if (isRunning.value) {
      shouldStop.value = true;
      return;
    }

    // اگر عملیات در حال اجرا نیست، شروع می‌شود
    isRunning.value = true;
    shouldStop.value = false;



    for(var s in machines_list_view){
      print('${s.name}');
      print('${s.color} ${s.name} ${s.price}');
    }
    // پردازش ماشین‌ها و قطعات آن‌ها
    // for (int i = currentMachineIndex.value; i < machines_list_view.length; i++) {
    //   currentMachineIndex.value = i;
    //   currentPartIndex.value = -1;
    //
    //   // اضافه کردن قطعات ماشین به لیست نمایش
    //   for (int j = 0; j < machines_list_view.length; j++) {
    //     currentPartIndex.value = j;
    //
    //
    //     // اضافه کردن قطعه به لیست نمایش
    //    // machines_list_view.add(machinesDatabase[i].parts[j]);
    //     listKey.currentState?.insertItem(machines_list_view.length);
    //     await Future.delayed(const Duration(seconds: 2));
    //   }
    //
    //   // ریست کردن رنگ‌ها و حذف قطعات پردازش‌شده از لیست نمایش
    //   for (int j = machines_list_view.length - 1; j >= 0; j--) {
    //     currentPartIndex.value = j;
    //     machines_list_view[i].color = Colors.grey;
    //
    //     // حذف قطعه از لیست و انیمیشن حذف
    //     final removedPart = machines_list_view.removeAt(machines_list_view.length - 1);
    //     listKey.currentState?.removeItem(
    //       machines_list_view.length,
    //           (context, animation) => _buildAnimatedTile(removedPart, animation),
    //     );
    //     await Future.delayed(const Duration(seconds: 1));
    //   }
    //
    //   // چک کردن برای توقف عملیات
    //   if (shouldStop.value) {
    //     // ذخیره وضعیت فعلی
    //     currentMachineIndex.value = i + 1;  // ایندکس ماشین فعلی
    //
    //     isRunning.value = false;  // متوقف کردن عملیات پس از پردازش قطعه فعلی
    //     return;
    //   }
    //   await Future.delayed(const Duration(seconds: 2));
    // }

    // پایان فرآیند پس از اتمام همه مراحل
    isRunning.value = false;
    shouldStop.value = false;
  }

  // Widget to build each tile during animation
  Widget _buildAnimatedTile(MachinePartEntity part, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: part.color,
          child: Text(part.name[0]),
        ),
        title: Text(part.name),
        trailing: Text('${part.price} تومان'),
      ),
    );
  }
}

class MachineView extends StatelessWidget {
  final MachineController controller = Get.put(MachineController(
    GetMachinesUseCase(MachineRepository()),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ماشین‌ها')),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: controller.startview,
              child:

              // Obx(() {
              //   final currentMachine = controller.machines_list_view.isNotEmpty
              //       ? controller.machines_list_view[controller.currentMachineIndex.value]
              //       : null;

              //  return
                  Center(
                  child:
                  // Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // children: [
                      Text(
                        // currentMachine?.name ??

    'k',
                        style: const TextStyle(fontSize: 54),
                      ),
                      // const SizedBox(height: 20),
                      // RotatingMachineCircleWidget(
                      //   parts: currentMachine?.parts ?? [],
                      //   activeIndex: controller.currentPartIndex.value,
                      //   onStartStop: controller.startview,
                      //   isRunning: controller.isRunning.value,
                      // ),
                    // ],
                  // ),
                )

              ),
            ),

          // Expanded(
          //   child: AnimatedList(
          //     key: GlobalKey<AnimatedListState>(),
          //     initialItemCount: controller.machines_list_view.length,
          //     itemBuilder: (context, index, animation) {
          //       final part = controller.machines_list_view[index];
          //       return controller._buildAnimatedTile(part.parts[controller.currentPartIndex.value], animation);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}



class RotatingMachineCircleWidget extends StatefulWidget {
  final List<MachinePartEntity> parts;
  final int activeIndex;
  final Function() onStartStop; // Callback to start/stop
  final bool isRunning; // To control button color and text

  const RotatingMachineCircleWidget({
    Key? key,
    required this.parts,
    required this.activeIndex,
    required this.onStartStop,
    required this.isRunning,
  }) : super(key: key);

  @override
  _RotatingMachineCircleWidgetState createState() =>
      _RotatingMachineCircleWidgetState();
}

class _RotatingMachineCircleWidgetState
    extends State<RotatingMachineCircleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: widget.isRunning ? Colors.red : Colors.green, // Red for Stop, Green for Start
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                onPressed: widget.onStartStop, // Trigger start/stop
                child: Text(
                  widget.isRunning ? 'استپ' : 'استارت', // Switch text based on running state
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              // Rotating machine parts
              ...List.generate(widget.parts.length, (index) {
                final angle = (index / widget.parts.length) * 2 * pi +
                    _rotationAnimation.value;
                final x = 100 * cos(angle);
                final y = 100 * sin(angle);

                final part = widget.parts[index];
                final isActive = index <= widget.activeIndex;

                return Transform.translate(
                  offset: Offset(x, y),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isActive ? part.color : Colors.grey,
                        child: Text(
                          part.name[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      if (isActive && part.color != Colors.grey)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '${part.price} تومان',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}