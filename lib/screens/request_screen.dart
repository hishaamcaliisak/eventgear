import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/stripe_box.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final item = state.currentItem;
    return Container(
      color: AppTokens.bg,
      child: Column(
        children: [
          Container(
            color: AppTokens.surface,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(children: [
                  CircleIconButton(onTap: () => state.back()),
                  const SizedBox(width: 14),
                  Text('Review request', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 20, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                // Item summary
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    StripeBox(colorA: item.sa, colorB: item.sb, width: 56, height: 56, borderRadius: BorderRadius.circular(12)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.name, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(item.owner, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                    ])),
                  ]),
                ),
                const SizedBox(height: 14),
                // Dates row
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const MonoLabel('RENTAL DATES'),
                      const SizedBox(height: 6),
                      Text('${state.formatDate(state.startDate)} → ${state.formatDate(state.endDate)}', style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text('${state.rentalDays} day${state.rentalDays == 1 ? '' : 's'}', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                    ])),
                    GestureDetector(onTap: () => state.go('calendar'), child: Text('Edit', style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 13.5, fontWeight: FontWeight.w700))),
                  ]),
                ),
                const SizedBox(height: 14),
                // Quantity
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Quantity', style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                      Text('${item.qty} available', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                    ])),
                    _stepBtn(Icons.remove, () { if (state.qty > 1) { state.qty--; state.bump(); } }),
                    SizedBox(width: 40, child: Center(child: Text('${state.qty}', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 18, fontWeight: FontWeight.w800)))),
                    _stepBtn(Icons.add, () { if (state.qty < item.qty) { state.qty++; state.bump(); } }),
                  ]),
                ),
                const SizedBox(height: 14),
                // Delivery method
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Delivery method', style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _radio(state, 'delivery', 'Delivery & collection', '+\$65 · crew drop-off', state.delivery == 'delivery'),
                    const SizedBox(height: 10),
                    _radio(state, 'pickup', 'Self pickup', 'Free · ${item.loc}', state.delivery == 'pickup'),
                  ]),
                ),
                const SizedBox(height: 14),
                // Protection toggle
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Damage protection', style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text('Covers accidental damage up to \$5,000', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                    ])),
                    Switch(value: state.protection, activeColor: AppTokens.brand, onChanged: (v) { state.protection = v; state.bump(); }),
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
                const MonoLabel('ORDER TOTAL'),
                Text(state.formatPrice(state.orderTotal), style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 22, fontWeight: FontWeight.w800)),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () => state.go('payment'),
                child: Container(
                  height: AppTokens.btnHeight, padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(AppTokens.btnRadius)),
                  alignment: Alignment.center,
                  child: Text('Go to payment', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(11), border: Border.all(color: AppTokens.border)),
        child: Icon(icon, size: 18, color: AppTokens.ink),
      ),
    );
  }

  Widget _radio(AppState state, String value, String title, String sub, bool sel) {
    return GestureDetector(
      onTap: () { state.delivery = value; state.bump(); },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel ? AppTokens.brandTint : AppTokens.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: sel ? AppTokens.brand : AppTokens.border),
        ),
        child: Row(children: [
          Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sel ? AppTokens.brand : AppTokens.likeIdle, width: 2)),
            child: sel ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTokens.brand, shape: BoxShape.circle))) : null),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w700)),
            Text(sub, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
          ])),
        ]),
      ),
    );
  }
}
