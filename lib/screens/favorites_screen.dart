import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;
import '../widgets/common.dart';
import '../widgets/stripe_box.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favItems = seed.items.where((i) => state.favs.contains(i.id)).toList();
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
                  Text('Saved', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 8),
                  Text('${favItems.length}', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 15, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ),
          Expanded(
            child: favItems.isEmpty
                ? Center(child: Text('No saved items yet', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 15)))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                    children: favItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () { state.itemId = item.id; state.gallery = 0; state.go('item'); },
                          child: Container(
                            decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(AppTokens.cardRadius), border: Border.all(color: AppTokens.border), boxShadow: [AppTokens.cardShadow]),
                            clipBehavior: Clip.antiAlias,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Stack(children: [
                                StripeBox(colorA: item.sa, colorB: item.sb, height: 150, width: double.infinity),
                                Positioned(top: 12, right: 12, child: GestureDetector(
                                  onTap: () => state.toggleFav(item.id),
                                  child: Container(width: 36, height: 36, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.favorite, color: AppTokens.like, size: 18)),
                                )),
                              ]),
                              Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(item.name, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 16, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 4),
                                  Text(item.owner, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    const Icon(Icons.star, size: 14, color: AppTokens.gold),
                                    const SizedBox(width: 4),
                                    Text('${item.rating} · ${item.distance}', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 13, fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    Text('\$${item.price}', style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 17, fontWeight: FontWeight.w800)),
                                    Text('/day', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11)),
                                  ]),
                                ]),
                              ),
                            ]),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
