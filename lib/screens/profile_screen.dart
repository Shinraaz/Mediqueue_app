import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../services/appointment_service.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    final upcoming = appointmentService.getUpcoming(user.name).length;
    final past = appointmentService.getPast(user.name).length;

    return SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text('My Profile',
                  style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 28),

              // Avatar with gradient
              Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.primary.withOpacity(0.35),
                            blurRadius: 24,
                            spreadRadius: 2)
                      ]),
                  child: Center(
                      child: Text(user.initials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w700)))),
              const SizedBox(height: 14),

              // Name with gradient shader
              ShaderMask(
                  shaderCallback: (b) =>
                      AppTheme.primaryGradient.createShader(b),
                  child: Text(user.name,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700))),
              const SizedBox(height: 4),
              Text('@${user.username}',
                  style:
                      const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
              const SizedBox(height: 20),

              // Appointment stats
              Row(children: [
                _statBox('$upcoming', 'Upcoming', AppTheme.primary),
                const SizedBox(width: 12),
                _statBox('$past', 'Past', AppTheme.primaryDark),
                const SizedBox(width: 12),
                _statBox('${upcoming + past}', 'Total', AppTheme.primaryLight),
              ]),
              const SizedBox(height: 24),

              _infoTile(Icons.email_outlined, 'Email', user.email),
              const SizedBox(height: 10),
              _infoTile(
                  Icons.person_outline_rounded, 'Username', user.username),
              if (user.phone.isNotEmpty) ...[
                const SizedBox(height: 10),
                _infoTile(Icons.phone_outlined, 'Phone', user.phone)
              ],
              const SizedBox(height: 10),
              _infoTile(Icons.badge_outlined, 'User ID', user.id),
              const SizedBox(height: 24),

              // ✅ Notifications now opens the full settings sheet
              _settingTile(Icons.notifications_outlined, 'Notifications',
                  () => _showNotificationSettings(context)),
              _settingTile(
                  Icons.lock_outline_rounded, 'Change Password', () {}),
              _settingTile(Icons.help_outline_rounded, 'Help & Support', () {}),
              _settingTile(Icons.privacy_tip_outlined, 'Privacy Policy', () {}),
              const SizedBox(height: 20),

              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                      onPressed: () async {
                        await context.read<AuthProvider>().logout();
                        if (context.mounted)
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (_) => false);
                      },
                      icon: const Icon(Icons.logout_rounded,
                          color: AppTheme.error),
                      label: const Text('Sign Out',
                          style: TextStyle(
                              color: AppTheme.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                              color: AppTheme.error.withOpacity(0.45)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))))),
              const SizedBox(height: 32),
            ])));
  }

  // ─── Notification Settings Bottom Sheet ───────────────────────────────────
  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NotificationSettingsSheet(),
    );
  }

  // ─── Reusable Widgets ──────────────────────────────────────────────────────

  Widget _statBox(String value, String label, Color color) => Expanded(
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2))),
          child: Column(children: [
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ])));

  Widget _infoTile(IconData icon, String label, String value) => Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderBlue),
          boxShadow: [
            BoxShadow(
                color: AppTheme.primary.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ]),
      child: Row(children: [
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppTheme.primary, size: 18)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: AppTheme.textDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
        ]),
      ]));

  Widget _settingTile(IconData icon, String label, VoidCallback onTap) =>
      ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppTheme.primary, size: 18)),
          title: Text(label,
              style: const TextStyle(color: AppTheme.textDark, fontSize: 14)),
          trailing: const Icon(Icons.chevron_right_rounded,
              color: AppTheme.textMuted));
}

// ═══════════════════════════════════════════════════════════════════════════════
// Notification Settings Bottom Sheet
// ═══════════════════════════════════════════════════════════════════════════════

class _NotificationSettingsSheet extends StatefulWidget {
  const _NotificationSettingsSheet();

