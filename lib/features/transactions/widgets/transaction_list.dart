import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  String _getDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        if (provider.transactions.isEmpty) {
          return const Center(
            child: Text('No transactions yet'),
          );
        }

        // Sort transactions by date (newest first)
        final sortedTransactions = provider.transactions.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        // Group transactions by date
        String? currentDateKey;
        
        return ListView.builder(
          itemCount: sortedTransactions.length,
          itemBuilder: (context, index) {
            final transaction = sortedTransactions[index];
            final dateKey = _getDateKey(transaction.date);
            final showDate = dateKey != currentDateKey;
            
            if (showDate) {
              currentDateKey = dateKey;
            }

            return TransactionItem(
              transaction: transaction,
              showDate: showDate,
            );
          },
        );
      },
    );
  }
}