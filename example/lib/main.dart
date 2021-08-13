import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:html_overlay/html_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HTML Overlay example'),
        ),
        body: ListView.builder(
          itemBuilder: (context, i) => i % 2 == 0
              ? HtmlPlatformView(
                  html:
                      '<div style="opacity: 0.5; background-color: red; width: 100%; height: 100%; color: white; font-weight: bold; display: flex; justify-content: center; align-items: center;">HTML container $i</div>',
                  child: ListTile(
                    onTap: () {},
                    title: Text('linked ListTile'),
                  ),
                )
              : ListTile(
                  onTap: () {},
                  title: Text('Tile'),
                ),
          itemCount: 100,
        ),
      ),
    );
  }
}
