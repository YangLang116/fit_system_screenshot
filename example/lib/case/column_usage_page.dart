import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColumnUsagePage extends StatefulWidget {
  ColumnUsagePage({Key? key}) : super(key: key);

  @override
  State<ColumnUsagePage> createState() => _ColumnUsagePageState();
}

class _ColumnUsagePageState extends State<ColumnUsagePage> {
  Dispose? screenShotDispose;
  final GlobalKey scrollAreaKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    screenShotDispose = fitSystemScreenshot.attachToPage(
      scrollAreaKey,
      scrollController,
      scrollController.jumpTo,
    );
    super.initState();
  }

  @override
  void dispose() {
    screenShotDispose?.call();
    this.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Column Usage')),
      body: buildScrollArea(),
    );
  }

  Widget buildScrollArea() {
    List<Widget> children = [];
    for (int i = 0; i < 12; i++) {
      children.add(buildDataItem(i));
    }
    return SingleChildScrollView(
      key: scrollAreaKey,
      controller: scrollController,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Widget buildText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      child: Text('测试列表控件'),
    );
  }

  Widget buildDataItem(int i) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      color: colorList[i % colorList.length],
      child: Text('Column Index = $i', style: TextStyle(fontSize: 18)),
    );
  }
}
