import 'package:HexScript/models/theme_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{
  bool _isDark = false;
  ThemePreferences _preferences = ThemePreferences();
  bool get isDark => _isDark;

  ThemeProvider(){
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }
  getPreferences() async{
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }

  set isDark(bool value){
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }
}