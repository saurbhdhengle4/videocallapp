import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  static const _userEmailKey = 'userEmail';

  @override
  void onInit() {
    initialization();
    getUserData();
    super.onInit();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_userEmailKey);
    userName.value = storedEmail ?? "";
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  RxString userName = "".obs;
}
