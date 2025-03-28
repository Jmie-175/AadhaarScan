import 'package:aadhaar_scan/components/nav_bar.dart';
import 'package:aadhaar_scan/components/recent_tile.dart';
import 'package:aadhaar_scan/data/history_database.dart';
import 'package:aadhaar_scan/screens/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('AadhaarScan'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                if (db.history.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete All"),
                        content: const Text(
                            "Are you sure you want to delete history?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                db.history.removeRange(0, db.history.length);
                              });
                              db.updateDatabase();
                            },
                            child: const Text("Continue"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show a message when there are no tasks to delete
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("No scans to Delete"),
                        content: const Text("Try scanning an Aadhaar Card QR code."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              icon: const Icon(Icons.delete_forever),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: db.history.length,
          itemBuilder: (context, index) {
            return RecentTile(
              scannedData: db.history[index][0],
              scannedTime: db.history[index][1],
              scanTile: (context) => openResult(index),
              deleteTile: (context) => deleteData(index),
            );
          },
        ),
      ),
      bottomNavigationBar: const NavBar(
        selectedIndex: 1,
      ),
    );
  } //Widget

  void openResult(int index) {
    String scannedData = db.history[index][0];
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(scannedData)),
      );
    });
  }

  void deleteData(int index) {
    setState(() {
      db.history.removeAt(index);
    });
    db.updateDatabase();
  }
}
