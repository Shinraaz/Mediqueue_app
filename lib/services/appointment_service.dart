import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  static const _uuid = Uuid();
  final List<Appointment> _list = [];

  List<Appointment> getUpcoming(String p) =>
    _list.where((a) => a.patientName == p && a.status == AppointmentStatus.upcoming)
      .toList()..sort((a, b) => a.date.compareTo(b.date));

  List<Appointment> getPast(String p) =>
    _list.where((a) => a.patientName == p && a.status != AppointmentStatus.upcoming)
      .toList()..sort((a, b) => b.date.compareTo(a.date));

  Appointment? findById(String id) {
    try { return _list.firstWhere((a) => a.id == id); } catch (_) { return null; }
  }

  Appointment book({required Doctor doctor, required DateTime date,
    required String time, required String patientName, String? notes}) {
    final a = Appointment(id: _uuid.v4(), doctor: doctor, date: date, time: time,
      status: AppointmentStatus.upcoming, notes: notes, patientName: patientName);
    _list.add(a); return a;
  }

  void cancel(String id) {
    final i = _list.indexWhere((a) => a.id == id);
    if (i >= 0) _list[i] = _list[i].copyWith(status: AppointmentStatus.cancelled);
  }

  void reschedule(String id, DateTime d, String t) {
    final i = _list.indexWhere((a) => a.id == id);
    if (i >= 0) _list[i] = _list[i].copyWith(status: AppointmentStatus.upcoming, date: d, time: t);
  }

  void seedDemo(String patientName) {
    if (_list.any((a) => a.patientName == patientName)) return;
    _list.addAll([
      Appointment(id: _uuid.v4(), doctor: seedDoctors[0],
        date: DateTime.now().add(const Duration(days: 3)),
        time: '10:00 AM', status: AppointmentStatus.upcoming,
        notes: 'Annual check-up', patientName: patientName),
      Appointment(id: _uuid.v4(), doctor: seedDoctors[2],
        date: DateTime.now().add(const Duration(days: 8)),
        time: '09:00 AM', status: AppointmentStatus.upcoming, patientName: patientName),
      Appointment(id: _uuid.v4(), doctor: seedDoctors[1],
        date: DateTime.now().subtract(const Duration(days: 10)),
        time: '02:00 PM', status: AppointmentStatus.completed,
        notes: 'Follow-up ECG', patientName: patientName),
    ]);
  }
}

final appointmentService = AppointmentService();
