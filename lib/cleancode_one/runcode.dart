

import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:wallet_finder/cleancode_one/ApiService/ApiService.dart';
import 'package:wallet_finder/cleancode_one/Processor/MachineProcessor.dart';
import 'Database/DataBaseWallet/base/DatabaseRepositoryImpl.dart';
import 'Database/DataBaseWallet/view/DatabaseRepositoryImplView.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // پیکربندی سرویس برای اجرا در پس‌زمینه
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,  // زمانی که سرویس شروع می‌شود، این تابع اجرا می‌شود
      autoStart: true,  // سرویس به طور خودکار شروع می‌شود
      isForegroundMode: false,  // نیازی به اطلاعیه در حالت foreground نیست
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,  // سرویس به طور خودکار شروع می‌شود
      onForeground: onStart,  // برای iOS در حالت foreground این تابع اجرا می‌شود
      onBackground: onIosBackground,  // برای iOS در حالت background این تابع اجرا می‌شود
    ),
  );
}

// این تابع زمانی که سرویس در پس‌زمینه (برای iOS و Android) شروع می‌شود، اجرا می‌شود
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  // ذخیره کردن لاگ‌ها یا انجام عملیات در پس‌زمینه
  final log = DateTime.now().toIso8601String();
  print("Background Service Running: $log");

  return true;
}

// منطق اصلی سرویس پس‌زمینه (زمانی که سرویس شروع می‌شود، این تابع اجرا می‌شود)
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // راه‌اندازی منطق پردازش
  final dbBase = DatabaseRepositoryImpl();
  final dbView = DatabaseRepositoryImplView();
  final apiService = ApiService_Wallet();
  final processor = MachineProcessor(dbBase, apiService, dbView);
  await processor.ensureDatabaseIsFilledAndProcess();

  // انجام وظایف دوره‌ای در پس‌زمینه
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    // لاگ‌گذاری یا انجام عملیات به صورت دوره‌ای
    print("Running background task at ${DateTime.now()}");
  });
}
