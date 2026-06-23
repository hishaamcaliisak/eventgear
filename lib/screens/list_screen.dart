import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../data/seed.dart' as seed;
import '../widgets/item_card.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final TextEditingController _searchCtrl;
  final _focusNode = FocusNode();

  static const filters = [
    ['all', 'All'],
    ['nearby', 'Nearby'],
    ['delivery', 'Delivery'],
    ['pro', 'Pro sellers'],
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _searchCtrl = TextEditingController(text: state.search);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final list = state.filteredItems;
    final catName = state.catId == null
        ? (state.search.isEmpty ? 'All gear' : 'Results')
        : seed.cats.firstWhere((c) => c.id == state.catId).name;

    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Container(
        color: AppTokens.bg,
        child: Column(
          children: [
            // Sticky header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(alignment: Alignment.center, children: [
                      Text(catName, style: GoogleFonts.archivo(color: AppTokens.ink, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.4)),
                      Align(alignment: Alignment.centerRight, child: GestureDetector(
                        onTap: () => state.go('map'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: AppTokens.brandTint, borderRadius: BorderRadius.circular(11)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.map_outlined, size: 15, color: AppTokens.brand),
                            const SizedBox(width: 5),
                            Text('Map', style: GoogleFonts.hankenGrotesk(color: AppTokens.brand, fontSize: 12.5, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      )),
                    ]),
                    const SizedBox(height: 10),
                      Container(
                        height: 46, padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(color: AppTokens.surfaceSunken, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppTokens.border)),
                        child: Row(children: [
                          const Icon(Icons.search, size: 19, color: AppTokens.textMuted),
                          const SizedBox(width: 10),
                          Expanded(child: TextField(
                            controller: _searchCtrl,
                            focusNode: _focusNode,
                            style: GoogleFonts.hankenGrotesk(color: AppTokens.ink, fontSize: 14.5),
                            decoration: InputDecoration(
                              hintText: 'Search gear & suppliers',
                              hintStyle: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 14.5),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (v) {
                              state.search = v;
                              if (v.isNotEmpty) state.catId = null;
                              state.bump();
                            },
                          )),
                          if (_searchCtrl.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchCtrl.clear();
                                state.search = '';
                                state.bump();
                                _focusNode.unfocus();
                              },
                              child: const Icon(Icons.close, size: 17, color: AppTokens.textMuted),
                            ),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 34,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: filters.map((f) {
                            final sel = state.filter == f[0];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () { state.filter = f[0]; state.bump(); },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: sel ? AppTokens.ink : AppTokens.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: sel ? AppTokens.ink : AppTokens.border),
                                  ),
                                  child: Text(f[1], style: GoogleFonts.hankenGrotesk(
                                    color: sel ? Colors.white : AppTokens.textMuted2, fontSize: 13, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            Expanded(
              child: list.isEmpty
                  ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.search_off, size: 48, color: AppTokens.textFaint),
                      const SizedBox(height: 12),
                      Text('No results found', style: GoogleFonts.archivo(color: AppTokens.textMuted2, fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('Try a different search or filter', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted, fontSize: 13.5)),
                    ]))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${list.length} result${list.length == 1 ? '' : 's'}',
                              style: GoogleFonts.jetBrainsMono(color: AppTokens.textMuted2, fontSize: 11, letterSpacing: 0.5)),
                            Text('Sorted by · Nearest', style: GoogleFonts.hankenGrotesk(color: AppTokens.textMuted2, fontSize: 12.5)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ...list.map((i) => Padding(padding: const EdgeInsets.only(bottom: 12), child: ItemCard(item: i))),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
