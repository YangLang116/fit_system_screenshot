import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/case/basic_usage_page.dart';
import 'package:fit_system_screenshot_example/case/custom_scroll_usage_page.dart';
import 'package:fit_system_screenshot_example/case/nest_scroll_usage_page.dart';
import 'package:fit_system_screenshot_example/case/tab_usage_page.dart';
import 'package:fit_system_screenshot_example/case/widget_usage_page.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    fitSystemScreenshot.init();
    super.initState();
  }

  @override
  void dispose() {
    fitSystemScreenshot.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      navigatorObservers: [defaultLifecycleObserver],
      initialRoute: 'home',
      routes: {
        'home': (context) => DisplayPage(),
        'basic_usage_page': (context) => BasicUsagePage(),
        'widget_usage_page': (context) => WidgetUsagePage(),
        'nest_scroll_usage_page': (context) => NestScrollUsagePage(),
        'custom_scroll_usage_page': (context) => CustomScrollUsagePage(),
        'tab_usage_page': (context) => TabUsagePage(),
      },
    );
  }
}

class DisplayPage extends StatelessWidget {
  DisplayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fit System Screenshot')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'basic_usage_page');
              },
              child: Text('Basic Usage', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'widget_usage_page');
              },
              child: Text(
                'FitSystemScreenshotWidget Usage',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'nest_scroll_usage_page');
              },
              child: Text(
                'NestedScrollView Usage',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'custom_scroll_usage_page');
              },
              child: Text(
                'CustomScrollView Usage',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'tab_usage_page');
              },
              child: Text(
                'Tab Usage',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
