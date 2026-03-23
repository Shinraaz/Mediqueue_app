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

              _settingTile(
                  Icons.notifications_outlined, 'Notifications', () {}),
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
