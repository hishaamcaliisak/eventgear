import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/primary_button.dart';
import '../widgets/common.dart';
import '../widgets/app_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Container(
      decoration: const BoxDecoration(gradient: AppTokens.welcomeGradient),
      child: Stack(
        children: [
          const DiagonalStripes(opacity: 0.035),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const AppLogo(size: 62, showWordmark: true),
                  const Spacer(),
                  const MonoLabel('EVENTGEAR · RENTAL MARKETPLACE', color: AppTokens.brandMint, size: 11, spacing: 2),
                  const SizedBox(height: 18),
                  Text('Every event,\nfully equipped.',
                    style: GoogleFonts.archivo(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, height: 1.05, letterSpacing: -1)),
                  const SizedBox(height: 18),
                  Text('Rent marquees, lighting, staging and decor from trusted local suppliers — booked, insured and delivered in a few taps.',
                    style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.72), fontSize: 16, height: 1.5)),
                  const SizedBox(height: 34),
                  PrimaryButton(
                    label: 'Get started',
                    bg: AppTokens.brandBright,
                    onTap: () => state.go('onboard'),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => state.go('signin'),
                    child: Container(
                      height: AppTokens.btnHeight,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppTokens.btnRadius),
                        border: Border.all(color: Colors.white.withOpacity(0.16)),
                      ),
                      alignment: Alignment.center,
                      child: Text('I already have an account',
                        style: GoogleFonts.archivo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
