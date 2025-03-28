import 'package:aadhaar_scan/data/history_database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:aadhaar_scan/components/nav_bar.dart';
import 'package:aadhaar_scan/screens/result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isFlashOn = false;
  // Database
  HistoryDatabase db = HistoryDatabase();
  final _myBox = Hive.box("History_Database");

  @override
  void initState() {
    if (_myBox.get("CURRENT_HISTORY_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.updateDatabase();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("AadhaarScan"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
              iconSize: 32,
              color: Colors.yellow.shade700,
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                controller.toggleFlash();
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR code in the area",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Scanning will be started automatically",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 10,
                  borderLength: 50,
                  borderWidth: 10,
                  cutOutSize: 250,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Developed by Group 12',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(
        selectedIndex: 0,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(
      (scanData) {
        if (scanData.code != null) {
          controller.pauseCamera();
          String scannedData = scanData.code!;
          DateTime dt = DateTime.now();
          db.history.add([
            scannedData,
            "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}",
          ]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultScreen(scannedData)),
          ).then(
            (_) {
              controller.resumeCamera();
            },
          );
        }
      },
    );
  }
}
