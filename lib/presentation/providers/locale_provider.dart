import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  // Default to English
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    // Only update if the new locale is different
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners(); // This tells the app to rebuild in the new language
  }
}