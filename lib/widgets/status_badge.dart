import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final AppointmentStatus status;
  const StatusBadge(this.status, {super.key});
  Color get _c { switch (status) {
    case AppointmentStatus.upcoming:  return AppTheme.primary;
    case AppointmentStatus.completed: return AppTheme.success;
    case AppointmentStatus.cancelled: return AppTheme.cancelled;
  }}
  String get _l { switch (status) {
    case AppointmentStatus.upcoming:  return 'Upcoming';
    case AppointmentStatus.completed: return 'Completed';
    case AppointmentStatus.cancelled: return 'Cancelled';
  }}
  IconData get _i { switch (status) {
    case AppointmentStatus.upcoming:  return Icons.schedule_rounded;
    case AppointmentStatus.completed: return Icons.check_circle_outline_rounded;
    case AppointmentStatus.cancelled: return Icons.cancel_outlined;
  }}
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: _c.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: _c.withOpacity(0.35))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(_i, color: _c, size: 12), const SizedBox(width: 5),
      Text(_l, style: TextStyle(color: _c, fontSize: 11, fontWeight: FontWeight.w600)),
    ]));
}
