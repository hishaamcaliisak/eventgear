import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;
import '../widgets/common.dart';
import '../widgets/item_card.dart';
import '../widgets/stripe_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final recommended = seed.items.take(4).toList();
    return Container(
      color: AppTokens.bg,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(gradient: AppTokens.homeHeaderGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hi, ${state.userName.isNotEmpty ? state.userName.split(' ')[0] : 'Welcome'}',
                                style: GoogleFonts.archivo(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => state.setTab('profile', 'profile'),
                          child: Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: AppTokens.brandBright, borderRadius: BorderRadius.circular(13)),
                            alignment: Alignment.center,
                            child: Text(
                              state.userName.isNotEmpty
                                ? state.userName.trim().split(RegExp(r'\s+')).take(2).map((w) => w[0]).join().toUpperCase()
                                : 'EG',
                              style: GoogleFonts.archivo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: () => state.setTab('browse', 'list'),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.1))),
                        child: Row(children: [
                          Icon(Icons.search, color: Colors.white.withOpacity(0.8), size: 20),
                          const SizedBox(width: 10),
                          Text('Search marquees, lighting, staging…', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Categories
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Categories', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 18, fontWeight: FontWeight.w800)),
                GestureDetector(onTap: () => state.setTab('browse', 'list'), child: Text('See all', style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w700))),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.92,
              children: seed.cats.map((c) {
                return GestureDetector(
                  onTap: () { state.catId = c.id; state.filter = 'all'; state.search = ''; state.setTab('browse', 'list'); },
                  child: Container(
                    decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: c.tint, borderRadius: BorderRadius.circular(11), border: Border.all(color: c.line)),
                          child: Icon(itemIcon(c.id), size: 20, color: c.ink),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.15)),
                            const SizedBox(height: 2),
                            Text('${c.count} items', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Active hire card
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: GestureDetector(
              onTap: () { state.checkTab = 'pickup'; state.go('checklist'); },
              child: Container(
                decoration: BoxDecoration(gradient: AppTokens.homeHeaderGradient, borderRadius: BorderRadius.circular(AppTokens.cardRadius)),
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    StripeBox(colorA: const Color(0xFFCFE0D5), colorB: const Color(0xFFDCEBE1), width: 54, height: 54, borderRadius: BorderRadius.circular(13)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const MonoLabel('ACTIVE HIRE · PICKUP SAT', color: AppTokens.brandMint, spacing: 1.4),
                          const SizedBox(height: 5),
                          Text('Clearspan Marquee 6×12m', style: GoogleFonts.archivo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text('Jun 27 – 29 · Summit Event Hire', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 12.5)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.7)),
                  ],
                ),
              ),
            ),
          ),
          // Recommended
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
            child: Text('Recommended for you', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 14),
          ...recommended.map((i) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: ItemCard(item: i),
          )),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
