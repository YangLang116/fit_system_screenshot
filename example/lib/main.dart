import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/case/column_usage_page.dart';
import 'package:fit_system_screenshot_example/case/custom_scroll_usage_page.dart';
import 'package:fit_system_screenshot_example/case/list_usage_page.dart';
import 'package:fit_system_screenshot_example/case/nest_scroll_usage_page.dart';
import 'package:fit_system_screenshot_example/case/net_usage_page.dart';
import 'package:fit_system_screenshot_example/case/tab_usage_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //1、初始化长截屏
    fitSystemScreenshot.init();
    super.initState();
  }

  @override
  void dispose() {
    //2、释放长截屏
    fitSystemScreenshot.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: 'home',
      routes: {
        'home': (context) => DisplayPage(),
        'column_usage_page': (context) => ColumnUsagePage(),
        'list_usage_page': (context) => ListUsagePage(),
        'nest_scroll_usage_page': (context) => NestScrollUsagePage(),
        'custom_scroll_usage_page': (context) => CustomScrollUsagePage(),
        'tab_usage_page': (context) => TabUsagePage(),
        'net_usage_page': (context) => NetUsagePage(),
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
                Navigator.pushNamed(context, 'column_usage_page');
              },
              child: Text('Column Usage', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'list_usage_page');
              },
              child: Text(
                'List Usage',
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
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'net_usage_page');
              },
              child: Text(
                'Net Usage',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
