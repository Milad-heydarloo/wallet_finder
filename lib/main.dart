
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:wallet_finder/Getx_Wallet/Rout/AppRoutes.dart';
import 'package:wallet_finder/Getx_Wallet/SharePrefrenss/share.dart';

Future<void> main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'فعال‌سازی',
      theme: ThemeData(
        fontFamily: 'vazir',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.terms,
      getPages: AppRoutes.getPages,
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


