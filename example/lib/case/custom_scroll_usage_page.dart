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
      appBar: AppBar(title: Text('CustomScrollView Usage')),
      body: CustomScrollView(
        key: scrollAreaKey,
        controller: scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return buildItem('List Item ', index);
            }, childCount: 12),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => buildItem('Grid Item ', index),
              childCount: 15,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(String prefix, int index) {
    return Container(
      alignment: Alignment.center,
      color: colorList[index % colorList.length],
      child: Text('$prefix$index'),
    );
  }
}
