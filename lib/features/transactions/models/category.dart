import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isExpense;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isExpense,
  });
}

class Categories {
  static const List<Category> expenses = [
    Category(
      id: 'food_drinks',
      name: 'Food & Drinks',
      icon: Icons.restaurant,
      color: Colors.orange,
      isExpense: true,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.blue,
      isExpense: true,
    ),
    Category(
      id: 'transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Colors.green,
      isExpense: true,
    ),
    Category(
      id: 'bills',
      name: 'Bills',
      icon: Icons.receipt_long,
      color: Colors.red,
      isExpense: true,
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Colors.purple,
      isExpense: true,
    ),
    Category(
      id: 'health',
      name: 'Health',
      icon: Icons.medical_services,
      color: Colors.pink,
      isExpense: true,
    ),
  ];

  static const List<Category> income = [
    Category(
      id: 'salary',
      name: 'Salary',
      icon: Icons.work,
      color: Colors.green,
      isExpense: false,
    ),
    Category(
      id: 'business',
      name: 'Business',
      icon: Icons.business,
      color: Colors.blue,
      isExpense: false,
    ),
    Category(
      id: 'investment',
      name: 'Investment',
      icon: Icons.trending_up,
      color: Colors.orange,
      isExpense: false,
    ),
    Category(
      id: 'gift',
      name: 'Gift',
      icon: Icons.card_giftcard,
      color: Colors.purple,
      isExpense: false,
    ),
  ];
}
