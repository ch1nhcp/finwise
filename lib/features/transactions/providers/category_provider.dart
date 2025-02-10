import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Food & Drinks',
      icon: Icons.restaurant,
      color: Colors.orange,
      isExpense: true,
    ),
    Category(
      id: '2',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.blue,
      isExpense: true,
    ),
    Category(
      id: '3',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Colors.green,
      isExpense: true,
    ),
    Category(
      id: '4',
      name: 'Salary',
      icon: Icons.work,
      color: Colors.green,
      isExpense: false,
    ),
    Category(
      id: '5',
      name: 'Investment',
      icon: Icons.trending_up,
      color: Colors.purple,
      isExpense: false,
    ),
  ];

  List<Category> get categories => List.unmodifiable(_categories);
  
  List<Category> getCategoriesByType(bool isExpense) {
    return _categories.where((cat) => cat.isExpense == isExpense).toList();
  }
}