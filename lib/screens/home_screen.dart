import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../services/appointment_service.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import 'book_appointment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade  = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, -0.15), end: Offset.zero)
      .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _ac.forward();
  }
  @override void dispose() { _ac.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final upcoming = appointmentService.getUpcoming(user.name);
    return SafeArea(child: RefreshIndicator(color: AppTheme.primary,
      onRefresh: () async => setState(() {}),
      child: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: FadeTransition(opacity: _fade,
          child: SlideTransition(position: _slide, child: _hero(context, user.firstName)))),
        SliverPadding(padding: const EdgeInsets.fromLTRB(20,20,20,0),
          sliver: SliverToBoxAdapter(child: _stats(upcoming))),
        SliverPadding(padding: const EdgeInsets.fromLTRB(20,20,20,0),
          sliver: SliverToBoxAdapter(child: _quickActions(context, user.name))),
        SliverPadding(padding: const EdgeInsets.fromLTRB(20,24,20,0),
          sliver: SliverToBoxAdapter(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Upcoming Appointments', style: Theme.of(context).textTheme.titleMedium),
            Text('${upcoming.length} total', style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          ]))),
        upcoming.isEmpty
          ? SliverPadding(padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(child: _emptyCard(context, user.name)))
          : SliverPadding(padding: const EdgeInsets.fromLTRB(20,14,20,28),
              sliver: SliverList(delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(padding: const EdgeInsets.only(bottom: 12),
                  child: _apptCard(context, upcoming[i])), childCount: upcoming.length))),
      ])));
  }

  Widget _hero(BuildContext context, String firstName) {
    final h = DateTime.now().hour;
    final g = h < 12 ? 'Good Morning' : h < 17 ? 'Good Afternoon' : 'Good Evening';
    return Container(margin: const EdgeInsets.fromLTRB(20,16,20,0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.28), blurRadius: 24, offset: const Offset(0,8))]),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$g,', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Text('$firstName! 👋', style: const TextStyle(color: Colors.white, fontSize: 28,
            fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 6),
          const Text('Manage your medical appointments easily.',
            style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.4)),
        ])),
        Container(width: 60, height: 60,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.calendar_month_rounded, color: Colors.white, size: 30))),
      ]));
  }

  Widget _stats(List<Appointment> upcoming) {
    final today = upcoming.where((a) => a.date.day == DateTime.now().day &&
      a.date.month == DateTime.now().month && a.date.year == DateTime.now().year).length;
    return Row(children: [
      _stat('Upcoming', '${upcoming.length}', Icons.schedule_rounded, AppTheme.primary),
      const SizedBox(width: 12),
      _stat('Today', '$today', Icons.today_rounded, AppTheme.primaryDark),
      const SizedBox(width: 12),
      _stat('Doctors', '${seedDoctors.length}', Icons.medical_services_outlined, AppTheme.primaryLight),
    ]);
  }

  Widget _stat(String label, String value, IconData icon, Color color) => Expanded(
    child: Container(padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderBlue),
        boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0,4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
          child: Icon(icon, color: color, size: 18)),
        const SizedBox(height: 10),
        Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w700)),
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
      ])));

  Widget _quickActions(BuildContext context, String patientName) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 12),
      Row(children: [
        _action('📅', 'Book\nAppointment', AppTheme.primary, () =>
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => BookAppointmentScreen(patientName: patientName)))
          .then((_) => setState(() {}))),
        const SizedBox(width: 12),
        _action('🩺', 'Find\nDoctor', AppTheme.primaryDark, () {}),
        const SizedBox(width: 12),
        _action('📋', 'My\nHistory', AppTheme.primaryLight, () {}),
      ]),
    ]);

  Widget _action(String emoji, String label, Color color, VoidCallback onTap) => Expanded(
    child: GestureDetector(onTap: onTap,
      child: Container(padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withOpacity(0.2))),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600, height: 1.3)),
        ]))));

  Widget _apptCard(BuildContext context, Appointment a) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppTheme.borderBlue),
      boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0,4))]),
    child: Row(children: [
      Container(width: 52, height: 52,
        decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(14)),
        child: Center(child: Text(a.doctor.emoji, style: const TextStyle(fontSize: 24)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(a.doctor.name, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600, fontSize: 14)),
        Text(a.doctor.specialty, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
        const SizedBox(height: 5),
        Row(children: [
          const Icon(Icons.calendar_today_outlined, size: 11, color: AppTheme.textMuted), const SizedBox(width: 4),
          Text(DateFormat('MMM d, y').format(a.date), style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          const SizedBox(width: 10),
          const Icon(Icons.access_time_outlined, size: 11, color: AppTheme.textMuted), const SizedBox(width: 4),
          Text(a.time, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
        ]),
      ])),
      StatusBadge(a.status),
    ]));

  Widget _emptyCard(BuildContext context, String patientName) => Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.borderBlue)),
    child: Column(children: [
      const Text('📅', style: TextStyle(fontSize: 48)), const SizedBox(height: 12),
      Text('No upcoming appointments', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 6),
      const Text('Book your first appointment to get started.',
        textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
      const SizedBox(height: 20),
      GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => BookAppointmentScreen(patientName: patientName))).then((_) => setState(() {})),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 12, offset: const Offset(0,4))]),
          child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))),
    ]));
}
