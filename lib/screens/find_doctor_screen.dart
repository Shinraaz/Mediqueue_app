import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';
import 'book_appointment_screen.dart';

class FindDoctorScreen extends StatefulWidget {
  final String patientName;
  const FindDoctorScreen({super.key, required this.patientName});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  String _search = '';
  String? _selectedSpecialty;

  List<String> get specialties {
    final all = seedDoctors.map((d) => d.specialty).toSet().toList();
    all.sort();
    return all;
  }

  List<Doctor> get filteredDoctors {
    return seedDoctors.where((d) {
      final matchSearch = _search.isEmpty ||
          d.name.toLowerCase().contains(_search.toLowerCase()) ||
          d.specialty.toLowerCase().contains(_search.toLowerCase());
      final matchSpec =
          _selectedSpecialty == null || d.specialty == _selectedSpecialty;
      return matchSearch && matchSpec;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Find a Doctor',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: Column(children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Search by name or specialty…',
              hintStyle:
                  const TextStyle(color: AppTheme.textMuted, fontSize: 14),
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppTheme.textMuted),
              filled: true,
              fillColor: AppTheme.cardWhite,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.borderBlue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.borderBlue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppTheme.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Specialty filter chips
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _chip('All', _selectedSpecialty == null,
                  () => setState(() => _selectedSpecialty = null)),
              ...specialties.map((s) => _chip(s, _selectedSpecialty == s,
                  () => setState(() => _selectedSpecialty = s))),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Doctor list
        Expanded(
          child: filteredDoctors.isEmpty
              ? const Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('🔍', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 12),
                  Text('No doctors found',
                      style: TextStyle(color: AppTheme.textMuted)),
                ]))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  itemCount: filteredDoctors.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) =>
                      _doctorCard(context, filteredDoctors[i]),
                ),
        ),
      ]),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: active ? AppTheme.primary : AppTheme.cardWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: active ? AppTheme.primary : AppTheme.borderBlue),
            ),
            child: Text(label,
                style: TextStyle(
                  color: active ? Colors.white : AppTheme.textMuted,
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                )),
          ),
        ),
      );

  Widget _doctorCard(BuildContext context, Doctor doctor) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.borderBlue),
          boxShadow: [
            BoxShadow(
                color: AppTheme.primary.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(16)),
            child: Center(
                child:
                    Text(doctor.emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(doctor.name,
                    style: const TextStyle(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                const SizedBox(height: 2),
                Text(doctor.specialty,
                    style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  const SizedBox(width: 3),
                  const Text('4.9',
                      style:
                          TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  const SizedBox(width: 10),
                  const Icon(Icons.schedule_rounded,
                      size: 13, color: AppTheme.textMuted),
                  const SizedBox(width: 3),
                  const Text('Available today',
                      style:
                          TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ]),
              ])),

          // Book button
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BookAppointmentScreen(
                        patientName: widget.patientName))),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.primary.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ],
              ),
              child: const Text('Book',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
          ),
        ]),
      );
}
