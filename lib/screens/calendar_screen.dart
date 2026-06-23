import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  static const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  static const dow = ['S','M','T','W','T','F','S'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final item = state.currentItem;
    final year = state.calYear;
    final month = state.calMonth;
    final first = DateTime(year, month + 1, 1);
    final leading = first.weekday % 7; // Sunday=0
    final daysInMonth = DateTime(year, month + 2, 0).day;

    String keyFor(int d) => '$year-${(month + 1).toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';

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
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Select dates', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 19, fontWeight: FontWeight.w800)),
                    Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
                  ])),
                ]),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                Row(children: [
                  Expanded(child: _dateField('Pick-up', state.formatDate(state.startDate))),
                  const SizedBox(width: 12),
                  Expanded(child: _dateField('Return', state.formatDate(state.endDate))),
                ]),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTokens.border)),
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      GestureDetector(onTap: () => state.shiftMonth(-1), child: const Icon(Icons.chevron_left, color: AppTokens.ink)),
                      Text('${months[month]} $year', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 16, fontWeight: FontWeight.w800)),
                      GestureDetector(onTap: () => state.shiftMonth(1), child: const Icon(Icons.chevron_right, color: AppTokens.ink)),
                    ]),
                    const SizedBox(height: 14),
                    Row(children: dow.map((d) => Expanded(child: Center(child: Text(d, style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 11, fontWeight: FontWeight.w600))))).toList()),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 7, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 4, crossAxisSpacing: 4, childAspectRatio: 1,
                      children: [
                        ...List.generate(leading, (_) => const SizedBox()),
                        ...List.generate(daysInMonth, (i) {
                          final d = i + 1;
                          final k = keyFor(d);
                          final isPast = k.compareTo(AppState.today) < 0;
                          final booked = state.isDayBooked(d);
                          final disabled = isPast || booked;
                          final isStart = k == state.startDate;
                          final isEnd = k == state.endDate;
                          final inRange = state.startDate != null && state.endDate != null && k.compareTo(state.startDate!) > 0 && k.compareTo(state.endDate!) < 0;
                          Color bg = Colors.transparent;
                          Color fg = disabled ? AppTokens.textFaint : AppTokens.ink;
                          if (booked && !isPast) { bg = AppTokens.booked; fg = AppTokens.like.withOpacity(0.7); }
                          if (inRange) { bg = const Color(0xFFDCEAE2); fg = AppTokens.brand; }
                          if (isStart || isEnd) { bg = AppTokens.brand; fg = Colors.white; }
                          return GestureDetector(
                            onTap: disabled ? null : () => state.pickDay(year, month + 1, d),
                            child: Container(
                              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Stack(alignment: Alignment.center, children: [
                                Text('$d', style: GoogleFonts.hankenGrotesk(
                                  color: fg, fontSize: 13.5,
                                  fontWeight: (isStart || isEnd) ? FontWeight.w800 : FontWeight.w600,
                                  decoration: isPast ? TextDecoration.lineThrough : null,
                                  decorationColor: AppTokens.textFaint,
                                )),
                                if (booked && !isPast)
                                  Positioned(bottom: 3, child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppTokens.booked, shape: BoxShape.circle))),
                              ]),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(children: [
                      _legend(AppTokens.brand, 'Selected'),
                      const SizedBox(width: 18),
                      _legend(AppTokens.brandTint, 'In range'),
                      const SizedBox(width: 18),
                      _legend(AppTokens.booked, 'Booked'),
                    ]),
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
                Text(state.rentalDays == 0 ? 'No dates' : '${state.rentalDays} day${state.rentalDays == 1 ? '' : 's'}', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 18, fontWeight: FontWeight.w800)),
                Text(state.formatPrice(state.subtotal), style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: state.startDate == null ? null : () => state.go('request'),
                child: Opacity(
                  opacity: state.startDate == null ? 0.4 : 1,
                  child: Container(
                    height: AppTokens.btnHeight, padding: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(AppTokens.btnRadius)),
                    alignment: Alignment.center,
                    child: Text('Continue', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTokens.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(), style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10, letterSpacing: 1.2)),
        const SizedBox(height: 6),
        Text(value, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _legend(Color c, String label) {
    return Row(children: [
      Container(width: 14, height: 14, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(5))),
      const SizedBox(width: 6),
      Text(label, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12)),
    ]);
  }
}
