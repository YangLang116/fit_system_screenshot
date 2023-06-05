import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/constants.dart';
import 'package:flutter/material.dart';

class CustomScrollUsagePage extends StatefulWidget {
  const CustomScrollUsagePage({Key? key}) : super(key: key);

  @override
  State<CustomScrollUsagePage> createState() => _CustomScrollUsagePageState();
}

class _CustomScrollUsagePageState extends State<CustomScrollUsagePage> {
  Dispose? screenShotDispose;
  final ScrollController scrollController = ScrollController();
  final GlobalKey scrollAreaKey = GlobalKey();

  final int listCount = 15;
  final int gridCount = 6;
  final double itemHeight = 50;
  final int crossAxisCount = 3;

  @override
  void initState() {
    screenShotDispose = fitSystemScreenshot
        .attachToPage(scrollAreaKey, scrollController, (offset) {
      scrollController.jumpTo(offset);
    });
    super.initState();
  }

  double getContentLength() {
    return (listCount * itemHeight) +
        ((gridCount / crossAxisCount).ceil() * itemHeight);
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
      appBar: AppBar(title: Text('CustomScrollView Usage')),
      body: CustomScrollView(
        key: scrollAreaKey,
        controller: scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return buildItem('List Item ', index);
            }, childCount: listCount),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              return buildItem('Grid Item ', index);
            }, childCount: gridCount),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: itemHeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(String prefix, int index) {
    return GestureDetector(
      onTap: () {
        scrollController.animateTo(
          getContentLength(),
          duration: Duration(seconds: 3),
          curve: Curves.linear,
        );
      },
      child: Container(
        height: itemHeight,
        alignment: Alignment.center,
        color: colorList[index % colorList.length],
        child: Text('$prefix$index'),
      ),
    );
  }
}
