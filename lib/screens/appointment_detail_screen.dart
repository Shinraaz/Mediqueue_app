import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';
import '../widgets/gradient_button.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String appointmentId;
  const AppointmentDetailScreen({super.key, required this.appointmentId});
  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  Appointment? get _appt => appointmentService.findById(widget.appointmentId);

  @override
  Widget build(BuildContext context) {
    final appt = _appt;
    if (appt == null)
      return Scaffold(
          backgroundColor: AppTheme.bgPage,
          body: const Center(
              child: Text('Appointment not found',
                  style: TextStyle(color: AppTheme.textMuted))));

    final doc = appt.doctor;
    final canAct = appt.status == AppointmentStatus.upcoming;

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: SafeArea(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppTheme.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderBlue)),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 16, color: AppTheme.textDark)),
              ),
              Expanded(
                  child: Text('Appointment Details',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge)),
              const SizedBox(width: 48),
            ])),
        Expanded(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              StatusBadge(appt.status),
              Text('ID: ${appt.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                      fontFamily: 'monospace')),
            ]),
            const SizedBox(height: 20),

            // Doctor banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.primary.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Row(children: [
                Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                        child: Text(doc.emoji,
                            style: const TextStyle(fontSize: 30)))),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(doc.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17)),
                      Text(doc.specialty,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 5),
                      Row(children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: Color(0xFFFFD700)),
                        const SizedBox(width: 3),
                        Text('${doc.rating}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ]),
                    ])),
              ]),
            ),
            const SizedBox(height: 20),

            _tile(Icons.calendar_today_rounded, 'Date',
                DateFormat('EEEE, MMMM d, y').format(appt.date)),
            _tile(Icons.access_time_rounded, 'Time', appt.time),
            _tile(Icons.local_hospital_outlined, 'Hospital', doc.hospital),
            _tile(Icons.person_outline_rounded, 'Patient', appt.patientName),
            if (appt.notes != null && appt.notes!.isNotEmpty)
              _tile(Icons.notes_rounded, 'Notes', appt.notes!),

            const SizedBox(height: 24),

            if (canAct) ...[
              GradientButton(
                  label: 'Reschedule Appointment',
                  icon: Icons.update_rounded,
                  onPressed: () => _rescheduleSheet(context, appt)),
              const SizedBox(height: 12),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _cancelDialog(context, appt),
                    icon: Icon(Icons.cancel_outlined, color: AppTheme.error),
                    label: Text('Cancel Appointment',
                        style: TextStyle(
                            color: AppTheme.error,
                            fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side:
                            BorderSide(color: AppTheme.error.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  )),
            ],

            if (appt.status == AppointmentStatus.completed)
              _statusBanner(
                  AppTheme.success,
                  Icons.check_circle_outline_rounded,
                  'This appointment has been completed.'),
            if (appt.status == AppointmentStatus.cancelled)
              _statusBanner(AppTheme.cancelled, Icons.cancel_outlined,
                  'This appointment was cancelled.'),
          ]),
        )),
      ])),
    );
  }

  Widget _tile(IconData icon, String label, String value) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.cardWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderBlue)),
        child: Row(children: [
          Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppTheme.primary, size: 18)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style:
                    const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
          ]),
        ]),
      );

  Widget _statusBanner(Color color, IconData icon, String msg) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25))),
        child: Row(children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(msg,
              style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        ]),
      );

  void _cancelDialog(BuildContext context, Appointment appt) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Cancel Appointment?'),
              content: Text(
                  'Cancel with ${appt.doctor.name} on ${DateFormat('MMM d').format(appt.date)}?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Keep It')),
                TextButton(
                    onPressed: () {
                      appointmentService.cancel(appt.id);
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: Text('Cancel It',
                        style: TextStyle(color: AppTheme.error))),
              ],
            ));
  }

  void _rescheduleSheet(BuildContext context, Appointment appt) {
    DateTime? newDate;
    String? newTime;
    final doc = appt.doctor;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
              final days = <DateTime>[];
              for (int i = 1; i <= 21; i++) {
                final d = DateTime.now().add(Duration(days: i));
                if (doc.availableDays
                    .contains(DateFormat('EEE').format(d).substring(0, 3)))
                  days.add(d);
                if (days.length >= 8) break;
              }
              return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.75,
                  builder: (_, ctrl) => SingleChildScrollView(
                      controller: ctrl,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Container(
                                    width: 40,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: AppTheme.borderBlue,
                                        borderRadius:
                                            BorderRadius.circular(2)))),
                            const SizedBox(height: 20),
                            Text('Reschedule Appointment',
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 20),
                            Text('New Date',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 12),
                            SizedBox(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: days.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10),
                                  itemBuilder: (_, i) {
                                    final d = days[i];
                                    final sel = newDate != null &&
                                        d.day == newDate!.day &&
                                        d.month == newDate!.month;
                                    return GestureDetector(
                                      onTap: () => setS(() {
                                        newDate = d;
                                        newTime = null;
                                      }),
                                      child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 150),
                                          width: 60,
                                          decoration: BoxDecoration(
                                              gradient: sel
                                                  ? AppTheme.primaryGradient
                                                  : null,
                                              color: sel
                                                  ? null
                                                  : AppTheme.bgSection,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                  color: sel
                                                      ? Colors.transparent
                                                      : AppTheme.borderBlue)),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    DateFormat('EEE').format(d),
                                                    style: TextStyle(
                                                        color: sel
                                                            ? Colors.white70
                                                            : AppTheme
                                                                .textMuted,
                                                        fontSize: 11)),
                                                const SizedBox(height: 4),
                                                Text(DateFormat('d').format(d),
                                                    style: TextStyle(
                                                        color: sel
                                                            ? Colors.white
                                                            : AppTheme.textDark,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20)),
                                                Text(
                                                    DateFormat('MMM').format(d),
                                                    style: TextStyle(
                                                        color: sel
                                                            ? Colors.white70
                                                            : AppTheme
                                                                .textMuted,
                                                        fontSize: 11)),
                                              ])),
                                    );
                                  },
                                )),
                            const SizedBox(height: 20),
                            Text('New Time',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 12),
                            Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: doc.availableTimes.map((t) {
                                  final sel = newTime == t;
                                  return GestureDetector(
                                    onTap: newDate == null
                                        ? null
                                        : () => setS(() => newTime = t),
                                    child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                            gradient: sel
                                                ? AppTheme.primaryGradient
                                                : null,
                                            color:
                                                sel ? null : AppTheme.bgSection,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: sel
                                                    ? Colors.transparent
                                                    : AppTheme.borderBlue)),
                                        child: Text(t,
                                            style: TextStyle(
                                                color: sel
                                                    ? Colors.white
                                                    : (newDate == null
                                                        ? AppTheme.textHint
                                                        : AppTheme.textBody),
                                                fontSize: 13))),
                                  );
                                }).toList()),
                            const SizedBox(height: 28),
                            GradientButton(
                                label: 'Confirm Reschedule',
                                icon: Icons.update_rounded,
                                onPressed: (newDate == null || newTime == null)
                                    ? null
                                    : () {
                                        appointmentService.reschedule(
                                            appt.id, newDate!, newTime!);
                                        Navigator.pop(ctx);
                                        setState(() {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Rescheduled to ${DateFormat('MMM d').format(newDate!)} at $newTime')));
                                      }),
                            const SizedBox(height: 16),
                          ])));
            }));
  }
}
