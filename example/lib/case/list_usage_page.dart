import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/constants.dart';
import 'package:flutter/material.dart';

class ListUsagePage extends StatefulWidget {
  const ListUsagePage({Key? key}) : super(key: key);

  @override
  State<ListUsagePage> createState() => _ListUsagePageState();
}

class _ListUsagePageState extends State<ListUsagePage> {
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
      appBar: AppBar(title: Text('List Usage')),
      body: buildListWidget(),
    );
  }

  Widget buildListWidget() {
    return ListView.builder(
      key: scrollAreaKey,
      controller: scrollController,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          color: colorList[index % colorList.length],
          alignment: Alignment.center,
          child: Text('List Index = $index', style: TextStyle(fontSize: 18)),
        );
      },
    );
  }
}
