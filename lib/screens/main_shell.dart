import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'appointments_screen.dart';
import 'doctors_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> {
  int _idx = 0;
  static const _screens = [HomeScreen(), AppointmentsScreen(), DoctorsScreen(), ProfileScreen()];

  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.bgPage,
    body: _screens[_idx],
    bottomNavigationBar: Container(
      decoration: BoxDecoration(color: AppTheme.cardWhite,
        border: Border(top: BorderSide(color: AppTheme.borderBlue.withOpacity(0.7))),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.07), blurRadius: 16, offset: const Offset(0, -4))]),
      child: NavigationBar(
        backgroundColor: Colors.transparent, indicatorColor: AppTheme.primarySoft,
        selectedIndex: _idx, onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primary), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today_rounded, color: AppTheme.primary), label: 'Appointments'),
          NavigationDestination(icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services_rounded, color: AppTheme.primary), label: 'Doctors'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppTheme.primary), label: 'Profile'),
        ])));
}
