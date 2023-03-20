import 'package:fit_system_screenshot/fit_system_screenshot_widget.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

class TabUsagePage extends StatefulWidget {
  const TabUsagePage({Key? key}) : super(key: key);

  @override
  State<TabUsagePage> createState() => _TabUsagePageState();
}

class _TabUsagePageState extends State<TabUsagePage>
    with LifecycleAware, LifecycleMixin {
  int index = 0;
  final List<ScrollController> tabControllerList = [
    ScrollController(),
    ScrollController()
  ];
  final List<GlobalKey<FitSystemScreenshotWidgetState>> shotKeyList = [
    GlobalKey(),
    GlobalKey()
  ];

  @override
  void dispose() {
    tabControllerList.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab Usage')),
      body: IndexedStack(
        index: index,
        children: [
          buildList('First List', shotKeyList[0], tabControllerList[0]),
          buildList('Second List', shotKeyList[1], tabControllerList[1]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
          attachController();
        },
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

  Widget buildList(String title, GlobalKey key, ScrollController controller) {
    List<Widget> children = [];
    for (int i = 0; i < 20; i++) {
      children.add(ListTile(title: Text('$title $i')));
    }
    return FitSystemScreenshotWidget(
      key: key,
      controller: controller,
      child: ListView(controller: controller, children: children),
    );
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.active) {
      attachController();
    } else if (event == LifecycleEvent.inactive) {
      FitSystemScreenshotWidgetState? currentState =
          shotKeyList[index].currentState;
      if (currentState == null) return;
      currentState.detach();
    }
  }

  void attachController() {
    //等待Element树构建
    Future.delayed(Duration(milliseconds: 300), () {
      FitSystemScreenshotWidgetState? currentState =
          shotKeyList[index].currentState;
      if (currentState == null) return;
      currentState.attach();
    });
  }
}
