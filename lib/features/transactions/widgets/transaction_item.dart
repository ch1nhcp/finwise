import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import 'quick_add_transaction.dart';
import '../../settings/providers/currency_provider.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final bool showDate;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.showDate = true,
  });

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuickAddTransaction(
        transaction: transaction,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context
                  .read<TransactionProvider>()
                  .deleteTransaction(transaction.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content:
                const Text('Are you sure you want to delete this transaction?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        return result ?? false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<TransactionProvider>().deleteTransaction(transaction.id);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDate)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                DateFormat('EEEE, MMMM d, y').format(transaction.date),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ),
          ListTile(
            onTap: () => _showEditDialog(context),
            onLongPress: () => _showDeleteDialog(context),
            leading: CircleAvatar(
              backgroundColor: transaction.type == TransactionType.expense
                  ? Colors.red[100]
                  : Colors.green[100],
              child: Icon(
                transaction.type == TransactionType.expense
                    ? Icons.remove
                    : Icons.add,
                color: transaction.type == TransactionType.expense
                    ? Colors.red
                    : Colors.green,
              ),
            ),
            title: Text(transaction.category),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transaction.note?.isNotEmpty ?? false)
                  Text(transaction.note!),
                Text(
                  DateFormat('h:mm a').format(transaction.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: Consumer<CurrencyProvider>(
              builder: (context, currencyProvider, _) {
                final symbol = currencyProvider.currency == 'USD' ? '\$' : '₫';
                final amount = currencyProvider.currency == 'USD'
                    ? transaction.amount
                    : transaction.amount * 23000; // Basic VND conversion
                return Text(
                  '$symbol${amount.toStringAsFixed(currencyProvider.currency == 'USD' ? 2 : 0)}',
                  style: TextStyle(
                    color: transaction.type == TransactionType.expense
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
