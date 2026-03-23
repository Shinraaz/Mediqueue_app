import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _scale, _fade;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _scale = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _c, curve: Curves.elasticOut));
    _fade  = CurvedAnimation(parent: _c, curve: Curves.easeIn);
    _c.forward();
    Future.delayed(const Duration(milliseconds: 2200), _go);
  }
  Future<void> _go() async {
    if (!mounted) return;
    await context.read<AuthProvider>().init();
    if (!mounted) return;
    final dest = context.read<AuthProvider>().isAuth ? const MainShell() : const LoginScreen();
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, a, __) => dest,
      transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
      transitionDuration: const Duration(milliseconds: 500)));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.bgPage,
    body: Container(
      decoration: BoxDecoration(gradient: AppTheme.bgGradient),
      child: Center(child: FadeTransition(opacity: _fade,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ScaleTransition(scale: _scale,
            child: Container(width: 110, height: 110,
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.35), blurRadius: 40, spreadRadius: 8)]),
              child: const Center(child: Icon(Icons.calendar_month_rounded, color: Colors.white, size: 52)))),
          const SizedBox(height: 26),
          ShaderMask(shaderCallback: (b) => AppTheme.primaryGradient.createShader(b),
            child: const Text('MediQueue', style: TextStyle(color: Colors.white,
              fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: 0.5))),
          const SizedBox(height: 8),
          const Text('Medical Appointment Management',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14, letterSpacing: 0.4)),
          const SizedBox(height: 56),
          SizedBox(width: 32, height: 32, child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation(AppTheme.primary.withOpacity(0.6)))),
        ])))));
}
