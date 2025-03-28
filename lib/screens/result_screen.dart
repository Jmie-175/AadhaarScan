import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

// ignore: must_be_immutable
class ResultScreen extends StatelessWidget {
  String scannedData;
  late String result;
  late Map<String, String> attributeMap;
  bool scanFailed = false;

  ResultScreen(this.scannedData, {super.key}) {
    _updateResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Verification',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                scanFailed ? Icons.cancel : Icons.verified,
                size: 100.0,
                color: scanFailed ? Colors.red : Colors.green,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                scanFailed ? 'Scan Failed' : 'Scan Successful',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              if (!scanFailed)
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        spreadRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: attributeMap.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 18.0, color: Colors.black),
                            children: [
                              TextSpan(
                                text: '${entry.key}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: entry.value),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              if (scanFailed)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateResult() {
    try {
      XmlDocument document = XmlDocument.parse(scannedData);
      XmlElement rootElement = document.rootElement;
      Map<String, String> map = {};

      for (var attribute in rootElement.attributes) {
        map[attribute.name.toString()] = attribute.value;
      }

      attributeMap = map;
      result = 'Cross check the Details from your Aadhaar Card';
    } catch (e) {
      // Handling XmlParserException
      scanFailed = true;
      result = 'Only Scan QR from Old Aadhaar Card';
    }
  }
}
