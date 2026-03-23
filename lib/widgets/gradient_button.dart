import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;

  const GradientButton({super.key, required this.label,
    this.onPressed, this.icon, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final active = onPressed != null && !isLoading;
    return GestureDetector(
      onTap: active ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: active
              ? [AppTheme.primaryDark, AppTheme.primary]
              : [AppTheme.primaryDark.withOpacity(0.4), AppTheme.primary.withOpacity(0.4)],
            begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: active ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 16, offset: const Offset(0, 6))] : null),
        child: Center(child: isLoading
          ? const SizedBox(width: 22, height: 22,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
          : Row(mainAxisSize: MainAxisSize.min, children: [
              if (icon != null) ...[Icon(icon, color: Colors.white, size: 20), const SizedBox(width: 8)],
              Text(label, style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600, fontSize: 16)),
            ])),
      ),
    );
  }
}
