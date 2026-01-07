import 'package:flutter/material.dart';

class AppThemes {
  // --- LIGHT THEME ---
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4CAF50),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );

  // --- DARK THEME ---
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF4CAF50),
    scaffoldBackgroundColor: const Color(0xFF121212), // Deep Black/Grey
    cardColor: const Color(0xFF1E1E1E), // Slightly lighter grey for cards
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}