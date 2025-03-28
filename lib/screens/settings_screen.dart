import 'package:flutter/material.dart';
import 'package:aadhaar_scan/components/nav_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("AadhaarScan"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "This is the Settings Page.",
          style: TextStyle(fontSize: 20),
        ),
      ),
      bottomNavigationBar: const NavBar(
        selectedIndex: 2,
      ),
    );
  }
}
