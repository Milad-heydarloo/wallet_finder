import 'package:flutter/material.dart';
import 'package:wallet_finder/Getx_Wallet/SharePrefrenss/share.dart';

class MainScreen extends StatelessWidget {
  final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // حذف پس‌زمینه ناچ بار
        elevation: 0, // حذف سایه
        centerTitle: true,
        automaticallyImplyLeading: false, // حذف دکمه Back
      ),
      body: FutureBuilder<Map<String, dynamic>>(
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
                  Text('خوش آمدید!'),
                  Text(
                      'قوانین رو پذیرفته: ${data['termsAccepted'] ? "بله" : "خیر"}'),
                  Text('آدرس تلفن همراه: ${data['deviceId'] ?? "نامشخص"}'),
                  Text('آدرس ثبت‌نام اختصاصی تلگرام: '),
                  Text('${data['botUrl'] ?? "نامشخص"} '),
                  Text(
                      'لایسنس دار؟: ${data['isLicenseValid'] ? "بله" : "خیر"}'),
                  Text('تا کی داره؟: ${data['expiration_time'] ?? "نامشخص"}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadData() async {
    final termsAccepted = await prefsHelper.isTermsAccepted();
    final deviceId = await prefsHelper.getDeviceId();
    final botUrl = await prefsHelper.getBotUrl();
    final isLicenseValid = await prefsHelper.isLicenseValid();
    final remainingDays = await prefsHelper.getRemainingDays();

    return {
      'termsAccepted': termsAccepted,
      'deviceId': deviceId,
      'botUrl': botUrl,
      'isLicenseValid': isLicenseValid,
      'expiration_time': remainingDays,
    };
  }
}
