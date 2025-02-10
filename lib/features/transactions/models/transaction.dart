import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final double amount;
  final String category;
  final String? note;
  final DateTime date;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    this.note,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
      'type': type.toString(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      note: json['note'],
      date: DateTime.parse(json['date']),
      type: json['type'].toString().contains('expense')
          ? TransactionType.expense
          : TransactionType.income,
    );
  }
}
