import 'dart:math' as math;
import 'dart:ui' show DisplayFeature;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wide_screen_viewport/app_theme.dart';

/// One logical viewport for sizing, routes, dialogs, and modal barriers.
class AppViewport extends StatelessWidget {
  const AppViewport({super.key, required this.builder, this.enabled = true});

  final WidgetBuilder builder;
  final bool enabled;

  // These bootstrap values must not be scaled with .w or .h.
  static const maxWidth = 480.0;
  static const designSize = Size(360, 640);
  static const gutterColor = AppPalette.neutral20;

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: designSize,
    builder: (context, child) => LayoutBuilder(
      builder: (context, constraints) {
        final media = MediaQuery.of(context);
        final width = enabled
            ? math.min(constraints.maxWidth, maxWidth)
            : constraints.maxWidth;
        final margin = (constraints.maxWidth - width) / 2;
        final bounds = Rect.fromLTWH(margin, 0, width, constraints.maxHeight);
        final cropped = media.removeDisplayFeatures(bounds);
        final viewport = cropped.copyWith(
          size: bounds.size,
          systemGestureInsets: media.systemGestureInsets.copyWith(
            left: math.max(0, media.systemGestureInsets.left - margin),
            right: math.max(0, media.systemGestureInsets.right - margin),
          ),
          displayFeatures: [
            for (final feature in cropped.displayFeatures)
              DisplayFeature(
                bounds: feature.bounds.shift(Offset(-margin, 0)),
                type: feature.type,
                state: feature.state,
              ),
          ],
        );

        // ScreenUtil 5.9.3 reads the physical View in ScreenUtilInit.
        // Override those metrics before building the theme and Navigator.
        ScreenUtil.configure(data: viewport);

        return ColoredBox(
          color: gutterColor,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width,
              height: bounds.height,
              child: ClipRect(
                child: MediaQuery(
                  data: viewport,
                  child: Builder(builder: builder),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
