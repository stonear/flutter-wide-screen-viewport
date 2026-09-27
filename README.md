# Viewport Lab

A standalone Flutter web POC: keep a mobile UI centered at **up to 480 logical pixels**, with neutral side margins and full available height. Narrow windows use their entire width. Portrait tablets follow the same rule as landscape screens.

## Run

```sh
fvm install
fvm flutter pub get
fvm flutter run -d chrome
```

## Explore

- Resize your browser: the live panel shows window size, app width, height, and margins.
- Toggle **Constrain to 480 px** to compare the same app at full width.
- Type a note and resize or navigate away and back: the input stays intact.
- Open a sheet: the sheet and its dismissal barrier stay inside the app column.
- Inspect the ScreenUtil bar: `180.w` is half of the logical viewport width.

| Window     | App width | Each margin |
| ---------- | --------: | ----------: |
| 320 × 640  |       320 |           0 |
| 430 × 932  |       430 |           0 |
| 800 × 1280 |       480 |         160 |
| 1280 × 800 |       480 |         400 |

`lib/app_viewport.dart` wraps the whole `MaterialApp`, including its Navigator. It crops MediaQuery insets, translates display features, and explicitly configures ScreenUtil from the resulting viewport; that package otherwise reads physical View metrics. `ClipRect` contains painting as well as layout. Keyboard insets and full-height scaling are retained.

This is a compatibility approach, not a multi-column tablet redesign. Tall screens still increase `.h` values. The demo uses regular Flutter sizing for controls and explicit ScreenUtil sizing in the sample bar. Native camera/SDK screens are outside this web POC. Browser Back is not synchronized with the imperative demo route; use the in-app Back button. Resizing preserves state; refreshing the browser resets it.

## Verify

```sh
fvm dart format --output=none --set-exit-if-changed lib test
fvm flutter analyze --fatal-infos
fvm flutter test
fvm flutter build web --release --base-href /flutter-wide-screen-viewport/
```

## Reference styling

The demo uses blue `#07539A`, orange `#F07126`, dark text `#03213E`, white surfaces, neutral `#F8F9FA` margins, Lato typography, and 8-pixel control corners. Shared tokens and control themes live in `lib/app_theme.dart`. The bundled fonts include their [SIL Open Font License](assets/fonts/Lato/OFL.txt).
