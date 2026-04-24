import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  // this stores selected currency symbol (default £)
  String _currency = "£";

  // savings goal + current savings
  double _savingsGoal = 1000;
  double _savingsAmount = 0;

  // NEW: store savings history (date + amount)
  List<Map<String, dynamic>> _savingsHistory = [];

  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get currency => _currency;

  double get savingsGoal => _savingsGoal;
  double get savingsAmount => _savingsAmount;

  // ✅ ADD THESE (fixes your errors)
  double get goal => _savingsGoal;
  double get savings => _savingsAmount;

  List<Map<String, dynamic>> get savingsHistory => _savingsHistory;

  // Constructor (loads saved settings)
  SettingProvider() {
    _loadSettings();
  }

  // this function loads everything from shared preferences when app starts
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _darkMode = prefs.getBool("darkMode") ?? false;
    _notificationsEnabled = prefs.getBool("notifications") ?? true;
    _currency = prefs.getString("currency") ?? "£";
    _savingsGoal = prefs.getDouble("goal") ?? 1000;
    _savingsAmount = prefs.getDouble("savings") ?? 0;

    final historyString = prefs.getString("savingsHistory");

    if (historyString != null) {
      _savingsHistory = List<Map<String, dynamic>>.from(
        jsonDecode(historyString),
      );
    }

    notifyListeners();
  }

  // this toggles dark mode
  Future<void> setDarkMode(bool value) async {
    _darkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", value);

    notifyListeners();
  }

  // this updates notifications setting
  Future<void> setNotifications(bool value) async {
    _notificationsEnabled = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("notifications", value);

    notifyListeners();
  }

  // NEW: change currency (e.g £, $, €)
  Future<void> setCurrency(String value) async {
    _currency = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("currency", value);

    notifyListeners();
  }

  // NEW: update savings goal
  Future<void> setSavingsGoal(double value) async {
    _savingsGoal = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("goal", value);

    notifyListeners();
  }

  // NEW: add money to savings + store date
  Future<void> addSavings(double value) async {
    _savingsAmount += value;

    _savingsHistory.add({
      "amount": value,
      "date": DateTime.now().toIso8601String(),
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble("savings", _savingsAmount);
    await prefs.setString("savingsHistory", jsonEncode(_savingsHistory));

    notifyListeners();
  }
}