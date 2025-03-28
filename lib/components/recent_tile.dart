import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xml/xml.dart';

// ignore: must_be_immutable
class RecentTile extends StatelessWidget {
  final String scannedData;
  final String scannedTime;
  final Function(BuildContext)? scanTile;
  final Function(BuildContext)? deleteTile;
  late Map<String, String> attributeMap;
  bool scanFailed = false;

  RecentTile({
    super.key,
    required this.scannedData,
    required this.scannedTime,
    required this.scanTile,
    required this.deleteTile,
  }) {
    attributeMap = {};
    getName(scannedData);
  }

  @override
  Widget build(BuildContext context) {
    if (scanFailed) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            // View Button
            SlidableAction(
              onPressed: scanTile,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.qr_code,
              borderRadius: BorderRadius.circular(8),
            ),
            // Delete Button
            SlidableAction(
              onPressed: deleteTile,
              backgroundColor: Colors.red.shade400,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attributeMap['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    scannedTime,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_back,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  void getName(String scannedData) {
    try {
      XmlDocument document = XmlDocument.parse(scannedData);
      XmlElement rootElement = document.rootElement;

      for (var attribute in rootElement.attributes) {
        attributeMap[attribute.name.toString()] = attribute.value;
      }
    } catch (e) {
      scanFailed = true;
    }
  }
}
