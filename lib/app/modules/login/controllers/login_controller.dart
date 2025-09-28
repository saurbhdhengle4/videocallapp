import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vcapp/app/routes/app_pages.dart';
// import 'dart:convert';

// import 'package:vcapp/app/data/api_call_service.dart';
// import 'package:vcapp/app/data/urls_end_point.dart';

enum LoginState { initial, loading, success, error }

class LoginController extends GetxController {
  // final ApiService _apiService = Get.find<ApiService>();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  Rx<LoginState> loginState = LoginState.initial.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    initialization();
    super.onInit();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!GetUtils.isEmail(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static const _userEmailKey = 'userEmail';

  Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    loginState.value = LoginState.loading;
    errorMessage.value = '';

    await Future.delayed(const Duration(seconds: 1));

    String email = emailController.text.trim();
    String password = passwordController.text;

    const mockEmail = "user@gmail.com";
    const mockPassword = "Reset@123";

    if (email == mockEmail && password == mockPassword) {
      loginState.value = LoginState.success;
      await saveUserEmail(email);
      Get.offAndToNamed(Routes.HOME);
    } else {
      errorMessage.value = 'Invalid email or password';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 2),
      );

      loginState.value = LoginState.error;
    }
  }

  /*
  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    loginState.value = LoginState.loading;
    errorMessage.value = '';

    try {
      ApiResult apiResult = await _apiService.post(APIEndPoints.login, {
        "email": emailController.text.trim(),
        "password": passwordController.text,
      }, isAuthTokenRequired: true);

      if (apiResult.statusCode == 200||apiResult.statusCode == 201) {
        loginState.value = LoginState.success;
        await saveUserEmail(email); 
         Get.offAndToNamed(Routes.HOME);
      } else {
        final responseJson = json.decode(apiResult.data);
        errorMessage.value = responseJson['error'] ?? 'Login failed';
        loginState.value = LoginState.error;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      loginState.value = LoginState.error;
    }
  }
*/
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
