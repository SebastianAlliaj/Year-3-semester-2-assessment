import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  // NEW: currency + savings goal + savings jar
  String _currency = "£";
  double _savingsGoal = 1000;
  double _savingsAmount = 0;

  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  // getters for new features
  String get currency => _currency;
  double get savingsGoal => _savingsGoal;
  double get savingsAmount => _savingsAmount;

  // Constructor (loads saved settings)
  SettingProvider() {
    _loadSettings();
  }

  // this function loads the saved settings from shared preferences when the provider is initialized
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _darkMode = prefs.getBool("darkMode") ?? false;
    _notificationsEnabled = prefs.getBool("notifications") ?? true;

    // load new values
    _currency = prefs.getString("currency") ?? "£";
    _savingsGoal = prefs.getDouble("goal") ?? 1000;
    _savingsAmount = prefs.getDouble("savings") ?? 0;

    notifyListeners();
  }

  // this toggles the dark mode setting and saves it to shared preferences 
  Future<void> setDarkMode(bool value) async {
    _darkMode = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", value);

    notifyListeners();
  }

  // this function updates the notification setting and saves it to shared preferences so it persists across app restarts
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

  // NEW: set savings goal
  Future<void> setGoal(double value) async {
    _savingsGoal = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("goal", value);

    notifyListeners();
  }

  // NEW: add money to savings jar
  Future<void> addSavings(double value) async {
    _savingsAmount += value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("savings", _savingsAmount);

    notifyListeners();
  }
}