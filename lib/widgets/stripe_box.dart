import 'package:flutter/material.dart';

class StripeBox extends StatelessWidget {
  final Color colorA, colorB;
  final double? width, height;
  final BorderRadius? borderRadius;
  final Widget? child;
  final AlignmentGeometry childAlignment;

  const StripeBox({
    super.key,
    required this.colorA,
    required this.colorB,
    this.width,
    this.height,
    this.borderRadius,
    this.child,
    this.childAlignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CustomPaint(
        painter: _StripePainter(colorA: colorA, colorB: colorB),
        child: SizedBox(
          width: width,
          height: height,
          child: child != null ? Align(alignment: childAlignment, child: child) : null,
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  final Color colorA, colorB;
  _StripePainter({required this.colorA, required this.colorB});

  @override
  void paint(Canvas canvas, Size size) {
    final stripeWidth = 9.0;
    final paintA = Paint()..color = colorA;
    final paintB = Paint()..color = colorB;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paintA);
    for (double i = -size.height; i < size.width + size.height; i += stripeWidth * 2) {
      final path = Path()
        ..moveTo(i, 0)
        ..lineTo(i + stripeWidth, 0)
        ..lineTo(i + stripeWidth + size.height, size.height)
        ..lineTo(i + size.height, size.height)
        ..close();
      canvas.drawPath(path, paintB);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.colorA != colorA || old.colorB != colorB;
}
