import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wide_screen_viewport/app_viewport.dart';
import 'package:flutter_wide_screen_viewport/app_theme.dart';

void main() => runApp(const ViewportDemoApp());

class ViewportDemoApp extends StatefulWidget {
  const ViewportDemoApp({super.key});

  @override
  State<ViewportDemoApp> createState() => _ViewportDemoAppState();
}

class _ViewportDemoAppState extends State<ViewportDemoApp> {
  bool _enabled = true;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.sizeOf(context);
    return AppViewport(
      enabled: _enabled,
      builder: (context) => MaterialApp(
        title: 'Viewport Lab · Flutter',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: DemoHome(
          window: window,
          enabled: _enabled,
          noteController: _noteController,
          onChanged: (value) => setState(() => _enabled = value),
        ),
      ),
    );
  }
}

class DemoHome extends StatelessWidget {
  const DemoHome({
    super.key,
    required this.window,
    required this.enabled,
    required this.noteController,
    required this.onChanged,
  });

  final Size window;
  final bool enabled;
  final TextEditingController noteController;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final margin = (window.width - viewport.width) / 2;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.view_array_outlined, size: 26, color: AppPalette.orange),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                'VIEWPORT / LAB',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.flutter_dash),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            const Text(
              '01 / A RESPONSIVE EXPERIMENT',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            const Text(
              'A small app.\nRoom to breathe.',
              style: TextStyle(
                fontSize: 32,
                height: 1.25,
                fontWeight: FontWeight.w700,
                color: AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Keep a familiar mobile layout, even when the screen gets bigger.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppPalette.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppPalette.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          enabled
                              ? 'VIEWPORT CAP ACTIVE'
                              : 'FULL-WIDTH COMPARISON',
                          style: const TextStyle(
                            color: AppPalette.orangeLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '${viewport.width.round()}',
                    key: const ValueKey('viewportWidth'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      height: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'logical pixels wide',
                    style: TextStyle(color: AppPalette.blueLight, fontSize: 13),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Divider(color: AppPalette.blueMuted, height: 1),
                  ),
                  Wrap(
                    spacing: 24,
                    runSpacing: 14,
                    children: [
                      _Metric(
                        label: 'WINDOW',
                        value:
                            '${window.width.round()} × ${window.height.round()}',
                      ),
                      _Metric(
                        label: 'EACH MARGIN',
                        value: '${margin.round()} px',
                      ),
                      _Metric(
                        label: 'APP HEIGHT',
                        value: '${viewport.height.round()} px',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              key: const ValueKey('capToggle'),
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Constrain to 480 px',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
              subtitle: const Text(
                'Turn off to compare full width.',
                style: TextStyle(fontSize: 12),
              ),
              value: enabled,
              onChanged: onChanged,
            ),
            const Divider(height: 32),
            const Text(
              '02 / TAKE IT FOR A SPIN',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            const Text(
              'Resize. Your state stays.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Type a note, resize the browser, then try a sheet or another page.',
              style: TextStyle(color: AppPalette.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const ValueKey('demoNote'),
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Your test note',
                hintText: 'This stays as you resize',
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (context) => Padding(
                      padding: EdgeInsets.fromLTRB(
                        24,
                        0,
                        24,
                        24 + MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Same viewport. Everywhere.',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'This sheet and its dismissal area stay inside the app column. Tap a side margin: the sheet stays open.',
                            ),
                            const SizedBox(height: 20),
                            FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Got it'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.vertical_align_top, size: 18),
                  label: const Text('Open sheet'),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute(builder: (_) => const DetailPage()),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Open page'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const _ScaleSample(),
            const SizedBox(height: 24),
            const Text(
              'FLUTTER  •  480 PX CAP  •  FULL HEIGHT',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: AppPalette.blueLight, fontSize: 12),
      ),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _ScaleSample extends StatelessWidget {
  const _ScaleSample();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppPalette.blueLight,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ScreenUtil, in sync',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'The bar below is 180.w: half the app width. Height scaling still uses the full available height.',
            style: TextStyle(fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 14),
          Container(
            key: const ValueKey('scaleBar'),
            width: 180.w,
            height: 8,
            decoration: BoxDecoration(
              color: AppPalette.orange,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${MediaQuery.sizeOf(context).width.round()} px viewport · 180.w = ${180.w.toStringAsFixed(1)} px · 16.h = ${16.h.toStringAsFixed(1)} px',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Another page')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(
          Icons.crop_portrait,
          size: 64,
          color: AppPalette.textPrimary,
        ),
        const SizedBox(height: 24),
        const Text(
          'Navigation fits, too.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Text(
          'This route is ${MediaQuery.sizeOf(context).width.round()} logical pixels wide. Resize the window, then go back: your note is still there.',
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back to the experiment'),
        ),
      ],
    ),
  );
}
