import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_wide_screen_viewport/app_viewport.dart';

void main() {
  const contentKey = ValueKey('content');

  void setWindow(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
  }

  Widget app() => AppViewport(
    builder: (context) => MaterialApp(
      home: Builder(
        builder: (context) =>
            const Scaffold(body: SizedBox.expand(key: contentKey)),
      ),
    ),
  );

  for (final scenario in [
    (size: const Size(320, 640), width: 320.0, left: 0.0),
    (size: const Size(430, 932), width: 430.0, left: 0.0),
    (size: const Size(480, 900), width: 480.0, left: 0.0),
    (size: const Size(800, 1280), width: 480.0, left: 160.0),
    (size: const Size(1280, 800), width: 480.0, left: 400.0),
  ]) {
    testWidgets('keeps layout and sizing aligned at ${scenario.size}', (
      tester,
    ) async {
      setWindow(tester, scenario.size);
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();

      final content = find.byKey(contentKey);
      expect(
        tester.getSize(content),
        Size(scenario.width, scenario.size.height),
      );
      expect(tester.getTopLeft(content), Offset(scenario.left, 0));
      expect(
        MediaQuery.sizeOf(tester.element(content)),
        Size(scenario.width, scenario.size.height),
      );
      expect(360.w, closeTo(scenario.width, 0.01));
      expect(640.h, closeTo(scenario.size.height, 0.01));
      expect(18.sp, closeTo(scenario.width / 20, 0.01));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('resizes without losing navigation or form state', (
    tester,
  ) async {
    setWindow(tester, const Size(800, 1280));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    final navigator = Navigator.of(tester.element(find.byKey(contentKey)));
    navigator.push<void>(
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Column(children: [TextField(), ViewportSizingProbe()]),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byKey(const ValueKey('scaledBox'))).width, 240);
    await tester.enterText(find.byType(TextField), '12345');

    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();
    expect(find.text('12345'), findsOneWidget);
    expect(navigator.canPop(), isTrue);
    expect(
      MediaQuery.sizeOf(tester.element(find.byType(TextField))),
      const Size(320, 640),
    );
    expect(360.w, closeTo(320, 0.01));
    expect(tester.getSize(find.byKey(const ValueKey('scaledBox'))).width, 160);

    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();
    expect(find.text('12345'), findsOneWidget);
    expect(360.w, closeTo(480, 0.01));
    expect(tester.getSize(find.byKey(const ValueKey('scaledBox'))).width, 240);
    expect(tester.takeException(), isNull);
  });

  testWidgets('preserves keyboard and vertical safe areas', (tester) async {
    setWindow(tester, const Size(800, 1280));
    tester.view.viewPadding = const FakeViewPadding(
      top: 24,
      bottom: 34,
      left: 20,
    );
    tester.view.padding = const FakeViewPadding(top: 24, bottom: 34, left: 20);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(Scaffold));
    expect(
      MediaQuery.paddingOf(context),
      const EdgeInsets.only(top: 24, bottom: 34),
    );

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    tester.view.padding = const FakeViewPadding(top: 24, left: 20);
    await tester.pumpAndSettle();
    expect(MediaQuery.viewInsetsOf(context).bottom, 300);
    expect(MediaQuery.viewPaddingOf(context).bottom, 34);
    expect(tester.getSize(find.byKey(contentKey)).height, 980);
    expect(360.w, closeTo(480, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('contains modal sheets and their barriers inside the viewport', (
    tester,
  ) async {
    setWindow(tester, const Size(800, 1280));
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    showModalBottomSheet<void>(
      context: tester.element(find.byKey(contentKey)),
      builder: (context) => const SizedBox(height: 200, width: double.infinity),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(BottomSheet)).width, 480);
    expect(tester.getTopLeft(find.byType(BottomSheet)).dx, 160);
    await tester.tapAt(const Offset(50, 500));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    await tester.tapAt(const Offset(200, 500));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class ViewportSizingProbe extends StatelessWidget {
  const ViewportSizingProbe({super.key});

  @override
  Widget build(BuildContext context) =>
      SizedBox(key: const ValueKey('scaledBox'), width: 180.w, height: 20.h);
}
