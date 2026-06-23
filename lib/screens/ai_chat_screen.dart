import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';

class _Msg {
  final String role; // 'user' | 'bot'
  final String text;
  final bool isTyping;
  _Msg({required this.role, required this.text, this.isTyping = false});
}

// ─── Offline rule-based brain ────────────────────────────────────────────────

String _reply(String input) {
  final q = input.toLowerCase().trim();

  // Greetings
  if (_any(q, ['hi', 'hello', 'hey', 'good morning', 'good evening', 'howdy'])) {
    return "Hey there! 👋 I'm EventGear Assistant. I can help you find the right gear, plan your event, estimate quantities, or budget your hire. What are you planning?";
  }

  // Who are you
  if (_any(q, ['who are you', 'what are you', 'your name', 'are you ai', 'are you a bot', 'chatgpt', 'claude'])) {
    return "I'm the EventGear AI Assistant — a built-in chatbot designed to help event planners like you get the most out of this platform. I know all about our gear catalogue, pricing, and event logistics. How can I help?";
  }

  // Thanks
  if (_any(q, ['thank', 'thanks', 'cheers', 'great', 'awesome', 'perfect', 'helpful'])) {
    return "Happy to help! 😊 Is there anything else you'd like to know about your event or gear rental?";
  }

  // ── Tent / Marquee ────────────────────────────────────────────────────────
  if (_any(q, ['tent', 'marquee', 'canopy', 'clearspan', 'sailcloth'])) {
    if (_any(q, ['size', 'how big', 'large', 'small', 'dimension', 'fit', 'capacity', 'guests', 'people'])) {
      return "Here's a quick tent sizing guide:\n\n"
          "• **6×9m (54 m²)** — up to 40 guests (banquet) or 60 (theatre)\n"
          "• **6×12m (72 m²)** — up to 60 guests (banquet) or 90 (theatre)\n"
          "• **9×15m (135 m²)** — up to 110 guests (banquet)\n"
          "• **12×18m (216 m²)** — up to 180 guests (banquet)\n\n"
          "Allow extra space for a dance floor, bar, or stage. A good rule: add 20% to your headcount. Want me to recommend one for your guest count?";
    }
    return "We stock two popular tent styles:\n\n"
        "🏕️ **Clearspan Marquee 6×12m** (\$240/day) — solid walls, no internal poles, great for corporate or wedding receptions.\n\n"
        "⛺ **Sailcloth Peg & Pole Tent** (\$320/day) — romantic translucent fabric, glows beautifully at dusk.\n\n"
        "Both include delivery and professional setup options. Which style suits your event?";
  }

  // ── Guest count / capacity ────────────────────────────────────────────────
  if (_any(q, ['guest', 'people', 'person', 'attendee', 'head count', 'headcount'])) {
    final n = _extractNumber(q);
    if (n != null) {
      final chairs = n;
      final tables = (n / 8).ceil();
      final festoon = (n / 20).ceil() * 10; // 10m per 20 guests approx
      return "For **$n guests** here's a quick estimate:\n\n"
          "🪑 Chairs: **$chairs** (Chiavari set of 20 = ${(chairs / 20).ceil()} sets)\n"
          "🍽️ Banquet tables: **$tables** (seats 8–10 each)\n"
          "💡 Festoon string: **${festoon}m** (warm ambience)\n"
          "🏕️ Tent: ${n <= 60 ? 'Clearspan 6×12m (\$240/day)' : n <= 110 ? 'Sailcloth 9×15m (\$320/day)' : 'Consider combining multiple marquees'}\n\n"
          "Want a full cost estimate for this event?";
    }
    return "Tell me your guest count and I'll give you a tailored gear list with quantities and rough costs!";
  }

  // ── Budget / cost ─────────────────────────────────────────────────────────
  if (_any(q, ['budget', 'cost', 'price', 'how much', 'expensive', 'cheap', 'afford', 'total'])) {
    return "Here's a rough guide to event hire budgets per day:\n\n"
        "💐 **Intimate (20–40 guests):** \$300–600\n"
        "🎉 **Mid-size (40–80 guests):** \$600–1,200\n"
        "🎊 **Large (80–150 guests):** \$1,200–2,500\n"
        "🏆 **Premium (150+ guests):** \$2,500+\n\n"
        "Key cost drivers: tent type, lighting, audio, and whether you need delivery. The damage protection add-on (~9% of hire cost) is worth it for expensive items. Want a breakdown for your event size?";
  }

  // ── Lighting ──────────────────────────────────────────────────────────────
  if (_any(q, ['light', 'lighting', 'festoon', 'uplight', 'uplighter', 'fairy', 'string light', 'ambience', 'atmosphere'])) {
    return "We have two great lighting options:\n\n"
        "✨ **Festoon Lighting 50m** (\$45/day) — warm 2200K LED on black cable, IP44 weatherproof, dimmer included. Perfect for stringing across a marquee or garden.\n\n"
        "🎨 **Uplighter Kit – 12 units** (\$90/day) — battery-powered wireless pars, 16M colours, app-controlled. No cables needed — wash walls in any colour.\n\n"
        "Tip: combine both for the best effect — festoon for warmth overhead, uplighters for drama on the walls.";
  }

  // ── Chairs / furniture ────────────────────────────────────────────────────
  if (_any(q, ['chair', 'seating', 'seat', 'furniture', 'table', 'banquet', 'chiavari'])) {
    return "Our furniture range:\n\n"
        "🪑 **Chiavari Chairs – Set of 20** (\$64/day) — classic gold ballroom chairs, ivory pads included, stackable.\n\n"
        "🪵 **Farmhouse Banquet Tables** (\$38/day) — reclaimed oak trestle, seats 8–10, folding legs.\n\n"
        "**Quick rule:** 1 chair per guest, 1 table per 8–10 guests. Order 10% extra as buffer. Need me to calculate exact quantities for your headcount?";
  }

  // ── Audio / PA ────────────────────────────────────────────────────────────
  if (_any(q, ['audio', 'sound', 'pa system', 'speaker', 'microphone', 'mic', 'stage', 'band', 'dj', 'music'])) {
    return "For audio and staging:\n\n"
        "🔊 **Line Array PA System** (\$180/day) — covers up to 300 guests, 16-ch digital mixer, 2 wireless mics included. Optional sound engineer available.\n\n"
        "🎭 **Modular Stage Deck 6×4m** (\$150/day) — adjustable height (200–600mm), 750 kg/m² load, anti-slip surface. Great for bands and head tables.\n\n"
        "Tip: for events over 80 guests outdoors, always go for the PA — natural voice carry drops fast in open spaces.";
  }

  // ── Decor ─────────────────────────────────────────────────────────────────
  if (_any(q, ['decor', 'decoration', 'linen', 'tablecloth', 'arch', 'floral', 'flowers', 'centrepiece', 'centerpiece'])) {
    return "Our decor range:\n\n"
        "🌸 **Dried Floral Arch** (\$140/day) — freestanding 2.2m arch, pampas + bleached flowers, restyled before every hire.\n\n"
        "🍽️ **Linen Tablecloth Bundle** (\$52/day) — 20 cloths + 20 runners, washed linen in sand/sage/chalk.\n\n"
        "Both add an instant premium feel without the florist bill. The arch is especially popular for ceremony backdrops and photo walls.";
  }

  // ── Catering / bar / heater ───────────────────────────────────────────────
  if (_any(q, ['cater', 'bar', 'drink', 'heater', 'patio heater', 'warmth', 'catering', 'food'])) {
    return "For catering and comfort:\n\n"
        "🔥 **Patio Heater ×4** (\$80/day) — 13kW each, propane included, covers ~20m² each. Essential for evening outdoor events.\n\n"
        "🍸 **Mobile Bar Unit** (\$175/day) — 3m frontage, running-water sinks, ice wells, LED lit. Bar staff available as add-on.\n\n"
        "Pro tip: for 50+ guests in a marquee, 4 heaters is the minimum. In shoulder seasons (April/October) book 6.";
  }

  // ── Delivery ──────────────────────────────────────────────────────────────
  if (_any(q, ['deliver', 'delivery', 'pickup', 'collect', 'collection', 'transport', 'shipping'])) {
    return "Delivery options on EventGear:\n\n"
        "🚚 **Delivery & collection** (\$65 flat) — door-to-door, supplier manages logistics. Recommended for large or fragile items.\n\n"
        "🏪 **Self pickup** (Free) — collect from the supplier's depot. Location shown on each listing.\n\n"
        "For marquees and staging, delivery is strongly recommended as they include crew for setup. Most lighting and small gear is easy to self-collect.";
  }

  // ── Damage protection ─────────────────────────────────────────────────────
  if (_any(q, ['damage', 'protect', 'protection', 'insurance', 'deposit', 'refund', 'broken', 'accidental'])) {
    return "EventGear's damage protection covers accidental damage up to the full deposit value. Here's how it works:\n\n"
        "🛡️ **Add-on cost:** ~9% of your hire subtotal\n"
        "💰 **Deposit:** held at booking, released 1–2 days after undamaged return\n"
        "✅ **What's covered:** accidental damage during your hire period\n"
        "❌ **Not covered:** theft, intentional damage, or loss\n\n"
        "Highly recommended for expensive items like PA systems, lighting kits, and floral arches.";
  }

  // ── Rewards / loyalty ─────────────────────────────────────────────────────
  if (_any(q, ['reward', 'point', 'loyalty', 'tier', 'elite', 'pro planner', 'discount'])) {
    return "EventGear Rewards — earn points on every hire:\n\n"
        "⭐ **Starter:** 0–999 pts — standard rates\n"
        "🥈 **Pro Planner:** 1,000–2,999 pts — 10% off every hire, priority weekend slots\n"
        "🏆 **Elite:** 3,000+ pts — all above + free damage protection\n\n"
        "You earn 1 point per \$1 spent, plus 50 bonus points for leaving a review. Your current balance shows in the Home screen header.";
  }

  // ── Booking process ───────────────────────────────────────────────────────
  if (_any(q, ['book', 'booking', 'hire', 'reserve', 'how to', 'process', 'steps'])) {
    return "Booking on EventGear is simple:\n\n"
        "1️⃣ **Browse** gear by category or search\n"
        "2️⃣ **Open an item** and check availability on the calendar\n"
        "3️⃣ **Select your dates** — pick-up and return\n"
        "4️⃣ **Review request** — set quantity, delivery, and protection\n"
        "5️⃣ **Pay** — deposit + hire fee charged immediately\n"
        "6️⃣ **Pickup checklist** — verify condition at handover\n"
        "7️⃣ **Return checklist** — sign off and deposit is released\n\n"
        "The supplier confirms within a few hours. Any questions about a specific step?";
  }

  // ── Wedding ───────────────────────────────────────────────────────────────
  if (_any(q, ['wedding', 'ceremony', 'reception', 'bridal', 'bride', 'groom'])) {
    return "Wedding hire essentials from EventGear:\n\n"
        "🏕️ Marquee (Clearspan or Sailcloth) — centrepiece of the event\n"
        "🪑 Chiavari chairs — the classic wedding chair\n"
        "🌸 Dried Floral Arch — ceremony backdrop or photo wall\n"
        "🍽️ Linen tablecloths — polished table setting\n"
        "✨ Festoon lighting — magical evening ambience\n"
        "🍸 Mobile bar — fully staffed option available\n\n"
        "For a 60-guest wedding reception, expect to budget **\$700–1,100/day** for the full gear package. Want a tailored list?";
  }

  // ── Corporate ─────────────────────────────────────────────────────────────
  if (_any(q, ['corporate', 'conference', 'seminar', 'meeting', 'presentation', 'office', 'business'])) {
    return "For corporate events, prioritise:\n\n"
        "🎭 **Stage & PA** — professional presentation setup, covers 300 guests\n"
        "🏕️ **Clearspan Marquee** — no internal poles, better sight lines\n"
        "🪑 **Banquet tables & chairs** — flexible layout for breakout sessions\n"
        "🔊 **Line Array PA** — wireless mics for panel discussions\n\n"
        "Tip: add the tech engineer option on the PA hire for smoother AV. Most corporates also prefer delivery for liability reasons.";
  }

  // ── Festival / outdoor ────────────────────────────────────────────────────
  if (_any(q, ['festival', 'outdoor', 'garden', 'park', 'field', 'pop-up'])) {
    return "Planning an outdoor event? Key considerations:\n\n"
        "🌧️ **Weather cover:** always hire a marquee — UK/AU weather is unpredictable\n"
        "🔥 **Warmth:** patio heaters are essential from April onwards\n"
        "💡 **Power:** check site power availability; battery uplighters avoid cable runs\n"
        "🔊 **Sound:** line-array systems are better for open-air — wider coverage\n"
        "🚚 **Access:** confirm vehicle access with your site before booking delivery\n\n"
        "Is this for a public festival or a private outdoor event?";
  }

  // ── Tip / advice ──────────────────────────────────────────────────────────
  if (_any(q, ['tip', 'advice', 'suggest', 'recommend', 'best', 'popular', 'top'])) {
    return "My top 5 tips for event gear hire:\n\n"
        "1. **Book early** — marquees and PA systems sell out weeks ahead for summer dates\n"
        "2. **Always add 10% buffer** on chairs and tables for last-minute RSVPs\n"
        "3. **Combine festoon + uplighters** for the best lighting result\n"
        "4. **Enable damage protection** on items over \$100/day — the peace of mind is worth it\n"
        "5. **Use the checklist** religiously — it's your protection if there's a deposit dispute\n\n"
        "Want a recommendation for a specific event type?";
  }

  // ── Availability / dates ─────────────────────────────────────────────────
  if (_any(q, ['availab', 'date', 'when', 'calendar', 'weekend', 'free'])) {
    return "To check availability, open any item listing and tap **'Check availability'** — this shows the full calendar with booked dates (pink) and available dates (green).\n\n"
        "Tip: booked dates vary per item and supplier. If your first-choice item is unavailable, similar items from other suppliers are usually available — try the Browse tab and filter by category.";
  }

  // ── Default fallback (varied responses) ──────────────────────────────────
  final fallbacks = [
    "That's a great question! I'm best at helping with:\n\n🏕️ Tent & marquee sizing\n🪑 Furniture quantities\n💡 Lighting suggestions\n🔊 Audio & staging\n💰 Budgeting & cost estimates\n📋 Booking process\n\nWhat would you like to explore?",
    "I'm not sure I caught that — I specialise in event equipment and rental logistics. Try asking me:\n\n• \"How many chairs for 80 guests?\"\n• \"What tent size do I need?\"\n• \"Help me budget a corporate event\"\n• \"What's the booking process?\"",
    "Good question! For specific queries like that, I'd suggest chatting directly with the supplier via the Inbox. But I'm great at helping with gear selection, quantities, and budgets — what are you planning?",
  ];
  final rng = Random();
  return fallbacks[rng.nextInt(fallbacks.length)];
}

