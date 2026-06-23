import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      color: AppTokens.bg,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Stack(alignment: Alignment.center, children: [
                Text('Inbox', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                Align(alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(10)),
                    child: Text('${seed.chats.where((c) => c.unread > 0).length} unread',
                      style: GoogleFonts.jetBrainsMono(color: AppTokens.brand, fontSize: 10.5, fontWeight: FontWeight.w600)),
                  )),
              ]),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              children: [
                // ── AI Chat Banner ─────────────────────────────────────────
                GestureDetector(
                  onTap: () => state.go('ai_chat'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF16241D), Color(0xFF1F6B4A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: AppTokens.brand.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 6))
                      ],
                    ),
                    child: Row(children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(13)),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('EventGear AI Assistant',
                          style: GoogleFonts.archivo(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 3),
                        Text('Powered by Claude · Ask anything about event rentals',
                          style: GoogleFonts.hankenGrotesk(color: Colors.white.withOpacity(0.72), fontSize: 12.5)),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                        decoration: BoxDecoration(color: AppTokens.brandBright, borderRadius: BorderRadius.circular(10)),
                        child: Text('Chat', style: GoogleFonts.archivo(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700)),
                      ),
                    ]),
                  ),
                ),

                // ── Section label ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('SUPPLIER CHATS',
                    style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                ),

                // ── Supplier chat rows ──────────────────────────────────────
                ...seed.chats.map((c) => GestureDetector(
                  onTap: () { state.chatId = c.id; state.go('chat'); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTokens.divider))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(children: [
                          Container(width: 50, height: 50,
                            decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(14)),
                            alignment: Alignment.center,
                            child: Text(c.initials,
                              style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 15, fontWeight: FontWeight.w700))),
                          if (c.online)
                            Positioned(right: 0, bottom: 0,
                              child: Container(width: 13, height: 13,
                                decoration: BoxDecoration(
                                  color: AppTokens.brandBright, shape: BoxShape.circle,
                                  border: Border.all(color: AppTokens.bg, width: 2)))),
                        ]),
                        const SizedBox(width: 13),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15, fontWeight: FontWeight.w700))),
                            Text(c.time,
                              style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11.5)),
                          ]),
                          const SizedBox(height: 2),
                          Text(c.item,
                            style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Row(children: [
                            Expanded(child: Text(c.last, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.hankenGrotesk(
                                color: c.unread > 0 ? AppTokens.ink : AppTokens.textMuted,
                                fontSize: 13,
                                fontWeight: c.unread > 0 ? FontWeight.w600 : FontWeight.w400))),
                            if (c.unread > 0)
                              Container(margin: const EdgeInsets.only(left: 8), width: 20, height: 20,
                                decoration: const BoxDecoration(color: AppTokens.brand, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text('${c.unread}',
                                  style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                          ]),
                        ])),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
