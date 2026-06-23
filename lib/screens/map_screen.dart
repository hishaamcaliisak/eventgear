import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;
import '../widgets/stripe_box.dart';
import '../widgets/item_card.dart' show itemIcon;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  int? _selectedPin;
  late AnimationController _pinCtrl;

  // Pin positions as fractions of screen
  static const _pins = [
    [0.20, 0.26],
    [0.63, 0.20],
    [0.42, 0.48],
    [0.76, 0.55],
    [0.28, 0.65],
    [0.55, 0.36],
    [0.14, 0.52],
  ];

  @override
  void initState() {
    super.initState();
    _pinCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _pinCtrl.forward();
  }

  @override
  void dispose() { _pinCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state   = context.watch<AppState>();
    final items   = seed.items.take(_pins.length).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0EBE0),
      body: Stack(children: [
        // ── Map canvas ─────────────────────────────────────────────────────
        Positioned.fill(child: CustomPaint(painter: _MapPainter())),

        // ── Pin markers ────────────────────────────────────────────────────
        ...List.generate(items.length, (i) {
          final item = items[i];
          final sel  = _selectedPin == i;
          return AnimatedBuilder(
            animation: _pinCtrl,
            builder: (_, __) {
              final delay = (i * 0.12).clamp(0.0, 0.8);
              final t = CurvedAnimation(
                parent: _pinCtrl,
                curve: Interval(delay, (delay + 0.4).clamp(0, 1), curve: Curves.elasticOut),
              ).value;
              return Align(
                alignment: Alignment(_pins[i][0] * 2 - 1, _pins[i][1] * 2 - 1),
                child: Transform.scale(
                  scale: t,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPin = sel ? null : i),
                    child: _PricePin(
                      price: '\$${item.price}',
                      label: item.name,
                      selected: sel,
                      catIcon: itemIcon(item.cat),
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // ── Top bar: back + search ─────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: [
              // Back
              GestureDetector(
                onTap: () => state.back(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.82),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: Colors.white.withOpacity(0.6)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppTokens.ink),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Search bar
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.88),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.6)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 3))],
                    ),
                    child: Row(children: [
                      const Icon(Icons.search, size: 18, color: AppTokens.textMuted),
                      const SizedBox(width: 8),
                      Text('Eastside · 5 mi radius',
                        style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppTokens.brand, borderRadius: BorderRadius.circular(8)),
                        child: Text('${items.length}', style: GoogleFonts.archivo(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                      ),
                    ]),
                  ),
                ),
              )),
              const SizedBox(width: 10),
              // Filter
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppTokens.brand,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.tune_rounded, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ]),
          ),
        ),

        // ── Map type chips ─────────────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 68, 16, 0),
            child: Row(children: [
              _MapChip(label: 'All gear', active: true),
              const SizedBox(width: 8),
              _MapChip(label: 'Tents'),
              const SizedBox(width: 8),
              _MapChip(label: 'Lighting'),
              const SizedBox(width: 8),
              _MapChip(label: 'Audio'),
            ]),
          ),
        ),

        // ── Bottom sheet ───────────────────────────────────────────────────
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 28, offset: const Offset(0, -4))],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 10),
                  Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTokens.border, borderRadius: BorderRadius.circular(2)))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                    child: Row(children: [
                      Text('${items.length} listings nearby',
                        style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 16, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      Text('Sort by: Nearest',
                        style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      itemCount: items.length,
                      itemBuilder: (ctx, i) {
                        final item = items[i];
                        final isSel = _selectedPin == i;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedPin = isSel ? null : i);
                            if (!isSel) { state.itemId = item.id; state.gallery = 0; state.go('item'); }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            margin: const EdgeInsets.only(right: 12, bottom: 2, top: 2),
                            width: 220,
                            decoration: BoxDecoration(
                              color: AppTokens.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isSel ? AppTokens.brand : AppTokens.border, width: isSel ? 1.5 : 1),
                              boxShadow: [BoxShadow(color: isSel ? AppTokens.brand.withOpacity(0.15) : Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 3))],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Row(children: [
                              StripeBox(colorA: item.sa, colorB: item.sb, width: 76, height: 110,
                                child: Center(child: Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                                  child: Icon(itemIcon(item.cat), size: 18, color: AppTokens.ink),
                                ))),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.2)),
                                  const SizedBox(height: 5),
                                  Row(children: [
                                    const Icon(Icons.star, size: 11, color: AppTokens.gold),
                                    const SizedBox(width: 3),
                                    Text('${item.rating}', style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 11.5, fontWeight: FontWeight.w700)),
                                  ]),
                                  const SizedBox(height: 4),
                                  Row(children: [
                                    Text('\$${item.price}', style: GoogleFonts.archivo(color: AppTokens.brand, fontSize: 13.5, fontWeight: FontWeight.w800)),
                                    Text('/day', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11)),
                                  ]),
                                  Text(item.distance, style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 11)),
                                ]),
                              )),
                            ]),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Price Pin ─────────────────────────────────────────────────────────────────

