import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/animated_logo.dart';
import 'register_screen.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = CurvedAnimation(parent: _ac, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    context.read<AuthProvider>().clearError();
    final ok = await context
        .read<AuthProvider>()
        .login(_userCtrl.text, _passCtrl.text);
    if (ok && mounted)
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, a, __) => const MainShell(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 500)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppTheme.bgPage,
      body: Container(
          decoration: BoxDecoration(gradient: AppTheme.bgGradient),
          child: SafeArea(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                          position: _slide,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 44),
                                const Center(child: AnimatedLogo()),
                                const SizedBox(height: 16),
                                ShaderMask(
                                    shaderCallback: (b) => AppTheme
                                        .primaryGradient
                                        .createShader(b),
                                    child: const Text('MediQueue',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 34,
                                            fontWeight: FontWeight.w800))),
                                const SizedBox(height: 4),
                                const Text('Medical Appointment`',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.textMuted,
                                        fontSize: 13)),
                                const SizedBox(height: 40),

                                // Card
                                Container(
                                    padding: const EdgeInsets.all(28),
                                    decoration: BoxDecoration(
                                        color: AppTheme.cardWhite,
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                            color: AppTheme.borderBlue),
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppTheme.primary
                                                  .withOpacity(0.08),
                                              blurRadius: 32,
                                              offset: const Offset(0, 8))
                                        ]),
                                    child: Form(
                                        key: _form,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text('Welcome Back',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge),
                                              const SizedBox(height: 4),
                                              const Text(
                                                  'Sign in to manage your appointments',
                                                  style: TextStyle(
                                                      color: AppTheme.textMuted,
                                                      fontSize: 13)),
                                              const SizedBox(height: 28),
                                              TextFormField(
                                                  controller: _userCtrl,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  autocorrect: false,
                                                  decoration: const InputDecoration(
                                                      labelText: 'Username',
                                                      hintText:
                                                          'Enter your username',
                                                      prefixIcon: Icon(Icons
                                                          .person_outline_rounded)),
                                                  validator: (v) => (v ==
                                                              null ||
                                                          v.trim().isEmpty)
                                                      ? 'Username is required'
                                                      : null),
                                              const SizedBox(height: 16),
                                              TextFormField(
                                                  controller: _passCtrl,
                                                  obscureText: _obscure,
                                                  onFieldSubmitted: (_) =>
                                                      _login(),
                                                  decoration: InputDecoration(
                                                      labelText: 'Password',
                                                      hintText:
                                                          'Enter your password',
                                                      prefixIcon: const Icon(Icons
                                                          .lock_outline_rounded),
                                                      suffixIcon: IconButton(
                                                          icon: Icon(_obscure
                                                              ? Icons
                                                                  .visibility_off_outlined
                                                              : Icons
                                                                  .visibility_outlined),
                                                          onPressed: () =>
                                                              setState(() =>
                                                                  _obscure =
                                                                      !_obscure))),
                                                  validator: (v) {
                                                    if (v == null || v.isEmpty)
                                                      return 'Password is required';
                                                    if (v.length < 6)
                                                      return 'At least 6 characters';
                                                    return null;
                                                  }),
                                              const SizedBox(height: 20),
                                              Consumer<AuthProvider>(
                                                  builder: (_, auth, __) {
                                                if (auth.error == null)
                                                  return const SizedBox
                                                      .shrink();
                                                return Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 16),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme.error
                                                            .withOpacity(0.07),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            color: AppTheme
                                                                .error
                                                                .withOpacity(
                                                                    0.3))),
                                                    child: Row(children: [
                                                      const Icon(
                                                          Icons.error_outline,
                                                          color: AppTheme.error,
                                                          size: 18),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                          child: Text(
                                                              auth.error!,
                                                              style: const TextStyle(
                                                                  color: AppTheme
                                                                      .error,
                                                                  fontSize:
                                                                      13))),
                                                    ]));
                                              }),
                                              Consumer<AuthProvider>(
                                                  builder: (_, auth, __) =>
                                                      GradientButton(
                                                          label: 'Sign In',
                                                          icon: Icons
                                                              .login_rounded,
                                                          isLoading:
                                                              auth.isLoading,
                                                          onPressed:
                                                              auth.isLoading
                                                                  ? null
                                                                  : _login)),
                                            ]))),

                                const SizedBox(height: 24),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Don't have an account? ",
                                          style: TextStyle(
                                              color: AppTheme.textMuted,
                                              fontSize: 14)),
                                      GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const RegisterScreen())),
                                          child: const Text('Register',
                                              style: TextStyle(
                                                  color: AppTheme.primary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14))),
                                    ]),
                                const SizedBox(height: 36),
                              ])))))));
}
