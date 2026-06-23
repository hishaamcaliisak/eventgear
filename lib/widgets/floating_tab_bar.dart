import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';

class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({super.key});

  static const _tabs = [
    ('home',     'Home',     Icons.home_outlined,            Icons.home_rounded),
    ('browse',   'Browse',   Icons.grid_view_outlined,       Icons.grid_view_rounded),
    ('bookings', 'Bookings', Icons.calendar_month_outlined,  Icons.calendar_month_rounded),
    ('inbox',    'Inbox',    Icons.chat_bubble_outline,      Icons.chat_bubble_rounded),
    ('profile',  'Profile',  Icons.person_outline_rounded,   Icons.person_rounded),
  ];

  static const _screens = ['home', 'list', 'history', 'inbox', 'profile'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Positioned(
      left: 20, right: 20, bottom: 22,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: AppTokens.ink.withOpacity(0.88),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.07)),
              boxShadow: [
                BoxShadow(color: AppTokens.ink.withOpacity(0.32), blurRadius: 32, offset: const Offset(0, 12)),
                BoxShadow(color: AppTokens.brand.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _tabs.map((t) {
                final isActive = state.tab == t.$1;
                return _PillTab(
                  tabKey: t.$1,
                  label: t.$2,
                  iconOutlined: t.$3,
                  iconFilled: t.$4,
                  isActive: isActive,
                  onTap: () => state.setTab(t.$1, _screens[_tabs.indexWhere((x) => x.$1 == t.$1)]),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillTab extends StatelessWidget {
  final String tabKey, label;
  final IconData iconOutlined, iconFilled;
  final bool isActive;
  final VoidCallback onTap;
  const _PillTab({required this.tabKey, required this.label, required this.iconOutlined, required this.iconFilled, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppTokens.brandBright : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? [BoxShadow(color: AppTokens.brandBright.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? iconFilled : iconOutlined, size: 21,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.45)),
            if (isActive) ...[
              const SizedBox(width: 7),
              Text(label,
                style: GoogleFonts.archivo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: -0.2)),
            ],
          ],
        ),
      ),
    );
  }
}
