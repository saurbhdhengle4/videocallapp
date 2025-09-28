import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vcapp/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final exit = await _showExitConfirmation();
        return exit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            title: Text(
              "Welcome",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                color: Color(0xFF26355D),
                fontSize: 20,
              ),
            ),
            subtitle: Obx(
              () => Text(
                controller.userName.value,
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Color(0xFF26355D),
                ),
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.power_settings_new_outlined),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildCard(
                      icon: Icons.video_call,
                      label: "Video Call",
                      color: const Color(0xFF86B0BD),
                      onTap: () => Get.toNamed(Routes.VIDEOSCREEN),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCard(
                      icon: Icons.person,
                      label: "Users",
                      color: const Color(0xFF6D94C5),
                      onTap: () => Get.toNamed(Routes.USER),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: Colors.white),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmation() {
    return Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Exit App',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to exit the app?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: GoogleFonts.roboto()),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Exit', style: GoogleFonts.roboto()),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Confirm Logout',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel', style: GoogleFonts.roboto()),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Logout', style: GoogleFonts.roboto()),
          ),
        ],
      ),
    );

    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
