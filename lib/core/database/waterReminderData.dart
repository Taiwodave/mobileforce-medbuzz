import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/water_reminder_model/water_reminder.dart';

class WaterReminderData extends ChangeNotifier {
  static const String _boxName = "waterReminderBox";

  List<WaterReminder> _waterReminders = [];
  List<WaterReminder> _sortedReminders = [];

  List<WaterReminder> get waterReminders => _waterReminders;
  List<WaterReminder> get sortedReminders => _sortedReminders;

  WaterReminder _activeWaterReminder;
  bool done = false;
  bool skip = false;
  void getWaterReminders() async {
    try {
      var box = await Hive.openBox<WaterReminder>(_boxName);

      _waterReminders = box.values.toList();

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  WaterReminder getWaterReminder(index) {
    return _waterReminders[index];
  }

  // int get currentLevel => _waterReminders
  //     .map((e) => e.ml)
  //     .reduce((value, element) => value + element);

  // int get totalLevel => _waterReminders
  //     .map((e) => e.ml)
  //     .reduce((value, element) => value + element);

  Future<void> addWaterReminder(WaterReminder waterReminder) async {
    var box = await Hive.openBox<WaterReminder>(_boxName);

    await box.put(waterReminder.id, waterReminder);

    //reinitialise water reminders after write operation
    _waterReminders = box.values.toList();

    // box.close();

    notifyListeners();
  }

  Future<void> deleteWaterReminder(key) async {
    try {
      var box = await Hive.openBox<WaterReminder>(_boxName);

      //delete the water reminder
      await box.delete(key);

      // then reinitialise the water reminders
      _waterReminders = box.values.toList();

      box.close();

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void editWaterReminder(
      {WaterReminder waterReminder, String waterReminderKey}) async {
    var box = await Hive.openBox<WaterReminder>(_boxName);

    await box.put(waterReminderKey, waterReminder);

    _waterReminders = box.values.toList();
    box.close();

    // _activeWaterReminder = box.get(waterReminderKey);

    notifyListeners();
  }

  void setActiveWaterReminder(key) async {
    var box = await Hive.openBox<WaterReminder>(_boxName);

    _activeWaterReminder = box.get(key);

    notifyListeners();
  }

  List<WaterReminder> getActiveReminders() {
    // var today = DateTime.now().add(Duration(days: 5));

    return _waterReminders;
  }

  int get waterRemindersCount {
    return _waterReminders.length;
  }

  int get totalLevel {
    // if (_waterReminders.isEmpty || getActiveReminders().isEmpty) {
    //   return 0;
    // }
    // return getActiveReminders()[0]?.ml ?? 0;
    return 3500;
  }

  int get currentLevel {
    var taken = _waterReminders.where((element) => element.isTaken == true);
    if (taken.isEmpty) {
      return 0;
    }
    return taken.map((e) => e.ml).reduce((value, element) => value + element);

    // return val;
  }


  double get progress {
    var value = 0 / totalLevel;
    return value.isNaN ? 0.0 : value;
  }
}
//  return currentLevel <= 100
//         ? 0
//         : currentLevel <= 500
//             ? 0.2
//             : currentLevel < 1500
//                 ? 0.3
//                 : currentLevel == 1500
//                     ? 0.5
//                     : currentLevel <= 2000
//                         ? 0.6
//                         : currentLevel < 3000 ? 0.8 : 1;
