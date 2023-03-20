import 'dart:developer' as Dev;

import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class BasicUsagePage extends StatefulWidget {
  BasicUsagePage({Key? key}) : super(key: key);

  @override
  State<BasicUsagePage> createState() => _BasicUsagePageState();
}

class _BasicUsagePageState extends State<BasicUsagePage> {
  final GlobalKey scrollAreaKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    //1、长截屏的页面绑定控制器
    fitSystemScreenshot.attach(scrollController);
    //2、视图构建完成后，更新滚动区域大小
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      BuildContext? context = scrollAreaKey.currentContext;
      if (context == null) return;
      RenderObject? renderBox = (context as Element).renderObject;
      if (renderBox == null) return;
      Size size = (renderBox as RenderBox).size;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      fitSystemScreenshot.updateScrollArea(offset & size);
    });
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
      appBar: AppBar(title: Text('Basic Usage')),
      body: Column(
        children: [
          buildText(),
          Expanded(child: buildListWidget()),
        ],
      ),
    );
  }

  Widget buildText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text('测试列表控件'),
    );
  }

  Widget buildListWidget() {
    return Container(
      key: scrollAreaKey,
      child: ListView.builder(
        controller: scrollController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Dev.log('index => $index');
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
