import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});
  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _companyCtrl = TextEditingController();
  bool _showPass = false;
  String? _error;

  static const eventTypes = ['Weddings', 'Corporate', 'Festivals', 'Private parties', 'Conferences', 'Pop-ups'];
  static const sizes = ['Just me', '2–5', '6–20', '20+'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _companyCtrl.dispose();
    super.dispose();
  }

  static final _emailRx = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

  void _continue() {
    final state = context.read<AppState>();
    final name    = _nameCtrl.text.trim();
    final email   = _emailCtrl.text.trim();
    final pass    = _passCtrl.text;
    final company = _companyCtrl.text.trim();

    if (name.isEmpty) { setState(() => _error = 'Please enter your full name.'); return; }
    if (email.isEmpty) { setState(() => _error = 'Please enter your email address.'); return; }
    if (!_emailRx.hasMatch(email)) { setState(() => _error = 'Enter a valid email — e.g. you@gmail.com'); return; }
    if (pass.length < 6) { setState(() => _error = 'Password must be at least 6 characters.'); return; }
    if (company.isEmpty) { setState(() => _error = 'Please enter your company or trading name.'); return; }
    if (state.onboardSel.isEmpty) { setState(() => _error = 'Select at least one event type.'); return; }

    state.userName    = name;
    state.userEmail   = email;
    state.userCompany = company;
    state.go('home');
  }

  Widget _label(String text) => Text(text,
    style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 13, fontWeight: FontWeight.w600));

  Widget _field(TextEditingController ctrl, String hint, {TextInputType? kb, bool obscure = false, Widget? suffix}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTokens.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppTokens.border),
      ),
      child: Row(children: [
        Expanded(child: TextField(
          controller: ctrl,
          obscureText: obscure && !_showPass,
          keyboardType: kb,
          style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 14.5),
            border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
          ),
          onChanged: (_) => setState(() => _error = null),
        )),
        if (suffix != null) suffix,
      ]),
    );

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      color: AppTokens.bg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: CircleIconButton(onTap: () => state.back()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MonoLabel('CREATE ACCOUNT', color: AppTokens.brand, spacing: 2),
                    const SizedBox(height: 12),
                    Text('Tell us about\nyour events.',
                      style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 30, fontWeight: FontWeight.w800, height: 1.08, letterSpacing: -0.8)),
                    const SizedBox(height: 28),

                    // ── Personal details ──────────────────────────────────
                    _label('Full name'),
                    const SizedBox(height: 8),
                    _field(_nameCtrl, 'e.g. Hishaam Cali', kb: TextInputType.name),
                    const SizedBox(height: 16),

                    _label('Email address'),
                    const SizedBox(height: 8),
                    _field(_emailCtrl, 'you@example.com', kb: TextInputType.emailAddress),
                    const SizedBox(height: 16),

                    _label('Password'),
                    const SizedBox(height: 8),
                    _field(_passCtrl, '••••••••', obscure: true,
                      suffix: GestureDetector(
                        onTap: () => setState(() => _showPass = !_showPass),
                        child: Text(_showPass ? 'Hide' : 'Show',
                          style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w600)),
                      )),
                    const SizedBox(height: 16),

                    _label('Company or trading name'),
                    const SizedBox(height: 8),
                    _field(_companyCtrl, 'e.g. Lustre Events'),
                    const SizedBox(height: 28),

                    // ── Event types ────────────────────────────────────────
                    _label('What do you plan?'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10, runSpacing: 10,
                      children: eventTypes.map((t) {
                        final sel = state.onboardSel.contains(t);
                        return GestureDetector(
                          onTap: () {
                            setState(() => _error = null);
                            if (sel) {
                              state.onboardSel = state.onboardSel.where((e) => e != t).toList();
                            } else {
                              state.onboardSel = [...state.onboardSel, t];
                            }
                            state.bump();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: sel ? AppTokens.brand : AppTokens.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: sel ? AppTokens.brand : AppTokens.border),
                            ),
                            child: Text(t, style: GoogleFonts.hankenGrotesk(color: sel ? Colors.white : AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w600)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 26),

                    // ── Team size ──────────────────────────────────────────
                    _label('Team size'),
                    const SizedBox(height: 12),
                    Row(
                      children: sizes.map((s) {
                        final sel = state.teamSize == s;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: s == sizes.last ? 0 : 8),
                            child: GestureDetector(
                              onTap: () { state.teamSize = s; state.bump(); },
                              child: Container(
                                height: 48, alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: sel ? AppTokens.brandTint : AppTokens.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: sel ? AppTokens.brand : AppTokens.border),
                                ),
                                child: Text(s, style: GoogleFonts.hankenGrotesk(color: sel ? AppTokens.brand : AppTokens.textMuted2, fontSize: 13, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    // ── Error ──────────────────────────────────────────────
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: const Color(0x12FF4444), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0x44FF4444))),
                        child: Row(children: [
                          const Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_error!, style: GoogleFonts.hankenGrotesk(color: const Color(0xFFFF6B6B), fontSize: 13.5, fontWeight: FontWeight.w600))),
                        ]),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: GestureDetector(
                onTap: _continue,
                child: Container(
                  height: 54, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTokens.brand,
                    borderRadius: BorderRadius.circular(AppTokens.btnRadius),
                    boxShadow: [BoxShadow(color: AppTokens.brand.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8))],
                  ),
                  child: Text('Create account', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
