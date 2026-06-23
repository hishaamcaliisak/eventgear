import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/tokens.dart';

class ToastOverlay extends StatefulWidget {
  final String message;
  const ToastOverlay({super.key, required this.message});

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));
    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)), weight: 12),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 76),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 12),
    ]).animate(_ctrl);
    _slide = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: const Offset(0, 0.5), end: Offset.zero).chain(CurveTween(curve: Curves.easeOut)), weight: 12),
      TweenSequenceItem(tween: ConstantTween(Offset.zero), weight: 76),
      TweenSequenceItem(tween: Tween(begin: Offset.zero, end: const Offset(0, -0.5)).chain(CurveTween(curve: Curves.easeIn)), weight: 12),
    ]).animate(_ctrl);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20, right: 20, bottom: 108,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) => Opacity(
            opacity: _opacity.value,
            child: SlideTransition(
              position: _slide,
              child: child,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              decoration: BoxDecoration(
                color: AppTokens.ink,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 34, offset: const Offset(0, 14))],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18, height: 18,
                    decoration: const BoxDecoration(color: AppTokens.brandBright, shape: BoxShape.circle),
                    child: const Center(child: Text('✓', style: TextStyle(color: Colors.white, fontSize: 11))),
                  ),
                  const SizedBox(width: 10),
                  Flexible(child: Text(widget.message, style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
