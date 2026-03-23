import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/appointment_model.dart';
import '../services/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import 'book_appointment_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;
  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user!;
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: SafeArea(child: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), child: Row(children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderBlue)),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textDark)),
          ),
          const Spacer(),
          Text('Doctor Profile', style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          const SizedBox(width: 48),
        ])),

        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Hero card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppTheme.heroGradient, borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Row(children: [
                Container(width: 72, height: 72,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Center(child: Text(doctor.emoji, style: const TextStyle(fontSize: 36)))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(doctor.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                  Text(doctor.specialty, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                    const SizedBox(width: 4),
                    Text('${doctor.rating}  (${doctor.reviewCount} reviews)', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ])),
              ]),
            ),
            const SizedBox(height: 22),

            _infoRow(Icons.local_hospital_outlined, 'Hospital', doctor.hospital),
            const SizedBox(height: 18),
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(doctor.about, style: const TextStyle(color: AppTheme.textBody, height: 1.6, fontSize: 14)),
            const SizedBox(height: 22),

            Text('Available Days', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(spacing: 8, children: doctor.availableDays.map((d) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderBlue)),
              child: Text(d, style: const TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.w500)),
            )).toList()),
            const SizedBox(height: 22),

            Text('Available Times', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: doctor.availableTimes.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderBlue)),
              child: Text(t, style: const TextStyle(color: AppTheme.textBody, fontSize: 12)),
            )).toList()),
            const SizedBox(height: 32),

            GradientButton(label: 'Book Appointment', icon: Icons.calendar_month_rounded,
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (_) => BookAppointmentScreen(patientName: user.name, preselectedDoctor: doctor)))),
            const SizedBox(height: 16),
          ]),
        )),
      ])),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => Row(children: [
    Container(padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: AppTheme.primary, size: 18)),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
      Text(value, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w500, fontSize: 14)),
    ]),
  ]);
}
