import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _expanded;

  static const _faqs = [
    ['How does the booking process work?', 'Browse gear, select your dates on the calendar, review your order, then pay. The supplier is notified and confirms within a few hours. You\'ll get a pickup checklist to complete on collection day.'],
    ['Can I cancel a booking?', 'Cancellations made 48+ hours before pickup receive a full refund minus the service fee. Within 48 hours, the hire fee is non-refundable but the deposit is always returned after inspection.'],
    ['How is the deposit handled?', 'Your deposit is held — not charged — at booking. It\'s released back to your card within 1–2 business days after the return checklist is signed off by both parties.'],
    ['What does damage protection cover?', 'Our damage protection covers accidental damage during the hire period up to the full deposit value. It does not cover theft, intentional damage, or loss. It costs ~9% of your hire subtotal.'],
    ['Can I extend my hire dates?', 'Contact your supplier directly via the Inbox to request an extension. If the gear is available, they can update the booking. Additional days are charged at the same daily rate.'],
    ['What if an item is different from the listing?', 'Complete the pickup checklist carefully and note any discrepancies. If the item is significantly different, contact support within 24 hours of pickup with photos for a full review.'],
    ['How do I become a supplier?', 'Tap "List your own gear" in your profile. You\'ll be guided through adding your equipment, setting pricing, and managing availability.'],
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Container(
      color: AppTokens.bg,
      child: Column(children: [
        SlimHeader(title: 'Help & support', onBack: () => state.back()),
        Expanded(child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            // Contact cards
            Row(children: [
              Expanded(child: _contactCard(Icons.chat_bubble_outline, 'Live chat', 'Avg. 2 min reply', () => state.go('ai_chat'))),
              const SizedBox(width: 12),
              Expanded(child: _contactCard(Icons.mail_outline, 'Email us', 'support@eventgear.co', () => state.flashToast('Email support opening...'))),
            ]),
            const SizedBox(height: 28),

            Text('FREQUENTLY ASKED', style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
              child: Column(children: [
                for (int i = 0; i < _faqs.length; i++) ...[
                  if (i > 0) const Divider(color: AppTokens.divider, height: 1),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = _expanded == i ? null : i),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(_faqs[i][0],
                            style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700))),
                          Icon(_expanded == i ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppTokens.textMuted, size: 20),
                        ]),
                        if (_expanded == i) ...[
                          const SizedBox(height: 10),
                          Text(_faqs[i][1],
                            style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 13.5, height: 1.55)),
                        ],
                      ]),
                    ),
                  ),
                ],
              ]),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppTokens.homeHeaderGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Still need help?', style: GoogleFonts.archivo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Our team is available Mon–Fri, 8am–6pm.', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.75), fontSize: 13)),
                ])),
                GestureDetector(
                  onTap: () => state.go('ai_chat'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(color: AppTokens.brandBright, borderRadius: BorderRadius.circular(10)),
                    child: Text('Chat now', style: GoogleFonts.archivo(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700)),
                  ),
                ),
              ]),
            ),
          ],
        )),
      ]),
    );
  }

  Widget _contactCard(IconData icon, String title, String sub, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border), boxShadow: [AppTokens.cardShadow]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppTokens.brand, size: 20)),
        const SizedBox(height: 12),
        Text(title, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(sub, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 12)),
      ]),
    ),
  );
}
