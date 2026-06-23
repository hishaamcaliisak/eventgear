// Run with: flutter test test/generate_icons_test.dart
// Generates web/icons/ PNG files from the app logo widget.
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventgear_flutter/widgets/app_logo.dart';

void main() {
  Future<void> saveIcon(WidgetTester tester, int size, String path) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: SizedBox(
                width: size.toDouble(),
                height: size.toDouble(),
                child: AppLogo(size: size.toDouble()),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image   = await boundary.toImage(pixelRatio: 1.0);
    final bytes   = await image.toByteData(format: ui.ImageByteFormat.png);
    final file    = File(path);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    debugPrint('Saved $path ($size×$size)');
  }

  testWidgets('generate web icons', (tester) async {
    tester.view.physicalSize      = const Size(512, 512);
    tester.view.devicePixelRatio  = 1.0;

    await saveIcon(tester, 512, 'web/icons/Icon-512.png');
    await saveIcon(tester, 512, 'web/icons/Icon-maskable-512.png');
    await saveIcon(tester, 192, 'web/icons/Icon-192.png');
    await saveIcon(tester, 192, 'web/icons/Icon-maskable-192.png');
    await saveIcon(tester, 32,  'web/favicon.png');
  });
}
