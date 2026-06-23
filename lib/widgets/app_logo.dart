import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

// Reusable EventGear logo — a tent icon + wordmark
class AppLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  const AppLogo({super.key, this.size = 54, this.showWordmark = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LogoMark(size: size),
        if (showWordmark) ...[
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('EventGear',
              style: GoogleFonts.archivo(color: Colors.white, fontSize: size * 0.44, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.1)),
            Text('RENTAL MARKETPLACE',
              style: GoogleFonts.jetBrainsMono(color: AppTokens.brandMint, fontSize: size * 0.2, letterSpacing: 1.6, fontWeight: FontWeight.w600)),
          ]),
        ],
      ],
    );
  }
}

class _LogoMark extends StatelessWidget {
  final double size;
  const _LogoMark({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: AppTokens.brandBright,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [BoxShadow(color: AppTokens.brandBright.withOpacity(0.4), blurRadius: size * 0.5, offset: Offset(0, size * 0.12))],
      ),
      child: CustomPaint(
        painter: _TentPainter(),
      ),
    );
  }
}

class _TentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Main tent body — big triangle (roof)
    final roof = Path()
      ..moveTo(cx, h * 0.18)       // peak
      ..lineTo(w * 0.86, h * 0.72) // bottom right
      ..lineTo(w * 0.14, h * 0.72) // bottom left
      ..close();
    canvas.drawPath(roof, paint);

    // Dark cut-out for door arch
    final door = Paint()
      ..color = AppTokens.brand
      ..style = PaintingStyle.fill;
    final doorRect = Rect.fromCenter(center: Offset(cx, h * 0.72), width: w * 0.28, height: w * 0.28);
    canvas.drawArc(doorRect, 3.14159, 3.14159, true, door);

    // Ground line
    final line = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = h * 0.04
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.08, h * 0.72), Offset(w * 0.92, h * 0.72), line);

    // Small flag on peak
    final flag = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    final flagPath = Path()
      ..moveTo(cx, h * 0.10)
      ..lineTo(cx + w * 0.10, h * 0.145)
      ..lineTo(cx, h * 0.18)
      ..close();
    canvas.drawPath(flagPath, flag);

    // Flag pole
    final pole = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = h * 0.03
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, h * 0.08), Offset(cx, h * 0.18), pole);
  }

  @override
  bool shouldRepaint(_) => false;
}
