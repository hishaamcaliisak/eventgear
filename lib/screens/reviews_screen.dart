import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;
import '../widgets/common.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final item = state.currentItem;
    const breakdown = [5, 4, 3, 2, 1];
    const pct = [0.78, 0.16, 0.04, 0.01, 0.01];
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
                  Text('Reviews', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 20, fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(children: [
                        Text('${item.rating}', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 44, fontWeight: FontWeight.w800)),
                        Text('★★★★★', style: GoogleFonts.hankenGrotesk(color: AppTokens.gold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text('${item.reviews}', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12)),
                      ]),
                      const SizedBox(width: 22),
                      Expanded(child: Column(children: List.generate(5, (i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(children: [
                          Text('${breakdown[i]}', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct[i], minHeight: 7, backgroundColor: AppTokens.surfaceSunken, color: AppTokens.brand))),
                        ]),
                      )))),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                ...seed.reviews.map((r) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(width: 38, height: 38, decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(11)), alignment: Alignment.center,
                          child: Text(r.initials, style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w700))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(r.author, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w700)),
                          Text(r.co, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12)),
                        ])),
                        Text(r.date, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11.5)),
                      ]),
                      const SizedBox(height: 10),
                      Text(r.starsStr, style: GoogleFonts.hankenGrotesk(color: AppTokens.gold, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(r.text, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 14, height: 1.5)),
                      const SizedBox(height: 10),
                      Row(children: [
                        const Icon(Icons.thumb_up_outlined, size: 14, color: AppTokens.textMuted),
                        const SizedBox(width: 6),
                        Text('Helpful (${r.helpful})', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5, fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