bool _any(String q, List<String> keywords) => keywords.any((k) => q.contains(k));

int? _extractNumber(String q) {
  final match = RegExp(r'\b(\d+)\b').firstMatch(q);
  if (match != null) return int.tryParse(match.group(1)!);
  // word numbers
  const words = {'ten': 10, 'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60, 'seventy': 70, 'eighty': 80, 'ninety': 90, 'hundred': 100,};
  for (final e in words.entries) { if (q.contains(e.key)) return e.value; }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();
  final List<_Msg> _messages = [];
  bool _typing = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _ctrl.text).trim();
    if (text.isEmpty || _typing) return;
    _ctrl.clear();
    setState(() {
      _messages.add(_Msg(role: 'user', text: text));
      _messages.add(_Msg(role: 'bot', text: '', isTyping: true));
      _typing = true;
    });
    _scrollToBottom();

    // Simulate ~800ms "thinking" then show reply
    await Future.delayed(const Duration(milliseconds: 750));
    final reply = _reply(text);
    setState(() {
      _messages.removeLast();
      _messages.add(_Msg(role: 'bot', text: reply));
      _typing = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Container(
      color: const Color(0xFFEEF1EE),
      child: Column(
        children: [
          // Header
          Container(
            color: AppTokens.surface,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => state.back(),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(color: AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(11)),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTokens.ink),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF16241D), Color(0xFF2F9D6E)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('EventGear AI', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 15.5, fontWeight: FontWeight.w800)),
                    Row(children: [
                      Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppTokens.brandBright, shape: BoxShape.circle)),
                      const SizedBox(width: 5),
                      Text('Always available · No sign-up needed',
                        style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 9.5, letterSpacing: 0.3)),
                    ]),
                  ])),
                ]),
              ),
            ),
          ),

          // Messages
          Expanded(
            child: _messages.isEmpty ? _emptyState() : ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) => _buildBubble(_messages[i]),
            ),
          ),

          // Input bar
          Container(
            color: AppTokens.surface,
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 22,
            ),
            child: Row(children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 46, maxHeight: 120),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: AppTokens.surfaceSunken,
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: AppTokens.border),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    focusNode: _focusNode,
                    maxLines: null,
                    style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5),
                    decoration: InputDecoration(
                      hintText: 'Ask about events, gear, or budgets…',
                      hintStyle: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 14.5),
                      border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) => _send(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _typing ? null : _send,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: _typing ? AppTokens.textFaint : AppTokens.brand,
                    shape: BoxShape.circle,
                    boxShadow: _typing ? [] : [BoxShadow(color: AppTokens.brand.withOpacity(0.35), blurRadius: 14, offset: const Offset(0, 4))],
                  ),
                  child: _typing
                      ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                      : const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 22),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    final prompts = [
      'How many chairs for 80 guests?',
      'What tent size for a wedding?',
      'Help me budget my event',
      'Tips for outdoor events',
      'Explain damage protection',
      'What\'s the booking process?',
    ];
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 76, height: 76,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF16241D), Color(0xFF2F9D6E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: AppTokens.brand.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 6))],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 38),
          ),
          const SizedBox(height: 18),
          Text('EventGear AI', style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text('Your free event-planning assistant.\nAsk me anything about gear, quantities, budgets, or logistics.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 14, height: 1.55)),
          const SizedBox(height: 28),
          Text('Try asking:', style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted, fontSize: 10.5, letterSpacing: 1.2)),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
            children: prompts.map((q) => GestureDetector(
              onTap: () => _send(q),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: AppTokens.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTokens.border),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Text(q, style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            )).toList(),
          ),
        ]),
      ),
    );
  }

  Widget _buildBubble(_Msg msg) {
    final isMe = msg.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 28, height: 28, margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF16241D), Color(0xFF2F9D6E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? AppTokens.brand : AppTokens.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: msg.isTyping
                  ? Row(mainAxisSize: MainAxisSize.min, children: [_dot(0), _dot(1), _dot(2)])
                  : _renderText(msg.text, isMe),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _renderText(String text, bool isMe) {
    // Render **bold** markdown simply
    final spans = <TextSpan>[];
    final parts = text.split(RegExp(r'\*\*'));
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      spans.add(TextSpan(
        text: parts[i],
        style: GoogleFonts.hankenGrotesk(
          color: isMe ? Colors.white : AppTokens.ink,
          fontSize: 14.5, height: 1.5,
          fontWeight: i.isOdd ? FontWeight.w700 : FontWeight.w400,
        ),
      ));
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _dot(int i) => _BouncingDot(delay: Duration(milliseconds: i * 180));
}

class _BouncingDot extends StatefulWidget {
  final Duration delay;
  const _BouncingDot({required this.delay});
  @override
  State<_BouncingDot> createState() => _BouncingDotState();
}

class _BouncingDotState extends State<_BouncingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550))..repeat(reverse: true);
    _anim = Tween(begin: 0.0, end: -5.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Transform.translate(
      offset: Offset(0, _anim.value),
      child: Container(width: 7, height: 7, margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: const BoxDecoration(color: AppTokens.textMuted, shape: BoxShape.circle)),
    ),
  );
}
