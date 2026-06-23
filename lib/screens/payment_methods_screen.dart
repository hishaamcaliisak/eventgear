import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});
  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selected = 'card1';

  final _cards = const [
    {'id': 'card1', 'label': 'Visa', 'last4': '4821', 'exp': '09/27', 'color': Color(0xFF1A56A0)},
    {'id': 'card2', 'label': 'Mastercard', 'last4': '6390', 'exp': '02/28', 'color': Color(0xFF9C1B1B)},
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Container(
      color: AppTokens.bg,
      child: Column(children: [
        SlimHeader(title: 'Payment methods', onBack: () => state.back()),
        Expanded(child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            Text('SAVED CARDS', style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ..._cards.map((c) {
              final sel = _selected == c['id'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selected = c['id'] as String),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTokens.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: sel ? AppTokens.brand : AppTokens.border, width: sel ? 1.5 : 1),
                      boxShadow: [AppTokens.cardShadow],
                    ),
                    child: Row(children: [
                      Container(
                        width: 48, height: 32,
                        decoration: BoxDecoration(color: c['color'] as Color, borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: Text(c['label'] as String, style: GoogleFonts.archivo(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${c['label']} •••• ${c['last4']}', style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                        Text('Expires ${c['exp']}', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                      ])),
                      Container(width: 20, height: 20,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sel ? AppTokens.brand : AppTokens.likeIdle, width: 2)),
                        child: sel ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTokens.brand, shape: BoxShape.circle))) : null),
                    ]),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => state.flashToast('Add card coming soon'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTokens.brandTint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTokens.brand, width: 1.5),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.add, color: AppTokens.brand, size: 20),
                  const SizedBox(width: 8),
                  Text('Add new card', style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 15, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
            const SizedBox(height: 28),
            Text('OTHER METHODS', style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _methodRow(Icons.phone_iphone, 'Apple Pay', 'Touch to confirm'),
            _methodRow(Icons.account_balance_outlined, 'Bank transfer', 'BSB & account number'),
          ],
        )),
      ]),
    );
  }

  Widget _methodRow(IconData icon, String title, String sub) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTokens.border)),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(11)),
        child: Icon(icon, color: AppTokens.textMuted2, size: 20)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
        Text(sub, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
      ])),
      const Icon(Icons.chevron_right, color: AppTokens.textMuted, size: 20),
    ]),
  );
}