class _PricePin extends StatelessWidget {
  final String price, label;
  final bool selected;
  final IconData catIcon;
  const _PricePin({required this.price, required this.label, required this.selected, required this.catIcon});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        padding: EdgeInsets.symmetric(horizontal: selected ? 14 : 11, vertical: selected ? 9 : 7),
        decoration: BoxDecoration(
          color: selected ? AppTokens.brand : Colors.white,
          borderRadius: BorderRadius.circular(selected ? 14 : 20),
          boxShadow: [
            BoxShadow(
              color: selected ? AppTokens.brand.withOpacity(0.4) : Colors.black.withOpacity(0.15),
              blurRadius: selected ? 18 : 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: selected ? AppTokens.brand : Colors.white, width: 2),
        ),
        child: selected
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(catIcon, size: 14, color: Colors.white),
                const SizedBox(width: 5),
                Text(price, style: GoogleFonts.archivo(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
              ])
            : Text(price, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 12, fontWeight: FontWeight.w800)),
      ),
      // Pointer tail
      CustomPaint(
        size: const Size(12, 7),
        painter: _PinTailPainter(color: selected ? AppTokens.brand : Colors.white),
      ),
    ]);
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
  }
  @override
  bool shouldRepaint(_PinTailPainter o) => o.color != color;
}

// ── Map chip ──────────────────────────────────────────────────────────────────

class _MapChip extends StatelessWidget {
  final String label;
  final bool active;
  const _MapChip({required this.label, this.active = false});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppTokens.brand : Colors.white.withOpacity(0.82),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppTokens.brand : Colors.white.withOpacity(0.5)),
        ),
        child: Text(label, style: GoogleFonts.hankenGrotesk(
          color: active ? Colors.white : AppTokens.ink,
          fontSize: 12.5, fontWeight: FontWeight.w700)),
      ),
    ),
  );
}

