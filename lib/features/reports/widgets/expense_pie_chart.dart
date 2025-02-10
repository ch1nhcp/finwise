import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../transactions/models/transaction.dart';

class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final expenses = provider.transactions
            .where((t) => t.type == TransactionType.expense)
            .toList();

        if (expenses.isEmpty) {
          return const Center(
            child: Text('No expenses to display'),
          );
        }

        // Group expenses by category
        final categoryMap = <String, double>{};
        for (var expense in expenses) {
          categoryMap[expense.category] = (categoryMap[expense.category] ?? 0) + expense.amount;
        }

        // Convert to pie chart sections
        final sections = categoryMap.entries.map((entry) {
          final color = Colors.primaries[categoryMap.keys.toList().indexOf(entry.key) % Colors.primaries.length];
          return PieChartSectionData(
            value: entry.value,
            title: '${entry.key}\n\$${entry.value.toStringAsFixed(0)}',
            color: color,
            radius: 100,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Expenses by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: categoryMap.keys.map((category) {
                final color = Colors.primaries[categoryMap.keys.toList().indexOf(category) % Colors.primaries.length];
                return Chip(
                  backgroundColor: color.withOpacity(0.2),
                  label: Text(category),
                  avatar: CircleAvatar(
                    backgroundColor: color,
                    radius: 8,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}