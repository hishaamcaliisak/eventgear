import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../data/models.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;
import '../widgets/stripe_box.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'active': return AppTokens.brand;
      case 'pickup_pending': return AppTokens.gold;
      case 'upcoming': return AppTokens.gold;
      default: return AppTokens.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final myBookings = state.bookings.reversed.toList();
    return Container(
      color: AppTokens.bg,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Column(children: [
                Text('Your Bookings', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                if (state.bookings.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('${state.bookings.length} rental${state.bookings.length == 1 ? '' : 's'}',
                    style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                ],
              ]),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                // ── My real bookings ─────────────────────────────────────────
                if (myBookings.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('MY BOOKINGS',
                      style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                  ),
                  ...myBookings.map((b) => _bookingCard(context, state, b)),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('PREVIOUS RENTALS',
                      style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                  ),
                ],
                // ── Seed demo entries ────────────────────────────────────────
                ...seed.history.map((h) {
                  final sc = _statusColor(h.status);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(AppTokens.cardRadius), border: Border.all(color: AppTokens.border), boxShadow: [AppTokens.cardShadow]),
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          StripeBox(colorA: h.sa, colorB: h.sb, width: 56, height: 56, borderRadius: BorderRadius.circular(13),
                            child: Align(alignment: Alignment.topLeft, child: Padding(padding: const EdgeInsets.all(6), child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(5)),
                              child: Text(h.code, style: GoogleFonts.jetBrainsMono(fontSize: 8.5, color: AppTokens.ink, fontWeight: FontWeight.w700)))))),
                          const SizedBox(width: 13),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(h.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text(h.owner, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                          ])),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                            child: Text(h.statusLabel, style: GoogleFonts.hankenGrotesk(color: sc, fontSize: 11.5, fontWeight: FontWeight.w700)),
                          ),
                        ]),
                        const SizedBox(height: 13),
                        const Divider(color: AppTokens.divider, height: 1),
                        const SizedBox(height: 11),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(children: [
                            const Icon(Icons.calendar_today_outlined, size: 14, color: AppTokens.textMuted),
                            const SizedBox(width: 6),
                            Text(h.dates, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 12.5, fontWeight: FontWeight.w600)),
                          ]),
                          Text(h.total, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15, fontWeight: FontWeight.w800)),
                        ]),
                      ]),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingCard(BuildContext context, AppState state, Booking b) {
    final sc = _statusColor(b.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTokens.surface,
          borderRadius: BorderRadius.circular(AppTokens.cardRadius),
          border: Border.all(color: b.status == 'active' ? AppTokens.brand : AppTokens.border, width: b.status == 'active' ? 1.5 : 1),
          boxShadow: [AppTokens.cardShadow],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            StripeBox(colorA: b.sa, colorB: b.sb, width: 56, height: 56, borderRadius: BorderRadius.circular(13),
              child: Align(alignment: Alignment.topLeft, child: Padding(padding: const EdgeInsets.all(6), child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), borderRadius: BorderRadius.circular(5)),
                child: Text(b.itemCode, style: GoogleFonts.jetBrainsMono(fontSize: 8.5, color: AppTokens.ink, fontWeight: FontWeight.w700)))))),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b.itemName, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(b.ownerName, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(b.statusLabel, style: GoogleFonts.hankenGrotesk(color: sc, fontSize: 11.5, fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 13),
          const Divider(color: AppTokens.divider, height: 1),
          const SizedBox(height: 11),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppTokens.textMuted),
              const SizedBox(width: 6),
              Text(b.datesStr, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ]),
            Text(b.total, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15, fontWeight: FontWeight.w800)),
          ]),
          // Action buttons
          if (b.status == 'pickup_pending') ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                state.itemId = b.itemId;
                state.activeBookingId = b.id;
                state.checkTab = 'pickup';
                state.checks = {};
                state.bump();
                state.go('checklist');
              },
              child: Container(
                height: 40, alignment: Alignment.center,
                decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTokens.brand)),
                child: Text('Go to pickup checklist', style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 13.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
          if (b.status == 'active') ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => state.startReturn(b.id),
              child: Container(
                height: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTokens.brand,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: AppTokens.brand.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Text('Start return checklist', style: GoogleFonts.archivo(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
          if (b.status == 'returned') ...[
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.check_circle, color: AppTokens.brandBright, size: 16),
              const SizedBox(width: 6),
              Text('Returned — deposit releasing', style: GoogleFonts.hankenGrotesk(color: AppTokens.brandBright, fontSize: 12.5, fontWeight: FontWeight.w600)),
            ]),
          ],
        ]),
      ),
    );
  }
}
