import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'EG';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length.clamp(1, 2)).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final name    = state.userName.isNotEmpty  ? state.userName    : 'Guest User';
    final email   = state.userEmail.isNotEmpty ? state.userEmail   : 'Not signed in';
    final company = state.userCompany.isNotEmpty ? state.userCompany : '';
    final initials = _initials(name);

    final settings = [
      ['Saved items',      Icons.favorite_border,            () => state.go('favorites')],
      ['Rewards & points', Icons.workspace_premium_outlined, () => state.go('rewards')],
      ['Payment methods',  Icons.credit_card,                () => state.go('payment_methods')],
      ['Notifications',    Icons.notifications_none,         () => state.go('notifications')],
      ['Help & support',   Icons.help_outline,               () => state.go('help')],
      ['Sign out',         Icons.logout,                     () => state.setTab('home', 'welcome')],
    ];

    return Scaffold(
      backgroundColor: AppTokens.bg,
      drawer: _HowItWorksDrawer(),
      body: Builder(builder: (ctx) => Container(
        color: AppTokens.bg,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(gradient: AppTokens.profileGradient),
              child: Stack(children: [
                const DiagonalStripes(opacity: 0.03),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Column(children: [
                      // Top row: drawer button + centered title
                      Stack(alignment: Alignment.center, children: [
                        Text('Profile', style: GoogleFonts.archivo(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                        Align(alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () => Scaffold.of(ctx).openDrawer(),
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(11), border: Border.all(color: Colors.white.withOpacity(0.15))),
                              child: const Icon(Icons.menu_rounded, color: Colors.white, size: 18),
                            ),
                          )),
                      ]),
                      const SizedBox(height: 20),
                      // Avatar row
                      Row(children: [
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(color: AppTokens.brandBright, borderRadius: BorderRadius.circular(18)),
                          alignment: Alignment.center,
                          child: Text(initials, style: GoogleFonts.archivo(color: AppTokens.brandMint, fontSize: 22, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(name, style: GoogleFonts.archivo(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppTokens.brandBright, borderRadius: BorderRadius.circular(8)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                const Icon(Icons.verified, color: Colors.white, size: 12),
                                const SizedBox(width: 4),
                                Text('Verified', style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: 3),
                          Text(email, style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          if (company.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(company, style: GoogleFonts.hankenGrotesk(color: AppTokens.brandMint, fontSize: 12.5, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ])),
                      ]),
                      const SizedBox(height: 20),
                      Row(children: [
                        _stat('${state.bookings.length}', 'Bookings'),
                        const SizedBox(width: 10),
                        _stat('4.9', 'Rating'),
                        const SizedBox(width: 10),
                        _stat('Gold', 'Tier'),
                      ]),
                    ]),
                  ),
                ),
              ]),
            ),

            // ── List your gear ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: GestureDetector(
                onTap: () => state.go('owner'),
                child: Container(
                  decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(AppTokens.cardRadius), border: Border.all(color: AppTokens.brandTint2)),
                  padding: const EdgeInsets.all(18),
                  child: Row(children: [
                    Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(13)),
                      child: const Icon(Icons.add_business_outlined, color: Colors.white, size: 22)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('List your own gear', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15.5, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('Earn from idle equipment', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 12.5)),
                    ])),
                    const Icon(Icons.chevron_right, color: AppTokens.brand),
                  ]),
                ),
              ),
            ),

            // ── Settings rows ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
              child: Container(
                decoration: BoxDecoration(color: AppTokens.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTokens.border)),
                child: Column(children: [
                  for (int i = 0; i < settings.length; i++)
                    GestureDetector(
                      onTap: settings[i][2] as VoidCallback,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        decoration: BoxDecoration(border: i == 0 ? null : const Border(top: BorderSide(color: AppTokens.divider))),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        child: Row(children: [
                          Icon(settings[i][1] as IconData, size: 20, color: i == settings.length - 1 ? AppTokens.like : AppTokens.textMuted2),
                          const SizedBox(width: 14),
                          Expanded(child: Text(settings[i][0] as String,
                            style: GoogleFonts.hankenGrotesk(color: i == settings.length - 1 ? AppTokens.like : AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w600))),
                          if (i != settings.length - 1) const Icon(Icons.chevron_right, color: AppTokens.textMuted, size: 20),
                        ]),
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _stat(String big, String small) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.12))),
      child: Column(children: [
        Text(big, style: GoogleFonts.archivo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(small, style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.7), fontSize: 11.5)),
      ]),
    ),
  );
}

// ── How It Works Drawer ───────────────────────────────────────────────────────

class _HowItWorksDrawer extends StatelessWidget {
  static const _steps = [
    (
      icon: Icons.search_rounded,
      color: Color(0xFF2563EB),
      title: 'Browse & discover',
      desc: 'Explore hundreds of event items — tents, lighting, furniture, audio and decor — from verified local suppliers.',
    ),
    (
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF7C3AED),
      title: 'Check availability',
      desc: 'Pick your dates on the live calendar. Booked slots are highlighted so you always see what\'s free.',
    ),
    (
      icon: Icons.shopping_bag_outlined,
      color: Color(0xFFD97706),
      title: 'Request & pay',
      desc: 'Set quantity, choose delivery or pickup, add damage protection, and pay securely in a few taps.',
    ),
    (
      icon: Icons.checklist_rounded,
      color: Color(0xFF059669),
      title: 'Pickup checklist',
      desc: 'At collection, work through the handover checklist together. Both parties sign off on the condition.',
    ),
    (
      icon: Icons.celebration_rounded,
      color: Color(0xFFDB2777),
      title: 'Enjoy your event',
      desc: 'Your gear is yours for the hire period. Need an extension? Message the supplier directly in the Inbox.',
    ),
    (
      icon: Icons.assignment_return_outlined,
      color: Color(0xFF0891B2),
      title: 'Return & deposit back',
      desc: 'Complete the return checklist, confirm condition, and your deposit is released within 1–2 business days.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.84,
      child: Container(
        color: AppTokens.bg,
        child: Column(children: [
          // Drawer header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: AppTokens.homeHeaderGradient),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 28),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppTokens.brandBright, borderRadius: BorderRadius.circular(13)),
                      child: const Icon(Icons.holiday_village_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('EventGear', style: GoogleFonts.archivo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                      Text('RENTAL MARKETPLACE', style: GoogleFonts.jetBrainsMono(color: AppTokens.brandMint, fontSize: 9.5, letterSpacing: 1.6)),
                    ]),
                  ]),
                  const SizedBox(height: 18),
                  Text('How it works', style: GoogleFonts.archivo(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text('From browse to return — six simple steps.', style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.65), fontSize: 13.5)),
                ]),
              ),
            ),
          ),

          // Steps list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              itemCount: _steps.length,
              itemBuilder: (ctx, i) {
                final s = _steps[i];
                final isLast = i == _steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline column
                    Column(children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(color: s.color.withOpacity(0.12), borderRadius: BorderRadius.circular(13)),
                        child: Icon(s.icon, color: s.color, size: 20),
                      ),
                      if (!isLast)
                        Container(width: 2, height: 36, color: AppTokens.divider),
                    ]),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          // Step number + title
                          Row(children: [
                            Container(
                              width: 18, height: 18,
                              decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Text('${i + 1}', style: GoogleFonts.archivo(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w800)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(s.title,
                              style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w800))),
                          ]),
                          const SizedBox(height: 6),
                          Text(s.desc, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 13, height: 1.55)),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Bottom close strip
          Container(
            color: AppTokens.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 46, alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppTokens.border)),
                    child: Text('Close', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 14.5, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