  @override
  State<_NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends State<_NotificationSettingsSheet> {
  // Toggle states — wire these to SharedPreferences or your backend as needed
  bool _appointmentReminders = true;
  bool _upcomingAlerts = true;
  bool _cancellationUpdates = true;
  bool _promotions = false;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;

  // Reminder time selection
  String _reminderTime = '1 hour before';
  final List<String> _reminderOptions = [
    '15 mins before',
    '30 mins before',
    '1 hour before',
    '2 hours before',
    '1 day before',
  ];

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle bar ──────────────────────────────────────────────────────
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderBlue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Header ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notification Settings',
                        style: TextStyle(
                            color: AppTheme.textDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    Text('Manage how you receive alerts',
                        style:
                            TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded,
                      color: AppTheme.textMuted, size: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(color: AppTheme.borderBlue),

          // ── Scrollable content ───────────────────────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Section: Appointment ──────────────────────────────────
                  _sectionLabel('Appointment Alerts'),
                  const SizedBox(height: 10),

                  _notifToggle(
                    icon: Icons.calendar_today_outlined,
                    title: 'Appointment Reminders',
                    subtitle: 'Get notified before your appointments',
                    value: _appointmentReminders,
                    onChanged: (val) =>
                        setState(() => _appointmentReminders = val),
                  ),

                  // Reminder time dropdown — shown only when reminders are ON
                  if (_appointmentReminders) ...[
                    const SizedBox(height: 8),
                    _reminderTimePicker(),
                  ],

                  const SizedBox(height: 10),

                  _notifToggle(
                    icon: Icons.access_time_rounded,
                    title: 'Upcoming Alerts',
                    subtitle: 'Alerts for appointments within 24 hours',
                    value: _upcomingAlerts,
                    onChanged: (val) => setState(() => _upcomingAlerts = val),
                  ),
                  const SizedBox(height: 10),

                  _notifToggle(
                    icon: Icons.cancel_outlined,
                    title: 'Cancellation Updates',
                    subtitle: 'Know when an appointment is cancelled',
                    value: _cancellationUpdates,
                    onChanged: (val) =>
                        setState(() => _cancellationUpdates = val),
                  ),

                  const SizedBox(height: 20),

                  // ── Section: Channels ────────────────────────────────────
                  _sectionLabel('Notification Channels'),
                  const SizedBox(height: 10),

                  _notifToggle(
                    icon: Icons.notifications_active_outlined,
                    title: 'Push Notifications',
                    subtitle: 'Receive alerts on your device',
                    value: _pushNotifications,
                    onChanged: (val) =>
                        setState(() => _pushNotifications = val),
                  ),
                  const SizedBox(height: 10),

                  _notifToggle(
                    icon: Icons.email_outlined,
                    title: 'Email Notifications',
                    subtitle: 'Receive updates via email',
                    value: _emailNotifications,
                    onChanged: (val) =>
                        setState(() => _emailNotifications = val),
                  ),
                  const SizedBox(height: 10),

                  _notifToggle(
                    icon: Icons.sms_outlined,
                    title: 'SMS Notifications',
                    subtitle: 'Receive alerts via text message',
                    value: _smsNotifications,
                    onChanged: (val) => setState(() => _smsNotifications = val),
                  ),

                  const SizedBox(height: 20),

                  // ── Section: Marketing ───────────────────────────────────
                  _sectionLabel('Marketing & Promotions'),
                  const SizedBox(height: 10),

                  _notifToggle(
                    icon: Icons.local_offer_outlined,
                    title: 'Promotions & Deals',
                    subtitle: 'Special offers and discounts',
                    value: _promotions,
                    onChanged: (val) => setState(() => _promotions = val),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Save button ──────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : () => _savePreferences(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  disabledBackgroundColor: AppTheme.primary.withOpacity(0.6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Text('Save Preferences',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Save handler ─────────────────────────────────────────────────────────────
  Future<void> _savePreferences(BuildContext context) async {
    setState(() => _isSaving = true);

    // TODO: Replace with SharedPreferences or API call, e.g.:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('notif_appointment_reminders', _appointmentReminders);
    // await prefs.setBool('notif_upcoming_alerts', _upcomingAlerts);
    // await prefs.setBool('notif_cancellation_updates', _cancellationUpdates);
    // await prefs.setBool('notif_push', _pushNotifications);
    // await prefs.setBool('notif_email', _emailNotifications);
    // await prefs.setBool('notif_sms', _smsNotifications);
    // await prefs.setBool('notif_promotions', _promotions);
    // await prefs.setString('notif_reminder_time', _reminderTime);

    await Future.delayed(const Duration(milliseconds: 600)); // simulate save

    if (!mounted) return;
    setState(() => _isSaving = false);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8),
          Text('Notification preferences saved',
              style: TextStyle(fontWeight: FontWeight.w500)),
        ]),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) => Text(
        label,
        style: const TextStyle(
          color: AppTheme.textDark,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      );

  // ── Toggle row ────────────────────────────────────────────────────────────
  Widget _notifToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderBlue),
          boxShadow: [
            BoxShadow(
                color: AppTheme.primary.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: value
                    ? AppTheme.primarySoft
                    : AppTheme.borderBlue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: value ? AppTheme.primary : AppTheme.textMuted,
                  size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: value ? AppTheme.textDark : AppTheme.textMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppTheme.textMuted, fontSize: 11)),
                ],
              ),
            ),
            Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.primary,
            ),
          ],
        ),
      );

  // ── Reminder time picker ──────────────────────────────────────────────────
  Widget _reminderTimePicker() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.primarySoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.timer_outlined, color: AppTheme.primary, size: 16),
            const SizedBox(width: 8),
            const Text('Remind me',
                style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            const Spacer(),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _reminderTime,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.primary, size: 18),
                style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                items: _reminderOptions
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _reminderTime = val);
                },
              ),
            ),
          ],
        ),
      );
}
