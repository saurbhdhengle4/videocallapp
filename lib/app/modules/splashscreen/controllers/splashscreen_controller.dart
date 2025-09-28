import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vcapp/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  static const _userEmailKey = 'userEmail';

  @override
  void onInit() {
    super.onInit();
    initialization();
    checkLoginStatus();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_userEmailKey);

    await Future.delayed(const Duration(seconds: 2));

    if (storedEmail != null && storedEmail.isNotEmpty) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
