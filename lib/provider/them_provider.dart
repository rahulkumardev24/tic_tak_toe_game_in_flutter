import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  /// create getter for theme mode
  bool get isDark => _isDarkMode;

  /// create constructor to load theme
  ThemProvider() {
    _loadTheme();
  }

  /// create function toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    /// store in shared preferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isDarkMode", _isDarkMode);
  }

  /// load saved theme from shared preferences
  Future<void> _loadTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isDarkMode = sharedPreferences.getBool("isDarkMode") ?? false;
    notifyListeners();
  }
}
