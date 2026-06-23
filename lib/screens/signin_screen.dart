import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/app_logo.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _showPass = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  static final _emailRx = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

  void _signIn() {
    final name  = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text;
    if (name.isEmpty) { setState(() => _error = 'Please enter your name or company.'); return; }
    if (email.isEmpty) { setState(() => _error = 'Please enter your email address.'); return; }
    if (!_emailRx.hasMatch(email)) { setState(() => _error = 'Enter a valid email — e.g. you@gmail.com'); return; }
    if (pass.length < 6) { setState(() => _error = 'Password must be at least 6 characters.'); return; }
    final state = context.read<AppState>();
    state.userName    = name;
    state.userEmail   = email;
    state.userCompany = name;
    state.setTab('home', 'home');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Container(
      decoration: const BoxDecoration(gradient: AppTokens.welcomeGradient),
      child: Stack(children: [
        const DiagonalStripes(opacity: 0.03),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(children: [
                CircleIconButton(bg: Colors.white.withOpacity(0.10), iconColor: Colors.white, onTap: () => state.back()),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: const AppLogo(size: 62)),
                    const SizedBox(height: 24),
                    Text('Welcome back',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.8)),
                    const SizedBox(height: 6),
                    Text('Sign in to manage your hires.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.60), fontSize: 15)),
                    const SizedBox(height: 36),

                    _FieldLabel('YOUR NAME / COMPANY'),
                    const SizedBox(height: 8),
                    _InputBox(child: TextField(
                      controller: _nameCtrl,
                      style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14.5),
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDec('e.g. Hishaam or Lustre Events'),
                      onChanged: (_) => setState(() => _error = null),
                    )),
                    const SizedBox(height: 16),

                    _FieldLabel('EMAIL'),
                    const SizedBox(height: 8),
                    _InputBox(child: TextField(
                      controller: _emailCtrl,
                      style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14.5),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDec('you@example.com'),
                      onChanged: (_) => setState(() => _error = null),
                    )),
                    const SizedBox(height: 16),

                    _FieldLabel('PASSWORD'),
                    const SizedBox(height: 8),
                    _InputBox(child: Row(children: [
                      Expanded(child: TextField(
                        controller: _passCtrl,
                        obscureText: !_showPass,
                        style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14.5),
                        decoration: _inputDec('••••••••'),
                        onChanged: (_) => setState(() => _error = null),
                        onSubmitted: (_) => _signIn(),
                      )),
                      GestureDetector(
                        onTap: () => setState(() => _showPass = !_showPass),
                        child: Text(_showPass ? 'Hide' : 'Show',
                          style: GoogleFonts.hankenGrotesk(color: AppTokens.brandMint, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ])),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight,
                      child: Text('Forgot password?',
                        style: GoogleFonts.hankenGrotesk(color: AppTokens.brandMint, fontSize: 13, fontWeight: FontWeight.w600))),

                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      _ErrorBox(_error!),
                    ],
                    const SizedBox(height: 28),

                    GestureDetector(
                      onTap: _signIn,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppTokens.brandBright,
                          borderRadius: BorderRadius.circular(AppTokens.btnRadius),
                          boxShadow: [BoxShadow(color: AppTokens.brandBright.withOpacity(0.38), blurRadius: 24, offset: const Offset(0, 10))],
                        ),
                        alignment: Alignment.center,
                        child: Text('Sign in', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.2)),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(children: [
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.16))),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text('OR', style: GoogleFonts.jetBrainsMono(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 1.5))),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.16))),
                    ]),
                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: _signIn,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(AppTokens.btnRadius),
                          border: Border.all(color: Colors.white.withOpacity(0.18)),
                        ),
                        alignment: Alignment.center,
                        child: Text('Continue with SSO',
                          style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: GoogleFonts.jetBrainsMono(color: Colors.white.withOpacity(0.55), fontSize: 10, letterSpacing: 2.2, fontWeight: FontWeight.w600));
}

class _InputBox extends StatelessWidget {
  final Widget child;
  const _InputBox({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.07),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withOpacity(0.18)),
    ),
    child: child,
  );
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox(this.message);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(color: const Color(0x22FF6B6B), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0x55FF6B6B))),
    child: Row(children: [
      const Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(message, style: GoogleFonts.hankenGrotesk(color: const Color(0xFFFF6B6B), fontSize: 13.5, fontWeight: FontWeight.w600))),
    ]),
  );
}

InputDecoration _inputDec(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.32), fontSize: 14.5),
  border: InputBorder.none,
  isDense: true,
  contentPadding: EdgeInsets.zero,
);
