import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String patientName;
  final Doctor? preselectedDoctor;
  const BookAppointmentScreen(
      {super.key, required this.patientName, this.preselectedDoctor});
  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  Doctor? _doctor;
  DateTime? _date;
  String? _time;
  final _notesCtrl = TextEditingController();
  int _step = 0;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedDoctor != null) {
      _doctor = widget.preselectedDoctor;
      _step = 1;
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  // ── Only builds the current step (fixes "Unexpected null value" crash) ──
  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _step0();
      case 1:
        return _step1();
      case 2:
        return _step2();
      case 3:
        return _step3();
      default:
        return _step0();
    }
  }

  void _book() {
    appointmentService.book(
        doctor: _doctor!,
        date: _date!,
        time: _time!,
        patientName: widget.patientName,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim());
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: AppTheme.primary.withOpacity(0.3),
                                blurRadius: 24)
                          ]),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 40)),
                  const SizedBox(height: 20),
                  Text('Appointment Booked!',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                      'Your appointment with ${_doctor!.name} on ${DateFormat('MMM d, y').format(_date!)} at $_time is confirmed.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                          height: 1.5)),
                  const SizedBox(height: 24),
                  GradientButton(
                      label: 'Done',
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }),
                ]))));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: SafeArea(
          child: Column(children: [
        _topBar(context),
        _stepIndicator(),
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: _buildStep())), // ← fixed: only builds current step
      ])));

  Widget _topBar(BuildContext context) {
    final titles = [
      'Select Doctor',
      'Pick Date & Time',
      'Add Notes',
      'Confirm Booking'
    ];
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Row(children: [
          IconButton(
              onPressed: () =>
                  _step == 0 ? Navigator.pop(context) : setState(() => _step--),
              icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: AppTheme.cardWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderBlue)),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: AppTheme.textDark))),
          Expanded(
              child: Text(titles[_step],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge)),
          const SizedBox(width: 48),
        ]));
  }

  Widget _stepIndicator() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
          children: List.generate(
              4,
              (i) => Expanded(
                      child: Row(children: [
                    Expanded(
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: i <= _step
                                    ? AppTheme.primaryGradient
                                    : null,
                                color:
                                    i <= _step ? null : AppTheme.borderBlue))),
                    if (i < 3) const SizedBox(width: 4),
                  ])))));

  Widget _step0() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Who would you like to see?',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
        const SizedBox(height: 20),
        ...seedDoctors.map((doc) {
          final sel = _doctor?.id == doc.id;
          return GestureDetector(
              onTap: () => setState(() => _doctor = doc),
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: sel ? AppTheme.primarySoft : AppTheme.cardWhite,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: sel ? AppTheme.primary : AppTheme.borderBlue,
                          width: sel ? 2 : 1),
                      boxShadow: [
                        BoxShadow(
                            color:
                                AppTheme.primary.withOpacity(sel ? 0.1 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ]),
                  child: Row(children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: AppTheme.primarySoft,
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                            child: Text(doc.emoji,
                                style: const TextStyle(fontSize: 22)))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(doc.name,
                              style: TextStyle(
                                  color: sel
                                      ? AppTheme.primary
                                      : AppTheme.textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                          Text(doc.specialty,
                              style: const TextStyle(
                                  color: AppTheme.textMuted, fontSize: 12)),
                          const SizedBox(height: 3),
                          Row(children: [
                            const Icon(Icons.star_rounded,
                                size: 12, color: Color(0xFFFBBF24)),
                            const SizedBox(width: 3),
                            Text('${doc.rating}  •  ${doc.hospital}',
                                style: const TextStyle(
                                    color: AppTheme.textMuted, fontSize: 11),
                                overflow: TextOverflow.ellipsis)
                          ]),
                        ])),
                    if (sel)
                      const Icon(Icons.check_circle_rounded,
                          color: AppTheme.primary),
                  ])));
        }),
        const SizedBox(height: 24),
        GradientButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed:
                _doctor == null ? null : () => setState(() => _step = 1)),
      ]);

  Widget _step1() {
    final doc = _doctor!;
    final days = <DateTime>[];
    final today = DateTime.now();
    for (int i = 1; i <= 21; i++) {
      final d = today.add(Duration(days: i));
      if (doc.availableDays
          .contains(DateFormat('EEE').format(d).substring(0, 3))) days.add(d);
      if (days.length >= 10) break;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderBlue)),
          child: Row(children: [
            Text(doc.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(doc.name,
                  style: const TextStyle(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              Text(doc.specialty,
                  style:
                      const TextStyle(color: AppTheme.primary, fontSize: 12)),
            ])
          ])),
      const SizedBox(height: 22),
      Text('Select a Date', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 12),
      SizedBox(
          height: 80,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final d = days[i];
                final sel = _date != null &&
                    d.day == _date!.day &&
                    d.month == _date!.month &&
                    d.year == _date!.year;
                return GestureDetector(
                    onTap: () => setState(() {
                          _date = d;
                          _time = null;
                        }),
                    child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 60,
                        decoration: BoxDecoration(
                            gradient: sel ? AppTheme.primaryGradient : null,
                            color: sel ? null : AppTheme.cardWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: sel
                                    ? Colors.transparent
                                    : AppTheme.borderBlue),
                            boxShadow: [
                              BoxShadow(
                                  color: AppTheme.primary
                                      .withOpacity(sel ? 0.25 : 0.06),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ]),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DateFormat('EEE').format(d),
                                  style: TextStyle(
                                      color: sel
                                          ? Colors.white70
                                          : AppTheme.textMuted,
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(DateFormat('d').format(d),
                                  style: TextStyle(
                                      color: sel
                                          ? Colors.white
                                          : AppTheme.textDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20)),
                              Text(DateFormat('MMM').format(d),
                                  style: TextStyle(
                                      color: sel
                                          ? Colors.white70
                                          : AppTheme.textMuted,
                                      fontSize: 11)),
                            ])));
              })),
      const SizedBox(height: 22),
      Text('Select a Time', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 12),
      Wrap(
          spacing: 10,
          runSpacing: 10,
          children: doc.availableTimes.map((t) {
            final sel = _time == t;
            final disabled = _date == null;
            return GestureDetector(
                onTap: disabled ? null : () => setState(() => _time = t),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                        gradient: sel ? AppTheme.primaryGradient : null,
                        color: sel
                            ? null
                            : (disabled
                                ? AppTheme.bgSection
                                : AppTheme.cardWhite),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color:
                                sel ? Colors.transparent : AppTheme.borderBlue),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                    color: AppTheme.primary.withOpacity(0.2),
                                    blurRadius: 8)
                              ]
                            : null),
                    child: Text(t,
                        style: TextStyle(
                            color: sel
                                ? Colors.white
                                : (disabled
                                    ? AppTheme.textHint
                                    : AppTheme.textBody),
                            fontSize: 13,
                            fontWeight: FontWeight.w500))));
          }).toList()),
      const SizedBox(height: 32),
      GradientButton(
          label: 'Continue',
          icon: Icons.arrow_forward_rounded,
          onPressed: (_date == null || _time == null)
              ? null
              : () => setState(() => _step = 2)),
    ]);
  }

  Widget _step2() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Any notes for the doctor?',
            style: TextStyle(
                color: AppTheme.textBody,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        const Text('Describe your symptoms or reason for visit (optional)',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        const SizedBox(height: 24),
        TextFormField(
            controller: _notesCtrl,
            maxLines: 6,
            decoration: const InputDecoration(
                hintText: 'e.g. Experiencing chest pain...',
                alignLabelWithHint: true)),
        const SizedBox(height: 32),
        GradientButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => setState(() => _step = 3)),
        const SizedBox(height: 12),
        Center(
            child: TextButton(
                onPressed: () {
                  _notesCtrl.clear();
                  setState(() => _step = 3);
                },
                child: const Text('Skip',
                    style: TextStyle(color: AppTheme.textMuted)))),
      ]);

  Widget _step3() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Review your appointment details',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
        const SizedBox(height: 20),
        Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
                gradient: AppTheme.heroGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8))
                ]),
            child: Column(children: [
              Row(children: [
                Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                        child: Text(_doctor!.emoji,
                            style: const TextStyle(fontSize: 28)))),
                const SizedBox(width: 14),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_doctor!.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  Text(_doctor!.specialty,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              ]),
              const SizedBox(height: 18),
              const Divider(color: Colors.white24),
              const SizedBox(height: 14),
              _cRow(Icons.calendar_today_outlined, 'Date',
                  DateFormat('EEEE, MMMM d, y').format(_date!)),
              const SizedBox(height: 10),
              _cRow(Icons.access_time_outlined, 'Time', _time!),
              const SizedBox(height: 10),
              _cRow(
                  Icons.local_hospital_outlined, 'Hospital', _doctor!.hospital),
              const SizedBox(height: 10),
              _cRow(
                  Icons.person_outline_rounded, 'Patient', widget.patientName),
              if (_notesCtrl.text.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                _cRow(Icons.notes_rounded, 'Notes', _notesCtrl.text.trim())
              ],
            ])),
        const SizedBox(height: 32),
        GradientButton(
            label: 'Confirm Booking',
            icon: Icons.check_circle_rounded,
            onPressed: _book),
        const SizedBox(height: 12),
        Center(
            child: TextButton(
                onPressed: () => setState(() => _step = 0),
                child: const Text('Start Over',
                    style: TextStyle(color: AppTheme.textMuted)))),
      ]);

  Widget _cRow(IconData icon, String label, String value) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 15, color: Colors.white60),
        const SizedBox(width: 10),
        Text('$label:  ',
            style: const TextStyle(color: Colors.white60, fontSize: 13)),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis)),
      ]);
}
