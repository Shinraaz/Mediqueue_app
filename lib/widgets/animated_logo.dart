import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedLogo extends StatefulWidget {
  final double size;
  const AnimatedLogo({super.key, this.size = 88});
  @override State<AnimatedLogo> createState() => _AnimatedLogoState();
}
class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _pulse;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.93, end: 1.07).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => ScaleTransition(
    scale: _pulse,
    child: Container(width: widget.size, height: widget.size,
      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.35), blurRadius: 28, spreadRadius: 4)]),
      child: Center(child: Icon(Icons.calendar_month_rounded, color: Colors.white, size: widget.size * 0.48))));
}
