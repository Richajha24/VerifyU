import 'package:flutter/material.dart';
import '../utils/theme.dart';

enum AppButtonType {
  filledForest,
  filledRose,
  outlineInk,
}

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final AppButtonType type;
  final Widget? icon;
  final bool isLoading;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.filledForest,
    this.icon,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textCol;
    BorderSide borderSide = BorderSide.none;

    switch (widget.type) {
      case AppButtonType.filledForest:
        bg = AppColors.forest;
        textCol = Colors.white;
        break;
      case AppButtonType.filledRose:
        bg = AppColors.rose;
        textCol = Colors.white;
        break;
      case AppButtonType.outlineInk:
        bg = Colors.transparent;
        textCol = AppColors.ink;
        borderSide = const BorderSide(color: AppColors.sand2, width: 1.5);
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: widget.isLoading ? null : widget.onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: textCol,
              side: borderSide,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
              elevation: 0,
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.type == AppButtonType.outlineInk ? AppColors.ink : Colors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        widget.icon!,
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: AppTheme.buttonTextStyle(color: textCol),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
