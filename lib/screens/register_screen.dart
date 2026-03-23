import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import 'main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confCtrl = TextEditingController();
  bool _obscureP = true, _obscureC = true;

  @override void dispose() {
    for (final c in [_nameCtrl,_userCtrl,_emailCtrl,_phoneCtrl,_passCtrl,_confCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    context.read<AuthProvider>().clearError();
    final ok = await context.read<AuthProvider>().register(
      name: _nameCtrl.text, username: _userCtrl.text,
      email: _emailCtrl.text, password: _passCtrl.text, phone: _phoneCtrl.text);
    if (ok && mounted) Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(pageBuilder: (_, a, __) => const MainShell(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child)),
      (_) => false);
  }

  Widget _field(TextEditingController ctrl, String label, String hint, IconData icon,
    {TextInputType? type, bool required = true, String? Function(String?)? validator}) =>
    TextFormField(controller: ctrl, keyboardType: type,
      decoration: InputDecoration(labelText: label, hintText: hint, prefixIcon: Icon(icon)),
      validator: validator ?? (v) => (required && (v == null || v.trim().isEmpty)) ? 'Required' : null);

  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.bgPage,
    body: Container(decoration: BoxDecoration(gradient: AppTheme.bgGradient),
      child: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const SizedBox(height: 20),
          Row(children: [IconButton(onPressed: () => Navigator.pop(context),
            icon: Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderBlue),
                boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.07), blurRadius: 8)]),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textDark)))]),
          const SizedBox(height: 8),
          Text('Create Account', style: Theme.of(context).textTheme.displayLarge),
          const SizedBox(height: 4),
          const Text('Book and manage your medical appointments',
            style: TextStyle(color: AppTheme.textMuted)),
          const SizedBox(height: 28),

          Container(padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: AppTheme.cardWhite, borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppTheme.borderBlue),
              boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.08), blurRadius: 32, offset: const Offset(0, 8))]),
            child: Form(key: _form, child: Column(children: [
              _field(_nameCtrl, 'Full Name', 'e.g. Juan dela Cruz', Icons.badge_outlined),
              const SizedBox(height: 14),
              _field(_userCtrl, 'Username', 'Choose a unique username', Icons.person_outline_rounded,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.length < 3) return 'At least 3 characters';
                  if (v.contains(' ')) return 'No spaces allowed';
                  return null;
                }),
              const SizedBox(height: 14),
              _field(_emailCtrl, 'Email Address', 'your@email.com', Icons.email_outlined,
                type: TextInputType.emailAddress,
                validator: (v) { if (v==null||v.isEmpty) return 'Required';
                  if (!v.contains('@')) return 'Enter a valid email'; return null; }),
              const SizedBox(height: 14),
              _field(_phoneCtrl, 'Phone (optional)', '09XXXXXXXXX', Icons.phone_outlined,
                type: TextInputType.phone, required: false),
              const SizedBox(height: 14),
              TextFormField(controller: _passCtrl, obscureText: _obscureP,
                decoration: InputDecoration(labelText: 'Password', hintText: 'At least 6 characters',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(icon: Icon(_obscureP ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscureP = !_obscureP))),
                validator: (v) { if (v==null||v.isEmpty) return 'Required';
                  if (v.length < 6) return 'At least 6 characters'; return null; }),
              const SizedBox(height: 14),
              TextFormField(controller: _confCtrl, obscureText: _obscureC,
                decoration: InputDecoration(labelText: 'Confirm Password', hintText: 'Re-enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(icon: Icon(_obscureC ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscureC = !_obscureC))),
                validator: (v) { if (v==null||v.isEmpty) return 'Required';
                  if (v != _passCtrl.text) return 'Passwords do not match'; return null; }),
              const SizedBox(height: 12),
              Consumer<AuthProvider>(builder: (_, auth, __) {
                if (auth.error == null) return const SizedBox.shrink();
                return Container(margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.error.withOpacity(0.3))),
                  child: Row(children: [const Icon(Icons.error_outline, color: AppTheme.error, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(auth.error!, style: const TextStyle(color: AppTheme.error, fontSize: 13)))]));
              }),
              const SizedBox(height: 8),
              Consumer<AuthProvider>(builder: (_, auth, __) => GradientButton(
                label: 'Create Account', icon: Icons.person_add_rounded,
                isLoading: auth.isLoading, onPressed: auth.isLoading ? null : _register)),
            ]))),
          const SizedBox(height: 36),
        ])))));
}
