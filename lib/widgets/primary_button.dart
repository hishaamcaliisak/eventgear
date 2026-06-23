import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? bg, textColor;
  final double height;
  final double radius;
  final List<BoxShadow>? shadows;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.bg,
    this.textColor,
    this.height = AppTokens.btnHeight,
    this.radius = AppTokens.btnRadius,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: bg ?? AppTokens.brand,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: shadows ?? [BoxShadow(color: AppTokens.brand.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.archivo(
            color: textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
