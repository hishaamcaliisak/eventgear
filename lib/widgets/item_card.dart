import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/models.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import 'stripe_box.dart';

IconData itemIcon(String cat) {
  switch (cat) {
    case 'tents': return Icons.holiday_village_outlined;
    case 'furniture': return Icons.chair_outlined;
    case 'lighting': return Icons.lightbulb_outline;
    case 'audio': return Icons.speaker_outlined;
    case 'decor': return Icons.local_florist_outlined;
    case 'catering': return Icons.restaurant_outlined;
    default: return Icons.inventory_2_outlined;
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fav = state.favs.contains(item.id);
    return GestureDetector(
      onTap: () { state.itemId = item.id; state.gallery = 0; state.go('item'); },
      child: Container(
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.cardRadius),
          border: Border.all(color: AppTokens.border),
          boxShadow: [AppTokens.cardShadow],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Stripe image with icon
            SizedBox(
              width: 112, height: 112,
              child: Stack(
                children: [
                  StripeBox(colorA: item.sa, colorB: item.sb, width: 112, height: 112),
                  // Icon centered
                  Center(
                    child: Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.80),
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Icon(itemIcon(item.cat), size: 24, color: AppTokens.ink),
                    ),
                  ),
                  // Code chip
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(6)),
                      child: Text(item.code, style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppTokens.ink, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15, fontWeight: FontWeight.w700, height: 1.15)),
                        ),
                        GestureDetector(
                          onTap: () => state.toggleFav(item.id),
                          child: Icon(fav ? Icons.favorite : Icons.favorite_border, size: 19, color: fav ? AppTokens.like : AppTokens.likeIdle),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(item.owner, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppTokens.gold),
                        const SizedBox(width: 3),
                        Text('${item.rating}', style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 12.5, fontWeight: FontWeight.w700)),
                        Text(' · ${item.distance}', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                        const Spacer(),
                        Text('\$${item.price}', style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 16, fontWeight: FontWeight.w800)),
                        Text('/day', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
