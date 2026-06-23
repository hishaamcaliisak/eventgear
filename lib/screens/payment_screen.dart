import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const methods = [
    ['card1', 'Visa ·· 4821', 'Expires 09/27'],
    ['card2', 'Mastercard ·· 6390', 'Expires 02/28'],
    ['apple', 'Apple Pay', 'Touch to confirm'],
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final item = state.currentItem;
    return Container(
      color: AppTokens.bg,
      child: Column(
        children: [
          SlimHeader(title: 'Payment', onBack: () => state.back()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                Text('Payment method', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ...methods.map((m) {
                  final sel = state.payMethod == m[0];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () { state.payMethod = m[0]; state.bump(); },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: sel ? AppTokens.brandTint : AppTokens.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: sel ? AppTokens.brand : AppTokens.border),
                        ),
                        child: Row(children: [
                          Container(width: 42, height: 30, decoration: BoxDecoration(color: AppTokens.ink, borderRadius: BorderRadius.circular(7)), alignment: Alignment.center,
                            child: const Icon(Icons.credit_card, color: Colors.white, size: 16)),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(m[1], style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                            Text(m[2], style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                          ])),
                          Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sel ? AppTokens.brand : AppTokens.likeIdle, width: 2)),
                            child: sel ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTokens.brand, shape: BoxShape.circle))) : null),
                        ]),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 18),
                Text('Price breakdown', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    _row('\$${item.price} × ${state.qty} × ${state.rentalDays} day${state.rentalDays == 1 ? '' : 's'}', state.formatPrice(state.subtotal)),
                    if (state.deliveryFee > 0) _row('Delivery & collection', state.formatPrice(state.deliveryFee)),
                    if (state.protectionFee > 0) _row('Damage protection', state.formatPrice(state.protectionFee)),
                    _row('Service fee', state.formatPrice(state.serviceFee)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(color: AppTokens.divider)),
                    _row('Order total', state.formatPrice(state.orderTotal), bold: true),
                  ]),
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(gradient: AppTokens.homeHeaderGradient, borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(18),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const MonoLabel('REFUNDABLE DEPOSIT', color: AppTokens.brandMint, spacing: 1.4),
                      const SizedBox(height: 6),
                      Text('Held, not charged', style: GoogleFonts.archivo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text('Released within 1–2 days of return', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 12.5)),
                    ])),
                    Text(state.formatPrice(item.deposit), style: GoogleFonts.archivo(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  ]),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppTokens.surface, border: const Border(top: BorderSide(color: AppTokens.border)), boxShadow: [AppTokens.bottomBarShadow]),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const MonoLabel('CHARGED TODAY'),
                Text(state.formatPrice(state.dueToday), style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 22, fontWeight: FontWeight.w800)),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () { state.addBooking(); state.go('confirmed'); },
                child: Container(
                  height: AppTokens.btnHeight, padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(AppTokens.btnRadius)),
                  alignment: Alignment.center,
                  child: Text('Confirm & pay', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: GoogleFonts.hankenGrotesk(color: bold ? AppTokens.ink : AppTokens.textMuted2, fontSize: bold ? 15 : 13.5, fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
        Text(value, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: bold ? 16 : 13.5, fontWeight: bold ? FontWeight.w800 : FontWeight.w700)),
      ]),
    );
  }
}
