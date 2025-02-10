import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import 'category_selector.dart';

class QuickAddTransaction extends StatefulWidget {
  final Transaction? transaction;

  const QuickAddTransaction({
    super.key,
    this.transaction,
  });

  @override
  State<QuickAddTransaction> createState() => _QuickAddTransactionState();
}

class _QuickAddTransactionState extends State<QuickAddTransaction> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isExpense = true;
  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now(); // Add selected date

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note ?? '';
      _isExpense = widget.transaction!.type == TransactionType.expense;
      _selectedDate = widget.transaction!.date; // Set date when editing
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    if (_amountController.text.isEmpty) return;
    if (_selectedCategory == null) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    final transaction = Transaction(
      id: widget.transaction?.id ?? DateTime.now().toString(),
      amount: amount,
      category: _selectedCategory!.name,
      note: _noteController.text,
      date: _selectedDate, // Use selected date
      type: _isExpense ? TransactionType.expense : TransactionType.income,
    );

    final provider = context.read<TransactionProvider>();
    if (widget.transaction != null) {
      provider.updateTransaction(transaction);
    } else {
      provider.addTransaction(transaction);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Expense'),
                        icon: Icon(Icons.remove),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Income'),
                        icon: Icon(Icons.add),
                      ),
                    ],
                    selected: {_isExpense},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        _isExpense = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            CategorySelector(
              isExpense: _isExpense,
              selectedCategory: _selectedCategory,
              onSelect: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Add date selector
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                // Update the FilledButton onPressed callback:
                FilledButton(
                  onPressed: _saveTransaction,
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
