import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../../transactions/models/transaction.dart';

class MonthlyComparisonChart extends StatelessWidget {
  const MonthlyComparisonChart({super.key});

  List<BarChartGroupData> _createBarGroups(List<Transaction> transactions) {
    final Map<String, double> expensesByMonth = {};
    final Map<String, double> incomeByMonth = {};
    final currentDate = DateTime.now();
    final sixMonthsAgo = DateTime(currentDate.year, currentDate.month - 5, 1);

    // Initialize maps with zero values for last 6 months
    for (var i = 0; i < 6; i++) {
      final date = DateTime(currentDate.year, currentDate.month - i, 1);
      final monthKey = DateFormat('yyyy-MM').format(date);
      expensesByMonth[monthKey] = 0;
      incomeByMonth[monthKey] = 0;
    }

    // Calculate totals for each month
    for (var transaction in transactions) {
      if (transaction.date.isBefore(sixMonthsAgo)) continue;
      final monthKey = DateFormat('yyyy-MM').format(transaction.date);
      if (transaction.type == TransactionType.expense) {
        expensesByMonth[monthKey] =
            (expensesByMonth[monthKey] ?? 0) + transaction.amount;
      } else {
        incomeByMonth[monthKey] =
            (incomeByMonth[monthKey] ?? 0) + transaction.amount;
      }
    }

    // Create bar groups
    final List<BarChartGroupData> barGroups = [];
    var index = 0;
    expensesByMonth.forEach((month, expenseAmount) {
      final incomeAmount = incomeByMonth[month] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: index++,
          barRods: [
            BarChartRodData(
              toY: expenseAmount,
              color: Colors.red,
              width: 12,
            ),
            BarChartRodData(
              toY: incomeAmount,
              color: Colors.green,
              width: 12,
            ),
          ],
        ),
      );
    });

    return barGroups.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final barGroups = _createBarGroups(provider.transactions);

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Monthly Comparison',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: barGroups.fold(
                            0.0,
                            (max, group) => group.barRods.fold(
                                max, (m, rod) => rod.toY > m ? rod.toY : m)) *
                        1.2,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            return Text('\$${value.toInt()}');
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final date = DateTime.now().subtract(
                              Duration(days: (5 - value.toInt()) * 30),
                            );
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(DateFormat('MMM').format(date)),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: barGroups,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(color: Colors.red, label: 'Expenses'),
                  const SizedBox(width: 24),
                  _LegendItem(color: Colors.green, label: 'Income'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
