import 'package:flutter/material.dart';

class AppTokens {
  // Colors
  static const ink = Color(0xFF16241D);
  static const ink2 = Color(0xFF1F4A37);
  static const brand = Color(0xFF1F6B4A);
  static const brandBright = Color(0xFF2F9D6E);
  static const brandMint = Color(0xFF7FC6A3);
  static const brandTint = Color(0xFFEAF3EE);
  static const brandTint2 = Color(0xFFE7EFE9);
  static const bg = Color(0xFFF4F7F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSunken = Color(0xFFF1F4F1);
  static const border = Color(0xFFE9EDE9);
  static const border2 = Color(0xFFEBEFEB);
  static const divider = Color(0xFFF0F3F0);
  static const textMuted = Color(0xFF8D9A91);
  static const textMuted2 = Color(0xFF5D6B63);
  static const textFaint = Color(0xFF9AA8A0);
  static const gold = Color(0xFFF0B94A);
  static const like = Color(0xFFC2553A);
  static const likeIdle = Color(0xFFC2CAC4);
  static const booked = Color(0xFFF0D9D2);
  static const dangerTint = Color(0xFFFCE9E2);

  // Gradients
  static const welcomeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.4, 1.4),
    colors: [Color(0xFF16241D), Color(0xFF1F6B4A)],
    stops: [0.0, 1.0],
  );
  static const homeHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF16241D), Color(0xFF1F4A37)],
  );
  static const profileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.5, 1.5),
    colors: [Color(0xFF16241D), Color(0xFF1F4A37)],
  );

  // Spacing
  static const hPad = 20.0;
  static const cardRadius = 18.0;
  static const btnHeight = 54.0;
  static const btnRadius = 15.0;

  // Shadows
  static final cardShadow = BoxShadow(
    color: const Color(0xFF16241D).withOpacity(0.04),
    blurRadius: 10,
    offset: const Offset(0, 2),
  );
  static final bottomBarShadow = BoxShadow(
    color: const Color(0xFF16241D).withOpacity(0.06),
    blurRadius: 24,
    offset: const Offset(0, -8),
  );
}
