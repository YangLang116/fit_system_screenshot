import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/constants.dart';
import 'package:flutter/material.dart';

class TabUsagePage extends StatefulWidget {
  const TabUsagePage({Key? key}) : super(key: key);

  @override
  State<TabUsagePage> createState() => _TabUsagePageState();
}

class _TabUsagePageState extends State<TabUsagePage> {
  int index = 0;
  List<int> tabItemCountList = [10, 15];
  double itemHeight = 120;

  Dispose? screenShotDispose;
  final List<GlobalKey> scrollAreaKeyList = [GlobalKey(), GlobalKey()];
  final List<ScrollController> scrollControllerList = [
    ScrollController(),
    ScrollController()
  ];

  @override
  void initState() {
    attachScreenShot(0);
    super.initState();
  }

  void attachScreenShot(double offset) {
    screenShotDispose?.call();
    screenShotDispose = fitSystemScreenshot.attachToPage(
        scrollAreaKeyList[index], scrollControllerList[index], (offset) {
      scrollControllerList[index].jumpTo(offset);
    });
  }

  @override
  void dispose() {
    screenShotDispose?.call();
    scrollControllerList.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void changeTab(int index) {
    setState(() {
      this.index = index;
    });
    attachScreenShot(scrollControllerList[index].offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab Usage')),
      body: IndexedStack(
        index: index,
        children: [
          buildList(
            scrollAreaKeyList[0],
            tabItemCountList[0],
            scrollControllerList[0],
          ),
          buildList(
            scrollAreaKeyList[1],
            tabItemCountList[1],
            scrollControllerList[1],
            headWidget: Container(
              height: 80,
              color: Colors.blueGrey,
              alignment: Alignment.center,
              child: Text('Head'),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: changeTab,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'First',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'Second',
          ),
        ],
      ),
    );
  }

  Widget buildList(GlobalKey key, int itemCount, ScrollController controller,
      {Widget? headWidget}) {
    List<Widget> children = [];
    for (int i = 0; i < itemCount; i++) {
      children.add(buildDataItem(i));
    }
    Widget result = ListView(
      key: key,
      controller: controller,
      children: children,
    );
    if (headWidget != null) {
      result = Column(
        children: [headWidget, Expanded(child: result)],
      );
    }
    return result;
  }

  Widget buildDataItem(int index) {
    return Container(
      height: itemHeight,
      alignment: Alignment.center,
      color: colorList[index % colorList.length],
      child: Text('Column Index = $index', style: TextStyle(fontSize: 18)),
    );
  }
}
