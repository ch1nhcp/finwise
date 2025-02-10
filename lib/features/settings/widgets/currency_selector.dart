import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class CurrencySelector extends StatelessWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrencyProvider>(context);
    
    return AlertDialog(
      title: const Text('Select Currency'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('US Dollar (USD)'),
            leading: const Text('\$'),
            selected: provider.currency == 'USD',
            onTap: () {
              provider.updateCurrency('USD');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Vietnamese Dong (VND)'),
            leading: const Text('₫'),
            selected: provider.currency == 'VND',
            onTap: () {
              provider.updateCurrency('VND');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}