import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final chat = state.currentChat;
    if (chat == null) {
      return Container(color: AppTokens.bg, child: SafeArea(child: Center(child: TextButton(onPressed: () => state.back(), child: const Text('Back')))));
    }
    final thread = state.chatThread;
    return Container(
      color: AppTokens.bg,
      child: Column(
        children: [
          Container(
            color: AppTokens.surface,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(children: [
                  CircleIconButton(onTap: () => state.back()),
                  const SizedBox(width: 12),
                  Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center,
                    child: Text(chat.initials, style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w700))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(chat.name, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15, fontWeight: FontWeight.w700)),
                    Text(chat.online ? 'Online now' : 'Last seen recently', style: GoogleFonts.hankenGrotesk(color: chat.online ? AppTokens.brandBright : AppTokens.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                  ])),
                ]),
              ),
            ),
          ),
          // Item pill
          Container(
            color: AppTokens.surface,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(11)),
              child: Row(children: [
                const Icon(Icons.inventory_2_outlined, size: 16, color: AppTokens.brand),
                const SizedBox(width: 8),
                Expanded(child: Text(chat.item, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w700))),
              ]),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: thread.map((m) {
                return Align(
                  alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                    decoration: BoxDecoration(
                      color: m.isMe ? AppTokens.brand : AppTokens.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(m.isMe ? 16 : 4), bottomRight: Radius.circular(m.isMe ? 4 : 16),
                      ),
                      border: m.isMe ? null : Border.all(color: AppTokens.border),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m.text, style: GoogleFonts.hankenGrotesk(color: m.isMe ? Colors.white : AppTokens.ink, fontSize: 14, height: 1.4)),
                      const SizedBox(height: 3),
                      Text(m.time, style: GoogleFonts.hankenGrotesk(color: m.isMe ? Colors.white.withOpacity(0.7) : AppTokens.textMuted, fontSize: 10.5)),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),
          // Input
          Container(
            decoration: BoxDecoration(color: AppTokens.surface, border: const Border(top: BorderSide(color: AppTokens.border))),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: Row(children: [
              Expanded(child: Container(
                height: 46, padding: const EdgeInsets.symmetric(horizontal: 16), alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTokens.border)),
                child: Text('Type a message…', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 14)),
              )),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => state.sendMessage(),
                child: Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.arrow_upward, color: Colors.white, size: 20)),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
