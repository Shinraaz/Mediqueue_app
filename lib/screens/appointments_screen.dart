import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../services/appointment_service.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import 'book_appointment_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});
  @override State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}
class _AppointmentsScreenState extends State<AppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final upcoming = appointmentService.getUpcoming(user.name);
    final past     = appointmentService.getPast(user.name);
    return SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Appointments', style: Theme.of(context).textTheme.displayMedium),
        GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => BookAppointmentScreen(patientName: user.name))).then((_) => setState(() {})),
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 10, offset: const Offset(0,4))]),
            child: const Row(children: [Icon(Icons.add, color: Colors.white, size: 18), SizedBox(width: 4),
              Text('Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14))]))),
      ]),
      const SizedBox(height: 20),
      Container(decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(16)),
        child: TabBar(controller: _tab,
          indicator: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0,2))]),
          labelColor: Colors.white, unselectedLabelColor: AppTheme.textMuted, dividerColor: Colors.transparent,
          tabs: [Tab(text: 'Upcoming (${upcoming.length})'), Tab(text: 'Past (${past.length})')])),
      const SizedBox(height: 16),
      Expanded(child: TabBarView(controller: _tab, children: [
        _list(context, upcoming, user.name),
        _list(context, past, user.name, canCancel: false),
      ])),
    ])));
  }

  Widget _list(BuildContext ctx, List<Appointment> appts, String pName, {bool canCancel = true}) {
    if (appts.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('📋', style: TextStyle(fontSize: 48)), const SizedBox(height: 12),
      const Text('No appointments here', style: TextStyle(color: AppTheme.textMuted))]));
    return ListView.separated(itemCount: appts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _card(ctx, appts[i], canCancel: canCancel));
  }

  Widget _card(BuildContext ctx, Appointment a, {bool canCancel = true}) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.borderBlue),
      boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0,4))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 50, height: 50,
          decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(14)),
          child: Center(child: Text(a.doctor.emoji, style: const TextStyle(fontSize: 22)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(a.doctor.name, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600, fontSize: 15)),
          Text(a.doctor.specialty, style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w500)),
        ])),
        StatusBadge(a.status),
      ]),
      const SizedBox(height: 12),
      Container(padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppTheme.bgSection, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          _info(Icons.calendar_today_outlined, DateFormat('EEE, MMM d yyyy').format(a.date)),
          const SizedBox(width: 12),
          _info(Icons.access_time_outlined, a.time),
          const SizedBox(width: 12),
          _info(Icons.location_on_outlined, a.doctor.hospital, flex: 2),
        ])),
      if (canCancel && a.status == AppointmentStatus.upcoming) ...[
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: OutlinedButton(onPressed: () => _confirmCancel(ctx, a),
            style: OutlinedButton.styleFrom(side: BorderSide(color: AppTheme.error.withOpacity(0.45)),
              foregroundColor: AppTheme.error, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 10)),
            child: const Text('Cancel', style: TextStyle(fontSize: 13)))),
          const SizedBox(width: 10),
          Expanded(child: OutlinedButton(onPressed: () {},
            style: OutlinedButton.styleFrom(side: BorderSide(color: AppTheme.primary.withOpacity(0.45)),
              foregroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 10)),
            child: const Text('View Details', style: TextStyle(fontSize: 13)))),
        ]),
      ],
    ]));

  Widget _info(IconData icon, String text, {int flex = 1}) => Expanded(flex: flex,
    child: Row(children: [Icon(icon, size: 11, color: AppTheme.textMuted), const SizedBox(width: 4),
      Flexible(child: Text(text, style: const TextStyle(color: AppTheme.textBody, fontSize: 11),
        overflow: TextOverflow.ellipsis))]));

  void _confirmCancel(BuildContext ctx, Appointment a) => showDialog(context: ctx,
    builder: (_) => AlertDialog(
      title: const Text('Cancel Appointment?'),
      content: Text('Cancel with ${a.doctor.name} on ${DateFormat('MMM d').format(a.date)} at ${a.time}?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx),
          child: const Text('Keep It', style: TextStyle(color: AppTheme.primary))),
        TextButton(onPressed: () { appointmentService.cancel(a.id); Navigator.pop(ctx); setState(() {}); },
          child: const Text('Yes, Cancel', style: TextStyle(color: AppTheme.error))),
      ]));
}
