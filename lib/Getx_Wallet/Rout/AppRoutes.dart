import 'package:get/get.dart';
import 'package:wallet_finder/Getx_Wallet/screen_secend/LicensePage.dart';
import 'package:wallet_finder/Getx_Wallet/screen_secend/main_screen.dart';
import 'package:wallet_finder/Getx_Wallet/screen_secend/register_page.dart';
import 'package:wallet_finder/Getx_Wallet/screen_secend/terms_page.dart';

class AppRoutes {
  static const String terms = '/terms';
  static const String register = '/register';
  static const String main = '/main';
  static const String licensePage = '/licensePage';

  static List<GetPage> getPages = [
    GetPage(name: terms, page: () => TermsPage()),
    GetPage(name: register, page: () => RegisterPage()),
    GetPage(name: main, page: () => MainScreen()),
    GetPage(name: licensePage, page: () => LicensePage()),
  ];
}
