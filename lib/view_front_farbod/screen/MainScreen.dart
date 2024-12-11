import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet_finder/view_front_farbod/controller/BalanceController.dart';
import 'package:wallet_finder/view_front_farbod/service/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Balance Inquiry',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final BalanceController controller = Get.put(BalanceController());

  @override
  Widget build(BuildContext context) {
    controller.  statusMessage.value ='disable';
    return Scaffold(
      appBar: AppBar(
        title: Text('Balance Manager'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Switch برای فعال/غیرفعال کردن Auto Fetch
          Obx(() => SwitchListTile(
            title: Text('Enable Auto Fetch'),
            value: controller.isSwitchEnabled.value,
            onChanged: (value) async {
              if(value){
                controller.  statusMessage.value ='start';

              }else{
                controller.  statusMessage.value ='stop';
              }
              controller.isSwitchEnabled.value = value;
              await controller.handleSwitchAction();
            },
          )),
          SizedBox(height: 20),
          // ویجت باتری داینامیک
          Obx(() {
            if (controller.maxItems.value == 0) return Container();

            double percentage = controller.balanceList.isEmpty
                ? 0
                : (controller.balanceList.length / controller.maxItems.value);
            percentage = percentage.clamp(0.0, 1.0);

            Color batteryColor;
            if (percentage > 0.5) {
              batteryColor = Colors.green;
            } else if (percentage > 0.2) {
              batteryColor = Colors.orange;
            } else {
              batteryColor = Colors.red;
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // قاب باتری
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 100 * percentage,
                        height: 50,
                        decoration: BoxDecoration(
                          color: batteryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.account_balance_wallet, // آیکون کیف پول
                    size: 50, // اندازه آیکون
                    color: Colors.amber, // رنگ آیکون بر اساس درصد
                  ),
                  // عدد داخل باتری
                  // Text(
                  //   '${(percentage * 100).toInt()}%', // نمایش درصد شارژ
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            );
          }),
          // نمایش پیام وضعیت
          Obx(() => Text(
            controller.statusMessage.value,
            style: TextStyle(color: Colors.green, fontSize: 16),
          )),
          SizedBox(height: 20),


          // نمایش تعداد رکوردهای پردازش‌شده
          Obx(() => Text(
            'Total Records Processed: ${controller.totalItemsFetched.value}',
            style: TextStyle(fontSize: 20),
          )),
          SizedBox(height: 10),

          // نمایش تعداد رکوردهای باقی‌مانده
          Obx(() => Text(
            'Remaining Records: ${controller.balanceList.length}',
            style: TextStyle(fontSize: 16),
          )),

          SizedBox(height: 20),


          Obx(() {
            if (controller.balances.isEmpty) {
              return Center(child: Text('No data available'));
            }

            // جدا کردن mnemonic از سایر مقادیر
            final mnemonicEntry = controller.balances.firstWhere(
                  (entry) => entry.key == 'memonic',
              orElse: () => MapEntry('memonic', ''), // مقدار پیش‌فرض
            );

            final otherEntries = controller.balances
                .where((entry) => entry.key != 'memonic')
                .toList();

            return Expanded(
              child: Column(
                children: [
                  // کارت مخصوص mnemonic
                  if (mnemonicEntry.value.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: BalanceItem(
                        title: mnemonicEntry.key,
                        value: mnemonicEntry.value,
                        isLarge: true, // نمایش به صورت کارت بزرگ‌تر
                      ),
                    ),
                  // نمایش سایر مقادیر
                  Expanded(

                    child: GridView.builder(

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // تعداد ستون‌ها
                        crossAxisSpacing: 4, // فاصله بین ستون‌ها
                        mainAxisSpacing: 4, // فاصله بین ردیف‌ها
                      ),
                      itemCount: otherEntries.length,
                      itemBuilder: (context, index) {
                        final entry = otherEntries[index];
                        return BalanceItem(
                          title: entry.key,
                          value: entry.value,
                          isLarge: false, // نمایش به صورت کارت معمولی
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ));

  }
}





class BalanceItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isLarge;

  const BalanceItem({
    required this.title,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        //  crossAxisAlignment: isLarge ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isLarge ? 16 : 15,
                color: Colors.black87,
              ),
              textAlign: isLarge ? TextAlign.center : TextAlign.start,
            ),
            SizedBox(height: isLarge ? 20 : 13),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                value,
                key: ValueKey(value),
                style: TextStyle(
                  fontSize: isLarge ? 14 : 10,
                  color: Colors.black54,
                ),
                overflow: isLarge ? TextOverflow.visible : TextOverflow.ellipsis, // سه نقطه فقط در حالت کوچک
                maxLines: isLarge ? null : 1, // محدودیت خطوط فقط در حالت کوچک
                softWrap: isLarge ? true : false, // پیچیدن متن فقط در حالت کوچک غیرفعال
              ),

            ),
          ],
        ),
      ),
    );
  }
}


