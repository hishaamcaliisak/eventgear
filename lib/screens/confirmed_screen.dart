import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class ConfirmedScreen extends StatefulWidget {
  const ConfirmedScreen({super.key});
  @override
  State<ConfirmedScreen> createState() => _ConfirmedScreenState();
}

class _ConfirmedScreenState extends State<ConfirmedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 620));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final item = state.currentItem;
    return Container(
      decoration: const BoxDecoration(gradient: AppTokens.welcomeGradient),
      child: Stack(
        children: [
          const DiagonalStripes(opacity: 0.035),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
              child: Column(
                children: [
                  const Spacer(),
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 96, height: 96,
                      decoration: BoxDecoration(color: AppTokens.brandBright, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppTokens.brandBright.withOpacity(0.45), blurRadius: 40, spreadRadius: 4)]),
                      child: const Icon(Icons.check, color: Colors.white, size: 48),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Booking confirmed', style: GoogleFonts.archivo(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.6)),
                  const SizedBox(height: 8),
                  Text('Your request has been sent to ${item.owner}. We\'ll notify you once they confirm pickup.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.72), fontSize: 14.5, height: 1.5)),
                  const SizedBox(height: 26),
                  Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.14))),
                    padding: const EdgeInsets.all(18),
                    child: Column(children: [
                      _row('Item', item.name),
                      _divider(),
                      _row('Dates', '${state.formatDate(state.startDate)} → ${state.formatDate(state.endDate)}'),
                      _divider(),
                      _row('Charged today', state.formatPrice(state.dueToday)),
                      _divider(),
                      _row('Booking ref', 'EG-${item.code}-4821'),
                    ]),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () { state.checkTab = 'pickup'; state.go('checklist'); },
                    child: Container(
                      height: AppTokens.btnHeight, width: double.infinity,
                      decoration: BoxDecoration(color: AppTokens.brandBright, borderRadius: BorderRadius.circular(AppTokens.btnRadius)),
                      alignment: Alignment.center,
                      child: Text('View pickup checklist', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => state.setTab('home', 'home'),
                    child: Container(
                      height: AppTokens.btnHeight, width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(AppTokens.btnRadius), border: Border.all(color: Colors.white.withOpacity(0.16))),
                      alignment: Alignment.center,
                      child: Text('Back to home', style: GoogleFonts.archivo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.6), fontSize: 13)),
      Flexible(child: Text(value, textAlign: TextAlign.right, style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700))),
    ]);
  }

  Widget _divider() => Padding(padding: const EdgeInsets.symmetric(vertical: 11), child: Divider(color: Colors.white.withOpacity(0.12), height: 1));
}
