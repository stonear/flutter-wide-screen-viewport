import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wide_screen_viewport/main.dart';

void main() {
  for (final size in [
    const Size(320, 640),
    const Size(800, 1280),
    const Size(1280, 800),
  ]) {
    testWidgets('demo renders and scrolls without overflow at $size', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const ViewportDemoApp());
      await tester.pumpAndSettle();
      expect(find.text('A small app.\nRoom to breathe.'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('scaleBar')),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(
        tester.getSize(find.byKey(const ValueKey('scaleBar'))).width,
        size.width == 320 ? 160 : 240,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'cap toggle and resizing retain note and update rendered scaling',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const ViewportDemoApp());
      await tester.pumpAndSettle();
      final note = find.byKey(const ValueKey('demoNote'));
      await tester.scrollUntilVisible(
        note,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(note, 'Keep this note');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.ensureVisible(find.byKey(const ValueKey('capToggle')));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('viewportWidth'))).data,
        '800',
      );
      expect(find.text('Keep this note'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const ValueKey('scaleBar')));
      expect(tester.getSize(find.byKey(const ValueKey('scaleBar'))).width, 400);

      await tester.ensureVisible(find.byKey(const ValueKey('capToggle')));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('viewportWidth'))).data,
        '480',
      );
      await tester.ensureVisible(find.text('Open page'));
      await tester.tap(find.text('Open page'));
      await tester.pumpAndSettle();
      expect(find.text('Navigation fits, too.'), findsOneWidget);
      tester.view.physicalSize = const Size(320, 640);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Back to the experiment'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        note,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Keep this note'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('scaleBar')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.getSize(find.byKey(const ValueKey('scaleBar'))).width, 160);
      expect(tester.takeException(), isNull);
    },
  );
}