// class BalanceItem extends StatelessWidget {
//   final String title;
//   final String value;
//   final bool isLarge; // مشخص‌کننده اندازه کارت
//
//   const BalanceItem({
//     required this.title,
//     required this.value,
//     this.isLarge = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: isLarge
//               ? CrossAxisAlignment.center
//               : CrossAxisAlignment.start,
//           children: [
//             // متن ثابت برای Title
//             Text(
//               title.toUpperCase(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: isLarge ? 16 : 12, // اندازه فونت متفاوت
//                 color: Colors.black87,
//               ),
//               textAlign: isLarge ? TextAlign.center : TextAlign.start,
//             ),
//             SizedBox(height: isLarge ? 20 : 10),
//             // انیمیشن متن برای Value
//             AnimatedSwitcher(
//               duration: Duration(milliseconds: 300), // مدت زمان تغییر
//               transitionBuilder: (child, animation) {
//                 return FadeTransition(opacity: animation, child: child);
//               },
//               child: AnimatedTextKit(
//                 key: ValueKey(value), // تغییر کلید در صورت تغییر مقدار
//                 repeatForever: false, // انیمیشن فقط یک بار اجرا شود
//                 isRepeatingAnimation: false,
//                 animatedTexts: [
//                   TyperAnimatedText(
//                     value,
//                     textStyle: TextStyle(
//                       fontSize: isLarge ? 14 : 6, // اندازه فونت متفاوت
//                       color: Colors.black54,
//                     ),
//                     speed: Duration(milliseconds: 15), // سرعت تایپ
//                   ),
//                 ],
//                 onFinished: () {
//                   // عملیات خاصی پس از تکمیل انیمیشن نیاز نیست
//                 },
//                 displayFullTextOnTap: true, // متن کامل را در صورت کلیک نشان می‌دهد
//                 stopPauseOnTap: true, // انیمیشن را متوقف می‌کند
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BalanceItem extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const BalanceItem({
//     required this.title,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title.toUpperCase(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 5,
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Balance Inquiry',
//       theme: ThemeData(primarySwatch: Colors.orange),
//       home: MainScreen(),
//     );
//   }
// }
//
// class MainScreen extends StatelessWidget {
//   final BalanceController controller = Get.put(BalanceController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Balance Manager'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           // Switch برای فعال/غیرفعال کردن Auto Fetch
//           Obx(() => SwitchListTile(
//             title: Text('Enable Auto Fetch'),
//             value: controller.isSwitchEnabled.value,
//             onChanged: (value) async {
//               controller.isSwitchEnabled.value = value;
//               await controller.handleSwitchAction();
//             },
//           )),
//
//
//           SizedBox(height: 20),
//           // ویجت باتری داینامیک
//
//           Obx(() {
//             if (controller.maxItems.value == 0) return Container();
//
//             double percentage = controller.balanceList.isEmpty
//                 ? 0
//                 : (controller.balanceList.length / controller.maxItems.value);
//             percentage = percentage.clamp(0.0, 1.0);
//
//             Color batteryColor;
//             if (percentage > 0.5) {
//               batteryColor = Colors.green;
//             } else if (percentage > 0.2) {
//               batteryColor = Colors.orange;
//             } else {
//               batteryColor = Colors.red;
//             }
//
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // قاب باتری
//                   Container(
//                     width: 100,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black, width: 2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//                         width: 100 * percentage,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: batteryColor,
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Icon(
//                     Icons.account_balance_wallet, // آیکون کیف پول
//                     size: 50, // اندازه آیکون
//                     color: Colors.amber, // رنگ آیکون بر اساس درصد
//                   ),
//
//                 ],
//               ),
//             );
//           }),
//           // نمایش پیام وضعیت
//           Obx(() => Text(
//             controller.statusMessage.value,
//             style: TextStyle(color: Colors.green, fontSize: 16),
//           )),
//           SizedBox(height: 20),
//
//
//           // نمایش تعداد رکوردهای پردازش‌شده
//           Obx(() => Text(
//                 'Total Records Processed: ${controller.totalItemsFetched.value}',
//                 style: TextStyle(fontSize: 20),
//               )),
//           SizedBox(height: 10),
//
//           // نمایش تعداد رکوردهای باقی‌مانده
//           Obx(() => Text(
//                 'Remaining Records: ${controller.balanceList.length}',
//                 style: TextStyle(fontSize: 16),
//               )),
//
//           SizedBox(height: 20),
//
//           Obx(
//             () => controller.balances.isEmpty
//                 ? Center(child: Text('No data available'))
//                 : Expanded(
//                     child: GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3, // تعداد ستون‌ها
//                         crossAxisSpacing: 4, // فاصله بین ستون‌ها
//                         mainAxisSpacing: 4, // فاصله بین ردیف‌ها
//                       ),
//                       itemCount: controller.balances.length,
//                       itemBuilder: (context, index) {
//                         final entry = controller.balances[index];
//                         return BalanceItem(
//                             title: entry.key, value: entry.value);
//                       },
//                     ),
//                   ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }
//
// class BalanceItem extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const BalanceItem({
//     required this.title,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title.toUpperCase(),
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 8,
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


