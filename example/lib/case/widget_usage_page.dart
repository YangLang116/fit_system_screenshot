import 'package:fit_system_screenshot/fit_system_screenshot_widget.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

class WidgetUsagePage extends StatefulWidget {
  const WidgetUsagePage({Key? key}) : super(key: key);

  @override
  State<WidgetUsagePage> createState() => _WidgetUsagePageState();
}

class _WidgetUsagePageState extends State<WidgetUsagePage>
    with LifecycleAware, LifecycleMixin {
  final List<Color> colorList = [
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.deepPurple,
    Colors.green
  ];

  final GlobalKey<FitSystemScreenshotWidgetState> screenShotKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    this.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (int i = 0; i < 20; i++) {
      children.add(Container(
        height: 200,
        alignment: Alignment.center,
        color: colorList[i % colorList.length],
        child: Text('index = $i', style: TextStyle(fontSize: 18)),
      ));
    }
    return Scaffold(
      appBar: AppBar(title: Text('FitSystemScreenshotWidget Usage')),
      body: FitSystemScreenshotWidget(
        key: screenShotKey,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.active) {
      //等待Element树构建
      Future.delayed(Duration.zero, () {
        FitSystemScreenshotWidgetState? currentState =
            screenShotKey.currentState;
        if (currentState == null) return;
        currentState.attach();
      });
    } else if (event == LifecycleEvent.inactive) {
      FitSystemScreenshotWidgetState? currentState = screenShotKey.currentState;
      if (currentState == null) return;
      currentState.detach();
    }
  }
}
