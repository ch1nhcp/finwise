import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../../../core/services/storage_service.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  List<Transaction> get transactions {
    return _transactions.where((transaction) {
      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty ||
          transaction.category
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (transaction.note
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false);

      // Apply date filter
      final withinDateRange = (_startDate == null ||
              transaction.date.isAfter(_startDate!) ||
              transaction.date.isAtSameMomentAs(_startDate!)) &&
          (_endDate == null ||
              transaction.date.isBefore(_endDate!) ||
              transaction.date.isAtSameMomentAs(_endDate!));

      return matchesSearch && withinDateRange;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void updateFilters({
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    _searchQuery = searchQuery ?? '';
    _startDate = startDate;
    _endDate = endDate;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  // Add this getter to expose transactions
  // List<Transaction> get transactions => List.unmodifiable(_transactions);

  TransactionProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    _transactions = await StorageService.loadTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    await StorageService.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      await StorageService.saveTransactions(_transactions);
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
    await StorageService.saveTransactions(_transactions);
    notifyListeners();
  }

  void clearTransactions() {
    _transactions = [];
    notifyListeners();
  }
}
