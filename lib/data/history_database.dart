import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("History_Database");

class HistoryDatabase {
  List history = [];

  // create initial default data
  void createDefaultData() {
    history = [
      ["uid: 123412341234", "11/3/24 12:15"],
      ["uid: 123412341234", "11/3/24 12:30"],
    ];
  }

  // load data if it already exists
  void loadData() {
    history = _myBox.get("CURRENT_HISTORY_LIST");
  }

  // update database
  void updateDatabase() {
    _myBox.put("CURRENT_HISTORY_LIST", history);
  }
}
