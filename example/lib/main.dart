import 'dart:developer';
import 'dart:ui';

import 'package:fit_system_screenshot/after_layout.dart';
import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    //1、长截屏的页面绑定控制器
    fitSystemScreenshot.attach(scrollController);
    super.initState();
  }

  @override
  void dispose() {
    //3、释放对象
    fitSystemScreenshot.detach();
    this.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          buildText(),
          Expanded(child: buildListWidget()),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text('测试列表控件'),
    );
  }

  Widget buildListWidget() {
    //2、指定滚动区域
    return AfterLayout(
      callback: (render) {
        fitSystemScreenshot.updateScrollArea(render.rect);
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              log('index => $index');
            },
            child: Container(
              width: 600,
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text(
                index.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
