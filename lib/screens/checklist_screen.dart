import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final list = state.currentChecklist;
    final progress = list.isEmpty ? 0.0 : state.doneCount / list.length;
    final booking = state.activeBooking;
    final isReturn = state.checkTab == 'return';

    return Container(
      color: AppTokens.bg,
      child: Column(
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
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Handover checklist', style: GoogleFonts.archivo(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                        if (booking != null) ...[
                          const SizedBox(height: 2),
                          Text(booking.itemName, style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 12.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ])),
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      SizedBox(
                        width: 64, height: 64,
                        child: Stack(alignment: Alignment.center, children: [
                          SizedBox(width: 64, height: 64, child: CircularProgressIndicator(value: progress, strokeWidth: 6, backgroundColor: Colors.white.withOpacity(0.15), color: AppTokens.brandMint)),
                          Text('${(progress * 100).round()}%', style: GoogleFonts.archivo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                        ]),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${state.doneCount} of ${list.length} done', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text(isReturn ? 'Complete each step at return' : 'Complete each step at pickup',
                          style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                      ])),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          // Tab toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(13)),
              child: Row(children: [
                _tab(state, 'pickup', 'Pickup'),
                _tab(state, 'return', 'Return'),
              ]),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              children: list.map((c) {
                final done = state.checks[c.key] == true;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => state.toggleCheck(c.key),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: done ? AppTokens.brandTint : AppTokens.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: done ? AppTokens.brand : AppTokens.border),
                      ),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 24, height: 24, margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            color: done ? AppTokens.brand : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: done ? AppTokens.brand : AppTokens.likeIdle, width: 2),
                          ),
                          child: done ? const Icon(Icons.check, color: Colors.white, size: 15) : null,
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(c.title, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text(c.desc, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                        ])),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppTokens.surface, border: const Border(top: BorderSide(color: AppTokens.border)), boxShadow: [AppTokens.bottomBarShadow]),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
            child: GestureDetector(
              onTap: () {
                if (!state.allChecked) {
                  state.flashToast('Complete all steps to continue.');
                  return;
                }
                if (isReturn) {
                  state.confirmReturn();
                  state.flashToast('Return complete — deposit releasing soon.');
                  state.setTab('bookings', 'history');
                } else {
                  state.confirmPickup();
                  state.flashToast('Pickup confirmed — enjoy your event!');
                  state.setTab('bookings', 'history');
                }
              },
              child: Container(
                height: AppTokens.btnHeight,
                decoration: BoxDecoration(
                  color: state.allChecked ? AppTokens.brand : AppTokens.likeIdle,
                  borderRadius: BorderRadius.circular(AppTokens.btnRadius),
                ),
                alignment: Alignment.center,
                child: Text(
                  isReturn ? 'Confirm return' : 'Confirm pickup',
                  style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(AppState state, String value, String label) {
    final sel = state.checkTab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () { state.checkTab = value; state.checks = {}; state.bump(); },
        child: Container(
          height: 40, alignment: Alignment.center,
          decoration: BoxDecoration(
            color: sel ? AppTokens.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: sel ? [AppTokens.cardShadow] : null,
          ),
          child: Text(label, style: GoogleFonts.hankenGrotesk(color: sel ? AppTokens.ink : AppTokens.textMuted, fontSize: 14, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
