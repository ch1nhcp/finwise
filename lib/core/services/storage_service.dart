import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/transactions/models/transaction.dart';

class StorageService {
  static const String _transactionsKey = 'transactions';
  static const String _themeColorKey = 'theme_color';
  static const String _currencyKey = 'currency';

  static Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final data = transactions.map((t) => t.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(data));
  }

  static Future<List<Transaction>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_transactionsKey);
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => Transaction.fromJson(json)).toList();
  }

  static Future<void> saveCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  static Future<String?> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }

  static Future<void> saveThemeColor(int color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeColorKey, color);
  }

  static Future<int?> loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_themeColorKey);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
