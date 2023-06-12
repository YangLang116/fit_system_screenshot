import 'package:fit_system_screenshot_example/tab/first_tab_page.dart';
import 'package:fit_system_screenshot_example/tab/second_tab_page.dart';
import 'package:flutter/material.dart';

class TabUsagePage extends StatefulWidget {
  const TabUsagePage({Key? key}) : super(key: key);

  @override
  State<TabUsagePage> createState() => _TabUsagePageState();
}

class _TabUsagePageState extends State<TabUsagePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late GlobalKey<FirstTabPageState> firstTabKey = GlobalKey();
  late GlobalKey<SecondTabPageState> secondTabKey = GlobalKey();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      int index = tabController.index;
      if (index == 0) firstTabKey.currentState?.refreshScreenShot();
      if (index == 1) secondTabKey.currentState?.refreshScreenShot();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab Usage'),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: 'First Tab'),
            Tab(text: 'Second Tab'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          FirstTabPage(key: firstTabKey),
          SecondTabPage(key: secondTabKey),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
