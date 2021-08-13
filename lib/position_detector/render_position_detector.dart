// Copyright 2018 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'position_detector.dart';
import 'position_detector_layer.dart';

/// The [RenderObject] corresponding to the [PositionDetector] widget.
///
/// [RenderPositionDetector] is a bridge between [PositionDetector] and
/// [PositionDetectorLayer].
class RenderPositionDetector extends RenderProxyBox {
  /// Constructor.  See the corresponding properties for parameter details.
  RenderPositionDetector({
    RenderBox? child,
    required this.key,
    required PositionChangedCallback? onPositionChanged,
  })  : assert(key != null),
        _onPositionChanged = onPositionChanged,
        super(child);

  /// The key for the corresponding [PositionDetector] widget.
  final Key key;

  PositionChangedCallback? _onPositionChanged;

  /// See [PositionDetector.onPositionChanged].
  PositionChangedCallback? get onPositionChanged => _onPositionChanged;

  /// Used by [PositionDetector.updateRenderObject].
  set onPositionChanged(PositionChangedCallback? value) {
    _onPositionChanged = value;
    markNeedsCompositingBitsUpdate();
    markNeedsPaint();
  }

  // See [RenderObject.alwaysNeedsCompositing].
  @override
  bool get alwaysNeedsCompositing => onPositionChanged != null;

  /// See [RenderObject.paint].
  @override
  void paint(PaintingContext context, Offset offset) {
    if (onPositionChanged == null) {
      // No need to create a [VisibilityDetectorLayer].  However, in case one
      // already exists, remove all cached data for it so that we won't fire
      // visibility callbacks when the layer is removed.
      PositionDetectorLayer.forget(key);
      super.paint(context, offset);
      return;
    }

    final layer = PositionDetectorLayer(
        key: key,
        widgetOffset: Offset.zero,
        widgetSize: semanticBounds.size,
        paintOffset: offset,
        onPositionChanged: onPositionChanged!);
    context.pushLayer(layer, super.paint, offset);
  }
}
