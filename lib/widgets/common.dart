import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

/// Round back / nav button used across screens.
class CircleIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final double size;
  const CircleIconButton({super.key, this.onTap, this.icon = Icons.arrow_back_ios_new, this.bg = Colors.white, this.iconColor = AppTokens.ink, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: AppTokens.border),
        ),
        child: Icon(icon, size: 17, color: iconColor),
      ),
    );
  }
}

class MonoLabel extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final double spacing;
  const MonoLabel(this.text, {super.key, this.color = AppTokens.textMuted, this.size = 11, this.spacing = 1.4});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.jetBrainsMono(fontSize: size, color: color, letterSpacing: spacing, fontWeight: FontWeight.w500),
    );
  }
}

/// Slim transparent page header — replaces heavy white-box headers.
/// Shows back button + title + optional action widget.
class SlimHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? action;
  final bool dark; // true = white text (for gradient/dark screens)
  const SlimHeader({super.key, required this.title, this.subtitle, this.onBack, this.action, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final titleColor = dark ? Colors.white : AppTokens.ink;
    final subColor   = dark ? Colors.white.withOpacity(0.6) : AppTokens.textMuted;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          if (onBack != null) ...[
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: dark ? Colors.white.withOpacity(0.12) : AppTokens.surfaceSunken,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: dark ? Colors.white.withOpacity(0.14) : AppTokens.border),
                ),
                child: Icon(Icons.arrow_back_ios_new, size: 15, color: dark ? Colors.white : AppTokens.ink),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: GoogleFonts.archivo(color: titleColor, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
            if (subtitle != null) Text(subtitle!, style: GoogleFonts.hankenGrotesk(color: subColor, fontSize: 12.5)),
          ])),
          if (action != null) action!,
        ]),
      ),
    );
  }
}

/// Diagonal faint stripe overlay used on dark screens.
class DiagonalStripes extends StatelessWidget {
  final Color color;
  final double opacity;
  const DiagonalStripes({super.key, this.color = Colors.white, this.opacity = 0.04});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _DiagPainter(color.withOpacity(opacity))),
      ),
    );
  }
}

class _DiagPainter extends CustomPainter {
  final Color color;
  _DiagPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.2;
    const gap = 14.0;
    for (double i = -size.height; i < size.width; i += gap) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(_DiagPainter old) => old.color != color;
}
