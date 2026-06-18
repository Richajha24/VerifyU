import 'package:flutter/material.dart';
import '../utils/theme.dart';

class NavigatorChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const NavigatorChip({
    Key? key,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.forest : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.forest : AppColors.sand2,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: AppTheme.bodyStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
