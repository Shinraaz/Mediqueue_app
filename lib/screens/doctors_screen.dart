import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../theme/app_theme.dart';
import 'book_appointment_screen.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});
  @override State<DoctorsScreen> createState() => _DoctorsScreenState();
}
class _DoctorsScreenState extends State<DoctorsScreen> {
  String _search = '';
  String _filter = 'All';
  List<String> get _specs => ['All', ...{for (final d in seedDoctors) d.specialty}];
  List<Doctor> get _filtered => seedDoctors.where((d) {
    final ms = _search.isEmpty || d.name.toLowerCase().contains(_search.toLowerCase()) ||
               d.specialty.toLowerCase().contains(_search.toLowerCase());
    return ms && (_filter == 'All' || d.specialty == _filter);
  }).toList();

  @override Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Find a Doctor', style: Theme.of(context).textTheme.displayMedium),
      const SizedBox(height: 4),
      const Text('Browse our specialists', style: TextStyle(color: AppTheme.textMuted)),
      const SizedBox(height: 20),
      TextFormField(onChanged: (v) => setState(() => _search = v),
        decoration: const InputDecoration(hintText: 'Search doctor or specialty...',
          prefixIcon: Icon(Icons.search_rounded))),
      const SizedBox(height: 14),
      SizedBox(height: 36, child: ListView.separated(scrollDirection: Axis.horizontal,
        itemCount: _specs.length, separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final s = _specs[i]; final active = _filter == s;
          return GestureDetector(onTap: () => setState(() => _filter = s),
            child: AnimatedContainer(duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                gradient: active ? AppTheme.primaryGradient : null,
                color: active ? null : AppTheme.cardWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? Colors.transparent : AppTheme.borderBlue),
                boxShadow: active ? [BoxShadow(color: AppTheme.primary.withOpacity(0.2), blurRadius: 8)] : null),
              child: Center(child: Text(s, style: TextStyle(
                color: active ? Colors.white : AppTheme.textMuted,
                fontSize: 12, fontWeight: FontWeight.w500)))));
        })),
      const SizedBox(height: 16),
      Expanded(child: _filtered.isEmpty
        ? const Center(child: Text('No doctors found', style: TextStyle(color: AppTheme.textMuted)))
        : ListView.separated(itemCount: _filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _card(context, _filtered[i]))),
    ])));

  Widget _card(BuildContext context, Doctor doc) {
    final user = context.read<AuthProvider>().user!;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => BookAppointmentScreen(patientName: user.name, preselectedDoctor: doc))),
      child: Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderBlue),
          boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.06), blurRadius: 12, offset: const Offset(0,4))]),
        child: Row(children: [
          Container(width: 58, height: 58,
            decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(doc.emoji, style: const TextStyle(fontSize: 26)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(doc.name, style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600, fontSize: 15)),
            Text(doc.specialty, style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(doc.hospital, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11), overflow: TextOverflow.ellipsis),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 15), const SizedBox(width: 3),
              Text('${doc.rating}', style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600, fontSize: 13))]),
            const SizedBox(height: 4),
            Text('${doc.reviewCount} reviews', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
          ]),
        ])));
  }
}
