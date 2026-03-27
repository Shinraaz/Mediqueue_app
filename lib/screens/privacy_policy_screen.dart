import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: SafeArea(
        child: Column(
          children: [
            // ── Custom AppBar ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderBlue),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.primary, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Privacy Policy',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.privacy_tip_rounded,
                                color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Your Privacy Matters',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Last updated: June 2025',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Intro paragraph
                    _paragraphCard(
                      'We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains what information we collect, how we use it, and what rights you have in relation to it when you use our appointment scheduling app.',
                    ),

                    const SizedBox(height: 20),

                    _sectionCard(
                      icon: Icons.info_outline_rounded,
                      title: '1. Information We Collect',
                      items: [
                        _item('Personal Identifiers',
                            'Your full name, username, email address, and phone number used to identify your account.'),
                        _item('Appointment Data',
                            'Details of appointments you schedule, modify, or cancel including dates, times, service types, and notes.'),
                        _item('Device & Usage Data',
                            'Device type, operating system, app version, crash logs, and anonymous usage analytics to improve the app experience.'),
                        _item('Notification Preferences',
                            'Your chosen settings for push, email, and SMS notifications including reminder timing preferences.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      icon: Icons.track_changes_rounded,
                      title: '2. How We Use Your Information',
                      items: [
                        _item('Account Management',
                            'To create and maintain your account, authenticate your identity, and provide access to your personalized profile.'),
                        _item('Appointment Services',
                            'To schedule, confirm, remind, and manage your appointments. We send timely reminders based on your preferences.'),
                        _item('App Improvements',
                            'Aggregated and anonymized usage data helps us identify bugs, improve performance, and develop new features.'),
                        _item('Communications',
                            'To send you important account-related notices, appointment confirmations, and — with your consent — promotional content.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      icon: Icons.share_outlined,
                      title: '3. How We Share Your Information',
                      items: [
                        _item('Service Providers',
                            'We share data with trusted third-party vendors (e.g., email/SMS services) strictly to operate the app on our behalf.'),
                        _item('Legal Requirements',
                            'We may disclose information if required by law, regulation, or valid governmental request.'),
                        _item('Business Transfers',
                            'In the event of a merger, acquisition, or sale of assets, your data may be transferred with prior notice to you.'),
                        _item('No Sale of Data',
                            'We do not sell, rent, or trade your personal information to third parties for their own marketing purposes.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      icon: Icons.lock_outline_rounded,
                      title: '4. Data Security',
                      items: [
                        _item('Encryption',
                            'All data in transit is encrypted using TLS/SSL. Data at rest is secured using industry-standard AES-256 encryption.'),
                        _item('Access Controls',
                            'Only authorized personnel with a legitimate need can access personal data, and they are bound by confidentiality obligations.'),
                        _item('Incident Response',
                            'We have a documented breach response process and will notify affected users within 72 hours of discovering a significant data breach.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      icon: Icons.manage_accounts_outlined,
                      title: '5. Your Rights & Choices',
                      items: [
                        _item('Access & Correction',
                            'You may view and update your personal information at any time through the Profile section of the app.'),
                        _item('Notification Control',
                            'You can manage all push, email, and SMS notification preferences from the Notification Settings in your profile.'),
                        _item('Account Deletion',
                            'You can request permanent deletion of your account and associated data by contacting our support team.'),
                        _item('Data Portability',
                            'You may request a copy of your personal data in a machine-readable format by reaching out to us directly.'),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      icon: Icons.child_care_outlined,
                      title: "6. Children's Privacy",
                      items: [
                        _item('Age Restriction',
                            'Our app is not directed to children under 13. We do not knowingly collect personal information from children.'),
                        _item('Parental Action',
                            "If you believe your child has provided us with personal data, please contact us and we will promptly delete the information."),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      icon: Icons.contact_support_outlined,
                      title: '7. Contact Us',
                      items: [
                        _item('Support Email',
                            'privacy@mediqueue.com — for privacy-specific requests and concerns.'),
                        _item('General Support',
                            'support@mediqueue.com — for general questions about your account or the app.'),
                        _item('Mailing Address',
                            'EC Care, Mandaue City, Cebu, Philippines.'),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Footer note
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppTheme.primary.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.verified_user_outlined,
                              color: AppTheme.primary, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'By using this app, you agree to this Privacy Policy and our Terms of Service.',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _paragraphCard(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderBlue),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 13.5,
            height: 1.65,
          ),
        ),
      );

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required List<_PolicyItem> items,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderBlue),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(icon, color: Colors.white, size: 15),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Items
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                children: items.asMap().entries.map((e) {
                  final isLast = e.key == items.length - 1;
                  return Column(
                    children: [
                      _policyItemTile(e.value),
                      if (!isLast)
                        Divider(
                          color: AppTheme.borderBlue,
                          height: 16,
                          thickness: 1,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );

  Widget _policyItemTile(_PolicyItem item) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  _PolicyItem _item(String label, String description) =>
      _PolicyItem(label: label, description: description);
}

// ── Data model ─────────────────────────────────────────────────────────────────
class _PolicyItem {
  final String label;
  final String description;
  const _PolicyItem({required this.label, required this.description});
}
