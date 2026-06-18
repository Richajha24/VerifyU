import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTheme.bodyStyle(fontSize: 14, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AppTheme.bodyStyle(fontSize: 14, color: AppColors.tan),
            filled: true,
            fillColor: AppColors.warmWhite,
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(color: AppColors.sand, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(color: AppColors.sand, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.0),
              borderSide: const BorderSide(color: AppColors.forest, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
