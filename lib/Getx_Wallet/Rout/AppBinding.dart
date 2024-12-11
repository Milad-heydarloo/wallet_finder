import 'package:get/get.dart';
import 'package:wallet_finder/Getx_Wallet/Controller/Login_Rigester_Controller.dart';
import 'package:wallet_finder/view_front_farbod/controller/BalanceController.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppController>(() => AppController());
    Get.lazyPut<BalanceController>(() => BalanceController());
  }
}
