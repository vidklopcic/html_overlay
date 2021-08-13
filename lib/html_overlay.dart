import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:html_overlay/position_detector/position_detector.dart';

class HtmlOverlay extends StatefulWidget {
  final String? html;
  final String? querySelector;
  final Widget? child;
  final VoidCallback? onAttached;
  final VoidCallback? onRemoved;

  const HtmlOverlay({
    Key? key,
    this.html,
    this.querySelector,
    this.child,
    this.onAttached,
    this.onRemoved,
  }) : super(key: key);

  @override
  _HtmlOverlayState createState() => _HtmlOverlayState();
}

class _HtmlOverlayState extends State<HtmlOverlay> {
  GlobalKey key = GlobalKey();
  late HtmlContainer _container;

  @override
  Widget build(BuildContext context) {
    return PositionDetector(
      child: widget.child ?? const Offstage(),
      onPositionChanged: _onPositionChanged,
      key: key,
    );
  }

  @override
  void initState() {
    super.initState();
    _container = HtmlContainer(content: widget.html, querySelector: widget.querySelector);
    if (widget.onAttached != null) widget.onAttached!();
  }

  @override
  void dispose() {
    super.dispose();
    _container.dispose();
    if (widget.onRemoved != null) widget.onRemoved!();
  }

  void _onPositionChanged(PositionInfo info) {
    _container.reposition(info);
  }
}

class HtmlContainer {
  final String? querySelector;
  late html.Element container;

  HtmlContainer({String? content, this.querySelector}) {
    assert(content != null || querySelector != null);
    if (querySelector != null) {
      container = html.document.querySelector(querySelector!)!;
      container.style.display = 'block';
    } else {
      container = html.DivElement();
      container.setInnerHtml(content, treeSanitizer: html.NodeTreeSanitizer.trusted);
      container.style.position = 'absolute';
      container.style.zIndex = '100';
      container.style.pointerEvents = 'none';
      container.style.overflow = 'hidden';
      html.document.body!.append(container);
    }
    container.style.height = '0';
    container.style.width = '0';
  }

  void reposition(PositionInfo info) {
    container.style.top = '${info.widgetBounds.top}px';
    container.style.left = '${info.widgetBounds.left}px';
    container.style.width = '${info.widgetBounds.width}px';
    container.style.height = '${info.widgetBounds.height}px';
    final top = info.visibleBounds.top - info.widgetBounds.top;
    final bottom = info.widgetBounds.bottom - info.visibleBounds.bottom;
    final left = info.visibleBounds.left - info.widgetBounds.left;
    final right = info.widgetBounds.right - info.visibleBounds.right;
    container.style.clipPath = 'inset(${top}px ${right}px ${bottom}px ${left}px)';
  }

  void dispose() {
    if (querySelector != null) {
      container.style.display = 'none';
    } else {
      container.remove();
    }
  }
}
