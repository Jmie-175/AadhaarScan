import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:aadhaar_scan/screens/history_screen.dart';
import 'package:aadhaar_scan/screens/scanner_screen.dart';
import 'package:aadhaar_scan/screens/settings_screen.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;

  const NavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    
    final screens = [
      const ScannerScreen(),
      const HistoryScreen(), // Replace this with the correct instance for navigation
      const SettingsScreen(),
    ];

    final navigationItems = [
      const GButton(icon: Icons.qr_code, text: 'Scanner'),
      const GButton(icon: Icons.history, text: 'History'),
      const GButton(icon: Icons.settings, text: 'Settings'),
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GNav(
        gap: 10,
        iconSize: 32,
        tabBackgroundColor: Colors.grey,
        activeColor: Colors.white,
        hoverColor: Colors.black.withOpacity(0.1),
        haptic: true,
        curve: Curves.easeOutExpo,
        tabBorderRadius: 15,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        selectedIndex: selectedIndex,
        onTabChange: (index) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screens[index],
            ),
          );
        },
        tabs: navigationItems,
      ),
    );
  }
}
