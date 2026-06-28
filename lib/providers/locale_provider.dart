import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  LocaleProvider({Locale? initialLocale})
      : _locale = initialLocale ?? const Locale('null');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) async {
    if (_locale != newLocale) {
      _locale = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
      await prefs.setBool('languageChosen', true);
      notifyListeners();
    }
  }

  static Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('languageCode') ?? 'null';
    return Locale(langCode);
  }

  static Future<bool> isLanguageChosen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('languageChosen') ?? false;
  }
}