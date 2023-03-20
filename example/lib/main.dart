import 'package:fit_system_screenshot_example/case/basic_usage_page.dart';
import 'package:fit_system_screenshot_example/case/widget_usage_page.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
            )
          ],
        ),
      ),
    );
  }
}
