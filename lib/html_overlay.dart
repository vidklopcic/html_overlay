import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:html_overlay/position_detector/position_detector.dart';

class HtmlOverlay extends StatefulWidget {
  final String? html;
  final String? querySelector;
  final Widget? child;

  const HtmlOverlay({
    Key? key,
    this.html,
    this.querySelector,
    this.child,
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
  }

  @override
  void dispose() {
    super.dispose();
    _container.dispose();
  }

  void _onPositionChanged(PositionInfo info) {
    _container.reposition(info);
  }
}

abstract class HtmlMessage<T> {
  final String type;

  String serialize(T data);

  T deserialize(String data);

  void onMessage(T data);

  void sendMessage(T data) {}

  HtmlMessage({required this.type});
}

class HtmlContainer {
  late html.Element container;

  HtmlContainer({String? content, String? querySelector}) {
    assert(content != null || querySelector != null);
    if (querySelector != null) {
      container = html.document.querySelector(querySelector)!;
    } else {
      container = html.DivElement();
      container.setInnerHtml(content, treeSanitizer: html.NodeTreeSanitizer.trusted);
      container.style.position = 'fixed';
      container.style.zIndex = '100';
      container.style.pointerEvents = 'none';
      container.style.overflow = 'hidden';
      container.style.height = '0';
      container.style.width = '0';
      html.document.body!.append(container);
    }
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
    container.remove();
  }
}
