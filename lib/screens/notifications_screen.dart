import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final Map<String, bool> _prefs = {
    'booking_confirmed': true,
    'booking_reminder': true,
    'supplier_message': true,
    'pickup_reminder': true,
    'return_reminder': true,
    'deposit_release': true,
    'promo_deals': false,
    'new_listings': false,
    'weekly_digest': false,
  };

  static const _sections = [
    {
      'title': 'BOOKINGS',
      'items': [
        {'key': 'booking_confirmed', 'label': 'Booking confirmed', 'sub': 'When a supplier accepts your request'},
        {'key': 'booking_reminder', 'label': 'Booking reminders', 'sub': '24 hours before pickup'},
        {'key': 'pickup_reminder', 'label': 'Pickup reminders', 'sub': 'Morning of pickup day'},
        {'key': 'return_reminder', 'label': 'Return reminders', 'sub': 'Day before return is due'},
        {'key': 'deposit_release', 'label': 'Deposit released', 'sub': 'When deposit is returned to you'},
      ],
    },
    {
      'title': 'MESSAGES',
      'items': [
        {'key': 'supplier_message', 'label': 'Supplier messages', 'sub': 'When a supplier sends you a message'},
      ],
    },
    {
      'title': 'PROMOTIONS',
      'items': [
        {'key': 'promo_deals', 'label': 'Deals & discounts', 'sub': 'Limited-time offers from suppliers'},
        {'key': 'new_listings', 'label': 'New listings', 'sub': 'New gear matching your interests'},
        {'key': 'weekly_digest', 'label': 'Weekly digest', 'sub': 'Summary of activity each Monday'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Container(
      color: AppTokens.bg,
      child: Column(children: [
        SlimHeader(title: 'Notifications', onBack: () => state.back()),
        Expanded(child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            for (final section in _sections) ...[
              Text(section['title'] as String, style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                child: Column(children: [
                  for (int i = 0; i < (section['items'] as List).length; i++) ...[
                    if (i > 0) const Divider(color: AppTokens.divider, height: 1, indent: 16, endIndent: 16),
                    _ToggleRow(
                      label: (section['items'] as List)[i]['label'] as String,
                      sub: (section['items'] as List)[i]['sub'] as String,
                      value: _prefs[(section['items'] as List)[i]['key']] ?? false,
                      onChanged: (v) => setState(() => _prefs[(section['items'] as List)[i]['key'] as String] = v),
                    ),
                  ],
                ]),
              ),
              const SizedBox(height: 20),
            ],
          ],
        )),
      ]),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label, sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.label, required this.sub, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(sub, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12.5)),
      ])),
      Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTokens.brand,
        activeTrackColor: AppTokens.brandTint,
        inactiveThumbColor: AppTokens.textFaint,
        inactiveTrackColor: AppTokens.surfaceSunken,
      ),
    ]),
  );
}
