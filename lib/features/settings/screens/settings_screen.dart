import 'package:finwise/core/services/storage_service.dart';
import 'package:finwise/features/transactions/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/theme_color_picker.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../widgets/currency_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showCurrencySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CurrencySelector(),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to clear all data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await StorageService.clearAllData();
              if (context.mounted) {
                context.read<TransactionProvider>().clearTransactions();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data has been cleared')),
                );
                Navigator.pop(context);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Color',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                const ThemeColorPicker(),
              ],
            ),
          ),
          const Divider(),
          Consumer<CurrencyProvider>(
            builder: (context, provider, child) {
              return ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: const Text('Currency'),
                trailing: Text(provider.currency),
                onTap: () => _showCurrencySelector(context),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Clear All Data'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () => _showClearDataDialog(context),
          ),
        ],
      ),
    );
  }
}
