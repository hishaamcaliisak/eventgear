import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;
import '../widgets/common.dart';
import '../widgets/stripe_box.dart';

class OwnerScreen extends StatelessWidget {
  const OwnerScreen({super.key});

  static const stats = [
    ['\$3,420', 'This month'],
    ['8', 'Active hires'],
    ['4.9', 'Avg rating'],
    ['96%', 'Response rate'],
  ];

  static const pending = [
    ['Priya M.', 'Clearspan Marquee 6×12m', 'Jul 4 – Jul 6 · 3 days', '\$1,240'],
    ['Daniel O.', 'Commercial Patio Heater ×4', 'Jun 28 – Jun 29 · 2 days', '\$240'],
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final listings = seed.items.where((i) => i.ownerId == 'summit').toList();
    return Container(
      color: AppTokens.bg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppTokens.homeHeaderGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      CircleIconButton(bg: Colors.white.withOpacity(0.1), iconColor: Colors.white, onTap: () => state.back()),
                      const SizedBox(width: 14),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Owner dashboard', style: GoogleFonts.archivo(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                        Text('Summit Event Hire', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                      ]),
                    ]),
                    const SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.4,
                      children: stats.map((s) => Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.12))),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(s[0], style: GoogleFonts.archivo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                          Text(s[1], style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                        ]),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Pending requests
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Text('Pending requests', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 17, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          ...pending.map((p) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Container(
              decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border), boxShadow: [AppTokens.cardShadow]),
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center,
                    child: Text(p[0].split(' ').map((w) => w[0]).take(2).join(), style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w700))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p[0], style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w700)),
                    Text(p[1], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                  ])),
                  Text(p[3], style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 10),
                Text(p[2], style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 12.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: GestureDetector(
                    onTap: () => state.flashToast('Request approved'),
                    child: Container(height: 44, alignment: Alignment.center, decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(12)),
                      child: Text('Approve', style: GoogleFonts.archivo(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))),
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: GestureDetector(
                    onTap: () => state.flashToast('Request declined'),
                    child: Container(height: 44, alignment: Alignment.center, decoration: BoxDecoration(color: AppTokens.dangerTint, borderRadius: BorderRadius.circular(12)),
                      child: Text('Decline', style: GoogleFonts.archivo(color: AppTokens.like, fontSize: 14, fontWeight: FontWeight.w700))),
                  )),
                ]),
              ]),
            ),
          )),
          // Listings
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text('Your listings', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 17, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
              child: Column(children: [
                for (int i = 0; i < listings.length; i++)
                  Container(
                    decoration: BoxDecoration(border: i == 0 ? null : const Border(top: BorderSide(color: AppTokens.divider))),
                    padding: const EdgeInsets.all(14),
                    child: Row(children: [
                      StripeBox(colorA: listings[i].sa, colorB: listings[i].sb, width: 46, height: 46, borderRadius: BorderRadius.circular(11)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(listings[i].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w700)),
                        Text('\$${listings[i].price}/day · ${listings[i].qty} in stock', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                      ])),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(7)),
                        child: Text('Live', style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 11, fontWeight: FontWeight.w700))),
                    ]),
                  ),
              ]),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
