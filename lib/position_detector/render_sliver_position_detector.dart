// Copyright 2018 the Dart project authors.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file or at
// https://developers.google.com/open-source/licenses/bsd

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'position_detector.dart';
import 'position_detector_layer.dart';

/// The [RenderObject] corresponding to the [SliverVisibilityDetector] widget.
///
/// [RenderSliverPositionDetector] is a bridge between
/// [SliverVisibilityDetector] and [PositionDetectorLayer].
class RenderSliverPositionDetector extends RenderProxySliver {
  /// Constructor.  See the corresponding properties for parameter details.
  RenderSliverPositionDetector({
    RenderSliver? sliver,
    required this.key,
    required PositionChangedCallback? onPositionChanged,
  })  : _onPositionChanged = onPositionChanged,
        super(sliver);

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

    Size widgetSize;
    Offset widgetOffset;
    switch (applyGrowthDirectionToAxisDirection(
      constraints.axisDirection,
      constraints.growthDirection,
    )) {
      case AxisDirection.down:
        widgetOffset = Offset(0, -constraints.scrollOffset);
        widgetSize = Size(constraints.crossAxisExtent, geometry!.scrollExtent);
        break;
      case AxisDirection.up:
        final startOffset = geometry!.paintExtent +
            constraints.scrollOffset -
            geometry!.scrollExtent;
        widgetOffset = Offset(0, min(startOffset, 0));
        widgetSize = Size(constraints.crossAxisExtent, geometry!.scrollExtent);
        break;
      case AxisDirection.right:
        widgetOffset = Offset(-constraints.scrollOffset, 0);
        widgetSize = Size(geometry!.scrollExtent, constraints.crossAxisExtent);
        break;
      case AxisDirection.left:
        final startOffset = geometry!.paintExtent +
            constraints.scrollOffset -
            geometry!.scrollExtent;
        widgetOffset = Offset(min(startOffset, 0), 0);
        widgetSize = Size(geometry!.scrollExtent, constraints.crossAxisExtent);
        break;
    }

    final layer = PositionDetectorLayer(
        key: key,
        widgetOffset: widgetOffset,
        widgetSize: widgetSize,
        paintOffset: offset,
        onPositionChanged: onPositionChanged!);
    context.pushLayer(layer, super.paint, offset);
  }
}
