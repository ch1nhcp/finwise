import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart'; // Fixed import path

class ThemeProvider with ChangeNotifier {
  Color _primaryColor = const Color(0xFF1E88E5);

  ThemeProvider() {
    _loadThemeColor();
  }

  Color get primaryColor => _primaryColor;

  Future<void> _loadThemeColor() async {
    final savedColor = await StorageService.loadThemeColor();
    if (savedColor != null) {
      _primaryColor = Color(savedColor);
      notifyListeners();
    }
  }

  Future<void> updatePrimaryColor(Color color) async {
    _primaryColor = color;
    await StorageService.saveThemeColor(color.value);
    notifyListeners();
  }
}
