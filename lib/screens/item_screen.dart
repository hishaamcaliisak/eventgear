import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';
import '../widgets/stripe_box.dart';
import '../widgets/item_card.dart' show itemIcon;

IconData _catIcon(String cat) => itemIcon(cat);

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final item = state.currentItem;
    final fav = state.favs.contains(item.id);
    return Container(
      color: AppTokens.bg,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              // Hero
              Stack(
                children: [
                  StripeBox(colorA: item.sa, colorB: item.sb, height: 320, width: double.infinity),
                  // Large centered icon
                  Positioned.fill(child: Center(child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.75), borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 20, offset: const Offset(0, 4))]),
                    child: Icon(_catIcon(item.cat), size: 40, color: AppTokens.ink),
                  ))),
                  Positioned(
                    left: 0, right: 0, bottom: 28,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (i) => Container(
                        width: i == state.gallery ? 22 : 7, height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(color: i == state.gallery ? AppTokens.ink : Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(4)),
                      )),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -22),
                child: Container(
                  decoration: const BoxDecoration(color: AppTokens.bg, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(spacing: 8, runSpacing: 8, children: item.tags.map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                        decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(8)),
                        child: Text(t, style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 11.5, fontWeight: FontWeight.w700)),
                      )).toList()),
                      const SizedBox(height: 14),
                      Text(item.name, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 24, fontWeight: FontWeight.w800, height: 1.12, letterSpacing: -0.5)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTokens.ink, borderRadius: BorderRadius.circular(11)), alignment: Alignment.center,
                            child: Text(item.owner.substring(0, 1), style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item.owner, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w700)),
                            Row(children: [
                              const Icon(Icons.star, size: 13, color: AppTokens.gold),
                              const SizedBox(width: 3),
                              Text('${item.rating} · ${item.reviews} reviews', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                            ]),
                          ])),
                          GestureDetector(
                            onTap: () { state.chatId = item.ownerId; state.go('chat'); },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(11), border: Border.all(color: AppTokens.border)),
                              child: Text('Message', style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(children: [
                        _stat('\$${item.price}', 'per day'),
                        const SizedBox(width: 10),
                        _stat('\$${item.deposit}', 'deposit'),
                        const SizedBox(width: 10),
                        _stat('${item.qty}', 'available'),
                      ]),
                      const SizedBox(height: 22),
                      Text('About this listing', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(item.desc, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 14.5, height: 1.55)),
                      const SizedBox(height: 22),
                      Text('Specifications', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                        child: Column(
                          children: [
                            for (int i = 0; i < item.specs.length; i++)
                              Container(
                                decoration: BoxDecoration(border: i == 0 ? null : const Border(top: BorderSide(color: AppTokens.divider))),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(item.specs[i][0], style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 13.5)),
                                  Text(item.specs[i][1], style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 13.5, fontWeight: FontWeight.w700)),
                                ]),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      GestureDetector(
                        onTap: () => state.go('reviews'),
                        child: Container(
                          decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                          padding: const EdgeInsets.all(16),
                          child: Row(children: [
                            Text('${item.rating}', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 30, fontWeight: FontWeight.w800)),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('★★★★★', style: GoogleFonts.hankenGrotesk(color: AppTokens.gold, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text('${item.reviews} verified reviews', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 13)),
                            ])),
                            const Icon(Icons.chevron_right, color: AppTokens.textMuted),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Overlays
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(onTap: () => state.back()),
                  CircleIconButton(
                    icon: fav ? Icons.favorite : Icons.favorite_border,
                    iconColor: fav ? AppTokens.like : AppTokens.ink,
                    onTap: () => state.toggleFav(item.id),
                  ),
                ],
              ),
            ),
          ),
          // Sticky bottom bar
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Container(
              decoration: BoxDecoration(color: AppTokens.surface, border: const Border(top: BorderSide(color: AppTokens.border)), boxShadow: [AppTokens.bottomBarShadow]),
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              child: Row(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('\$${item.price}', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 22, fontWeight: FontWeight.w800)),
                      Text(' /day', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 13)),
                    ]),
                    Text('+ \$${item.deposit} deposit', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12)),
                  ]),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => state.go('calendar'),
                    child: Container(
                      height: AppTokens.btnHeight, padding: const EdgeInsets.symmetric(horizontal: 36),
                      decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(AppTokens.btnRadius), boxShadow: [BoxShadow(color: AppTokens.brand.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8))]),
                      alignment: Alignment.center,
                      child: Text('Check dates', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
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

  Widget _stat(String big, String small) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTokens.border)),
        child: Column(children: [
          Text(big, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(small, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11.5)),
        ]),
      ),
    );
  }
}
