# html_overlay

Simple plugin that keeps selected HTML container exactly aligned with the underlying Flutter widget. It was built to overcome issues with platform views when using the Webkit renderer (especially this issue: https://github.com/flutter/flutter/issues/75914).

**`pointer-events` are set to `none` by default. For items that need interaction, set `pointer-events: auto`!**
