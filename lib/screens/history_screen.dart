import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';
import '../theme/app_theme.dart';
import '../widgets/status_badge.dart';

class HistoryScreen extends StatefulWidget {
  final String patientName;
  const HistoryScreen({super.key, required this.patientName});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _fade;

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Upcoming', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  List<Appointment> get _filteredAppointments {
    final all = appointmentService.getHistory(widget.patientName);
    if (_selectedFilter == 'All') return all;
    return all
        .where(
            (a) => a.status.name.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final history = _filteredAppointments;

    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('My History',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 18)),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary stats row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: _buildSummary(),
            ),
            // Filter chips
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 0, 8),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => _filterChip(_filters[i]),
                ),
              ),
            ),
            // List header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${history.length} record${history.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 13)),
                ],
              ),
            ),
            // Appointment list
            Expanded(
              child: history.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                      itemCount: history.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _historyCard(context, history[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final all = appointmentService.getHistory(widget.patientName);
    final upcoming =
        all.where((a) => a.status == AppointmentStatus.upcoming).length;
    final completed =
        all.where((a) => a.status == AppointmentStatus.completed).length;
    final cancelled =
        all.where((a) => a.status == AppointmentStatus.cancelled).length;

    return Row(children: [
      _summaryTile('Total', '${all.length}', AppTheme.primary),
      const SizedBox(width: 10),
      _summaryTile('Upcoming', '$upcoming', const Color(0xFF22C55E)),
      const SizedBox(width: 10),
      _summaryTile('Completed', '$completed', const Color(0xFFF59E0B)),
      const SizedBox(width: 10),
      _summaryTile('Cancelled', '$cancelled', const Color(0xFFEF4444)),
    ]);
  }

  Widget _summaryTile(String label, String value, Color color) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w500)),
          ]),
        ),
      );

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.borderBlue,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: AppTheme.primary.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMuted,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _historyCard(BuildContext context, Appointment a) {
    final isPast = a.date.isBefore(DateTime.now());
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderBlue),
        boxShadow: [
          BoxShadow(
              color: AppTheme.primary.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
                child:
                    Text(a.doctor.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a.doctor.name,
                  style: const TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              Text(a.doctor.specialty,
                  style:
                      const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            ]),
          ),
          StatusBadge(a.status),
        ]),
        const SizedBox(height: 12),
        Container(height: 1, color: AppTheme.borderBlue),
        const SizedBox(height: 12),
        Row(children: [
          _infoChip(Icons.calendar_today_outlined,
              DateFormat('MMM d, y').format(a.date)),
          const SizedBox(width: 10),
          _infoChip(Icons.access_time_outlined, a.time),
          const Spacer(),
          if (isPast)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6B7280).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Past',
                  style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ),
        ]),
      ]),
    );
  }

  Widget _infoChip(IconData icon, String label) => Row(children: [
        Icon(icon, size: 12, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
      ]);

  Widget _emptyState() => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('📋', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          Text('No records found',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
              _selectedFilter == 'All'
                  ? 'Your appointment history will appear here.'
                  : 'No $_selectedFilter appointments found.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        ]),
      );
}
