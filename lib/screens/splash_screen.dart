import 'package:flutter/material.dart';
import 'package:aadhaar_scan/screens/scanner_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScannerScreen()),
      );
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.white,
          ),
          Center(
            child: Image.asset(
              'assets/uidai_logo.png',
              width: 300,
              height: 300,
            ),
          ),

          const Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              'AadhaarScan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
