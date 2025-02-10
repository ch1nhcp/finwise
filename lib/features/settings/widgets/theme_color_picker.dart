import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeColorPicker extends StatelessWidget {
  const ThemeColorPicker({super.key});

  static const List<Color> _colorOptions = [
    Color(0xFF1E88E5), // Blue
    Color(0xFF43A047), // Green
    Color(0xFFE53935), // Red
    Color(0xFF8E24AA), // Purple
    Color(0xFFFFB300), // Amber
    Color(0xFF00897B), // Teal
    Color(0xFFF4511E), // Deep Orange
    Color(0xFF6D4C41), // Brown
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _colorOptions.map((color) {
            final isSelected = provider.primaryColor == color;
            return InkWell(
              onTap: () => provider.updatePrimaryColor(color),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: isSelected ? 2 : 0,
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}