import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vcapp/app/data/api_call_service.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await dotenv.load(fileName: ".env");
  Get.put(ApiService());
  runApp(
    GetMaterialApp(
      title: "VC APP",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF26355D),
        scaffoldBackgroundColor: Color(0xFFFBFBFB),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF80C4E9),
          titleTextStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Color(0xFF26355D),
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}
