import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Toggle the theme and notify the app to rebuild
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}