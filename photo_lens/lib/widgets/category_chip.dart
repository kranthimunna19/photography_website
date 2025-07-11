import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? colorScheme.primary 
            : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
              ? colorScheme.primary 
              : colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          category,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected 
              ? colorScheme.onPrimary 
              : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
} 