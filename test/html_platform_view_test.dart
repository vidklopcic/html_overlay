import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html_overlay/html_overlay.dart';

void main() {
  const MethodChannel channel = MethodChannel('html_overlay');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await HtmlOverlay.platformVersion, '42');
  });
}