// ── Map Painter ───────────────────────────────────────────────────────────────

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;

    // Background — warm parchment
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h),
        Paint()..color = const Color(0xFFF0EBE0));

    // ── City blocks (buildings) ─────────────────────────────────────────────
    _drawBlock(canvas, w * 0.00, h * 0.00, w * 0.32, h * 0.18);
    _drawBlock(canvas, w * 0.36, h * 0.00, w * 0.28, h * 0.15);
    _drawBlock(canvas, w * 0.68, h * 0.00, w * 0.32, h * 0.17);
    _drawBlock(canvas, w * 0.00, h * 0.22, w * 0.18, h * 0.20);
    _drawBlock(canvas, w * 0.22, h * 0.24, w * 0.22, h * 0.16);
    _drawBlock(canvas, w * 0.68, h * 0.22, w * 0.14, h * 0.18);
    _drawBlock(canvas, w * 0.85, h * 0.20, w * 0.15, h * 0.24);
    _drawBlock(canvas, w * 0.00, h * 0.70, w * 0.22, h * 0.30);
    _drawBlock(canvas, w * 0.26, h * 0.74, w * 0.18, h * 0.26);
    _drawBlock(canvas, w * 0.58, h * 0.70, w * 0.20, h * 0.30);
    _drawBlock(canvas, w * 0.82, h * 0.68, w * 0.18, h * 0.32);

    // ── Park / green areas ──────────────────────────────────────────────────
    _drawPark(canvas, w * 0.46, h * 0.24, w * 0.18, h * 0.22);
    _drawPark(canvas, w * 0.28, h * 0.74, w * 0.26, h * 0.20);
    _drawPark(canvas, w * 0.82, h * 0.44, w * 0.18, h * 0.22);

    // ── Water (river strip) ─────────────────────────────────────────────────
    _drawWater(canvas, 0, h * 0.48, w * 0.46, h * 0.055);
    _drawWater(canvas, w * 0.46, h * 0.495, w, h * 0.04);

    // ── Main roads ──────────────────────────────────────────────────────────
    final mainRoad = Paint()..color = const Color(0xFFFBF5EC)..style = PaintingStyle.fill;
    // Horizontal arterials
    canvas.drawRect(Rect.fromLTWH(0, h * 0.19, w, h * 0.05), mainRoad);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.44, w, h * 0.06), mainRoad);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.69, w, h * 0.04), mainRoad);
    // Vertical arterials
    canvas.drawRect(Rect.fromLTWH(w * 0.33, 0, w * 0.045, h), mainRoad);
    canvas.drawRect(Rect.fromLTWH(w * 0.65, 0, w * 0.045, h), mainRoad);

    // ── Side streets ────────────────────────────────────────────────────────
    final sideRoad = Paint()..color = const Color(0xFFF5EFE4)..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(w * 0.18, 0, w * 0.025, h * 0.44), sideRoad);
    canvas.drawRect(Rect.fromLTWH(w * 0.80, 0, w * 0.025, h), sideRoad);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.08, w * 0.33, h * 0.025), sideRoad);
    canvas.drawRect(Rect.fromLTWH(w * 0.37, h * 0.08, w * 0.28, h * 0.025), sideRoad);
    canvas.drawRect(Rect.fromLTWH(w * 0.46, h * 0.54, w * 0.185, h * 0.025), sideRoad);

    // ── Road centre-line dashes ─────────────────────────────────────────────
    _drawDashes(canvas, 0, h * 0.215, w, h * 0.215, w);
    _drawDashes(canvas, 0, h * 0.47, w, h * 0.47, w);
    _drawDashes(canvas, w * 0.352, 0, w * 0.352, h, h);
    _drawDashes(canvas, w * 0.672, 0, w * 0.672, h, h);

    // ── Road labels ─────────────────────────────────────────────────────────
    _roadLabel(canvas, 'Harbour St', w * 0.1, h * 0.175, false);
    _roadLabel(canvas, 'Market Rd', w * 0.1, h * 0.425, false);
    _roadLabel(canvas, 'East Ave', w * 0.32, h * 0.3, true);
    _roadLabel(canvas, 'Grove Ln', w * 0.64, h * 0.3, true);

    // ── Park labels ─────────────────────────────────────────────────────────
    _parkLabel(canvas, 'Victoria\nPark', w * 0.50, h * 0.31);
    _parkLabel(canvas, 'Riverside\nGardens', w * 0.36, h * 0.80);
  }

  void _drawBlock(Canvas c, double x, double y, double bw, double bh) {
    final inner = 3.0;
    // Plot fill
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, bw, bh), const Radius.circular(3)),
      Paint()..color = const Color(0xFFE5DDCE),
    );
    // Individual building footprints
    final rng = (x + y).toInt() % 7;
    final bld = Paint()..color = const Color(0xFFD4C9B8)..style = PaintingStyle.fill;
    final rows = 2 + rng % 2;
    final cols = 2 + rng % 3;
    final gapX = bw * 0.1 / (cols + 1);
    final gapY = bh * 0.1 / (rows + 1);
    final cellW = (bw * 0.9) / cols;
    final cellH = (bh * 0.9) / rows;
    for (int r = 0; r < rows; r++) {
      for (int cc = 0; cc < cols; cc++) {
        final bx = x + inner + cc * (cellW + gapX);
        final by = y + inner + r * (cellH + gapY);
        c.drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(bx, by, cellW - inner, cellH - inner), const Radius.circular(1.5)),
          bld,
        );
      }
    }
  }

  void _drawPark(Canvas c, double x, double y, double pw, double ph) {
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, pw, ph), const Radius.circular(4)),
      Paint()..color = const Color(0xFFBDD9C0),
    );
    // Tree dots
    final tree = Paint()..color = const Color(0xFF9DC4A2)..style = PaintingStyle.fill;
    final spacing = 14.0;
    for (double tx = x + 8; tx < x + pw - 6; tx += spacing) {
      for (double ty = y + 8; ty < y + ph - 6; ty += spacing) {
        c.drawCircle(Offset(tx, ty), 4.5, tree);
      }
    }
  }

  void _drawWater(Canvas c, double x, double y, double ww, double wh) {
    final path = Path()
      ..moveTo(x, y)
      ..lineTo(x + ww, y + wh * 0.2)
      ..lineTo(x + ww, y + wh)
      ..lineTo(x, y + wh * 0.8)
      ..close();
    c.drawPath(path, Paint()..color = const Color(0xFFA8CEDE));
    // Subtle wave lines
    final wave = Paint()..color = const Color(0xFF8BB8CC)..strokeWidth = 1.0..style = PaintingStyle.stroke;
    for (double wy = y + 5; wy < y + wh - 3; wy += 5) {
      c.drawLine(Offset(x + 8, wy), Offset(x + ww - 8, wy + wh * 0.05), wave);
    }
  }

  void _drawDashes(Canvas c, double x1, double y1, double x2, double y2, double len) {
    final paint = Paint()
      ..color = const Color(0xFFD4C9B8)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final dx = x2 - x1;
    final dy = y2 - y1;
    final dist = (dx * dx + dy * dy == 0) ? 1.0 : len;
    const dash = 10.0;
    const gap  = 8.0;
    double pos = 0;
    while (pos < dist) {
      final t0 = pos / dist;
      final t1 = ((pos + dash) / dist).clamp(0.0, 1.0);
      c.drawLine(Offset(x1 + dx * t0, y1 + dy * t0), Offset(x1 + dx * t1, y1 + dy * t1), paint);
      pos += dash + gap;
    }
  }

  void _roadLabel(Canvas c, String text, double x, double y, bool vertical) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color(0xFF9A8E7E),
          fontSize: 9.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          fontFamily: 'sans-serif',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    c.save();
    if (vertical) {
      c.translate(x, y + tp.width / 2);
      c.rotate(-3.14159 / 2);
      tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
    } else {
      tp.paint(c, Offset(x, y));
    }
    c.restore();
  }

  void _parkLabel(Canvas c, String text, double x, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF5A8A60),
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1.4,
          fontFamily: 'sans-serif',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 60);
    tp.paint(c, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(_MapPainter _) => false;
}
