import 'dart:core';
import 'dart:math';

import 'package:MedBuzz/core/models/medication_history_model/medication_history.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MedicationHistoryData extends ChangeNotifier {
  static const String _boxName = "medicationHistoryBox";

  List<MedicationHistory> _medicationHistory = [];

  MedicationHistory _currentMedication;

  MedicationHistory _activeMedication;

  MedicationHistory get currentMedication => _currentMedication;

  List<MedicationHistory> get medicationHistory => _medicationHistory;

  Future<void> addMedicationReminderHistory(MedicationHistory history) async {
    var box = await Hive.openBox<MedicationHistory>(_boxName);

    await box.put(history.id.toString(), history);

    _medicationHistory = box.values.toList();

    box.close();

    notifyListeners();
  }

  void updateAvailableMedicationHistory(medicationHistory) {
    _medicationHistory = medicationHistory;
    notifyListeners();
  }

  void deleteScheduleHistory(key) async {
    var box = await Hive.openBox<MedicationHistory>(_boxName);

    _medicationHistory = box.values.toList();
    box.delete(key);
    box.close();

    notifyListeners();
  }

  void setActiveMedicationHistory(key) async {
    var box = await Hive.openBox<MedicationHistory>(_boxName);

    _activeMedication = box.get(key);

    notifyListeners();
  }

  MedicationHistory getActiveMedicationHistory() {
    return _activeMedication;
  }

  void getMedicationHistory() async {
    var box = await Hive.openBox<MedicationHistory>(_boxName);

    _medicationHistory = box.values.toList();
    notifyListeners();
  }
}
