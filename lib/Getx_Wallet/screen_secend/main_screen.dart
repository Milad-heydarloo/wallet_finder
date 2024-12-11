
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:wallet_finder/Getx_Wallet/SharePrefrenss/share.dart';
import 'package:wallet_finder/view_front_farbod/controller/BalanceController.dart';

class MainScreen extends StatelessWidget {
  final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  final BalanceController controller = Get.put(BalanceController());
  @override
  Widget build(BuildContext context) {
    controller.  statusMessage.value ='disable';

    return Scaffold(
      appBar: AppBar(
        title: Text('Super Hunter',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white, // حذف پس‌زمینه ناچ بار
        elevation: 0, // حذف سایه
        centerTitle: true,

        automaticallyImplyLeading: false, // حذف دکمه Back
      ),
      body:

      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: _loadData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('خطا در بارگذاری اطلاعات'));
              } else {
                final data = snapshot.data!;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Text('خوش آمدید!'),
                      // Text(
                      //     'قوانین رو پذیرفته: ${data['termsAccepted'] ? "بله" : "خیر"}'),
                      // Text('آدرس تلفن همراه: ${data['deviceId'] ?? "نامشخص"}'),
                      // Text('آدرس ثبت‌نام اختصاصی تلگرام: '),
                      // Text('${data['botUrl'] ?? "نامشخص"} '),
                      // Text(
                      //     'لایسنس دار؟: ${data['isLicenseValid'] ? "بله" : "خیر"}'),

                      // نمایش شمارش معکوس جداشده
                      Builder(
                        builder: (context) {
                          final expirationTimeString = data['expiration_time'];
                          if (expirationTimeString != null) {
                            try {
                              // تبدیل رشته به تاریخ
                              DateTime expirationTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(expirationTimeString);

                              // محاسبه مدت زمان باقی‌مانده
                              Duration remainingTime = expirationTime.isAfter(DateTime.now())
                                  ? expirationTime.difference(DateTime.now())
                                  : Duration.zero;

                              return SlideCountdownSeparated(
                                duration: remainingTime,
                                separatorStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              );
                            } catch (e) {
                              return Text('Invalid date format');
                            }
                          } else {
                            return Text('No expiration date provided');
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),

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
                  // Icon(
                  //   Icons.account_balance_wallet, // آیکون کیف پول
                  //   size: 50, // اندازه آیکون
                  //   color: Colors.amber, // رنگ آیکون بر اساس درصد
                  // ),
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
         SizedBox(height: 10),

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
          // // نمایش تعداد رکوردهای پردازش‌شده
          // Obx(() => Text(
          //   'Total Records Processed: ${controller.totalItemsFetched.value}',
          //   style: TextStyle(fontSize: 20),
          // )),
          // SizedBox(height: 10),
          //
          // // نمایش تعداد رکوردهای باقی‌مانده
          // Obx(() => Text(
          //   'Remaining Records: ${controller.balanceList.length}',
          //   style: TextStyle(fontSize: 16),
          // )),

          SizedBox(height: 3),


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
                        crossAxisSpacing: 2, // فاصله بین ستون‌ها
                        mainAxisSpacing: 2, // فاصله بین ردیف‌ها
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
      ))





    ;
  }

  Future<Map<String, dynamic>> _loadData() async {
    final botUrl = await prefsHelper.getBotUrl();
    final termsAccepted = await prefsHelper.isTermsAccepted();
    final deviceId = await prefsHelper.getDeviceId();

    final isLicenseValid = await prefsHelper.isLicenseValid();
    final remainingDays = await prefsHelper.getRemainingDays();
print(remainingDays);
    return {
      'termsAccepted': termsAccepted,
      'settings': deviceId,
      'botUrl': botUrl,
      'isLicenseValid': isLicenseValid,
      'expiration_time': remainingDays,
    };
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
                  fontSize: isLarge ? 14 : 6,
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

