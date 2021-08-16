# html_overlay

Simple plugin that keeps selected HTML container exactly aligned with the underlying Flutter widget. It was built to overcome issues with platform views when using the Webkit renderer (especially this issue: https://github.com/flutter/flutter/issues/75914).

# user interactions
**`pointer-events` are set to `none` by default. For items that need interaction, set `pointer-events: auto`!**

To prevent Flutter from reacting to keypresses that are intended for the HTML overlay, add the following listeners to the focusable HTML element:
```Dart
_editorElement!.addEventListener('keydown', (e) {
  e.stopPropagation();
});
_editorElement!.addEventListener('keyup', (e) {
  e.stopPropagation();
});
_editorElement!.addEventListener('keypress', (e) {
  e.stopPropagation();
});
```

In order to allow scrolling despite setting `pointer-events: auto` you can use this hack:
```Dart
final glassPane = html.document.querySelector('flt-glass-pane')!;
_editorElement!.addEventListener('wheel', (e) {
  Future.delayed(Duration(microseconds: 1)).then((value) {
    e = e as html.WheelEvent;
    glassPane.dispatchEvent(e);
  });
});
```
