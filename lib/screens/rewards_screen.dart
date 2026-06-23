import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  static const perks = [
    ['Priority delivery slots', 'Skip the queue on weekends', true],
    ['Reduced service fees', '3% instead of 6% on every hire', true],
    ['Free damage protection', 'Auto-applied on Pro listings', false],
    ['Dedicated account manager', 'Unlocks at Platinum tier', false],
  ];

  static const activity = [
    ['+120 pts', 'Clearspan Marquee booking', 'Jun 22'],
    ['+45 pts', 'Festoon Lighting booking', 'Jun 11'],
    ['+200 pts', 'Referral bonus · Marcus T.', 'May 28'],
    ['+64 pts', 'Chiavari Chairs returned', 'May 4'],
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      color: AppTokens.bg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppTokens.homeHeaderGradient),
            child: Stack(children: [
              const DiagonalStripes(opacity: 0.03),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleIconButton(bg: Colors.white.withOpacity(0.1), iconColor: Colors.white, onTap: () => state.back()),
                        const SizedBox(width: 14),
                        Text('Rewards', style: GoogleFonts.archivo(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                      ]),
                      const SizedBox(height: 22),
                      const MonoLabel('GOLD TIER · 2,140 PTS', color: AppTokens.gold, spacing: 1.6),
                      const SizedBox(height: 8),
                      Text('860 pts to Platinum', style: GoogleFonts.archivo(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 14),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(value: 2140 / 3000, minHeight: 10, backgroundColor: Colors.white.withOpacity(0.15), color: AppTokens.gold),
                      ),
                      const SizedBox(height: 8),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Gold', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                        Text('Platinum · 3,000', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Text('Your perks', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 17, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          ...perks.map((p) {
            final active = p[2] as bool;
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Container(
                decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTokens.border)),
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Container(width: 38, height: 38, decoration: BoxDecoration(color: active ? AppTokens.brandTint : AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(11)),
                    child: Icon(active ? Icons.check : Icons.lock_outline, color: active ? AppTokens.brand : AppTokens.textMuted, size: 18)),
                  const SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p[0] as String, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                    Text(p[1] as String, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                  ])),
                ]),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text('Recent activity', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 17, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
              child: Column(children: [
                for (int i = 0; i < activity.length; i++)
                  Container(
                    decoration: BoxDecoration(border: i == 0 ? null : const Border(top: BorderSide(color: AppTokens.divider))),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(activity[i][1], style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 13.5, fontWeight: FontWeight.w600)),
                        Text(activity[i][2], style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12)),
                      ])),
                      Text(activity[i][0], style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 14, fontWeight: FontWeight.w800)),
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
