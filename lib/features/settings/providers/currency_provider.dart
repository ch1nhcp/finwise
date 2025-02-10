import 'package:finwise/core/services/storage_service.dart';
import 'package:flutter/foundation.dart';
// import '../../core/services/storage_service.dart';

class CurrencyProvider with ChangeNotifier {
  String _currency = 'USD';

  CurrencyProvider() {
    _loadCurrency();
  }

  String get currency => _currency;
  String get symbol => _currency == 'USD' ? '\$' : '₫';

  Future<void> _loadCurrency() async {
    final savedCurrency = await StorageService.loadCurrency();
    if (savedCurrency != null) {
      _currency = savedCurrency;
      notifyListeners();
    }
  }

  Future<void> updateCurrency(String currency) async {
    if (currency != _currency) {
      _currency = currency;
      await StorageService.saveCurrency(currency);
      notifyListeners();
    }
  }
}
