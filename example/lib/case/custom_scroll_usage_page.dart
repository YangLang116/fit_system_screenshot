import 'package:fit_system_screenshot/fit_system_screenshot_widget.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

class CustomScrollUsagePage extends StatefulWidget {
  const CustomScrollUsagePage({Key? key}) : super(key: key);

  @override
  State<CustomScrollUsagePage> createState() => _CustomScrollUsagePageState();
}

class _CustomScrollUsagePageState extends State<CustomScrollUsagePage>
    with LifecycleAware, LifecycleMixin {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FitSystemScreenshotWidgetState> shotKey = GlobalKey();

  @override
  void dispose() {
    this.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CustomScrollView Usage')),
      body: FitSystemScreenshotWidget(
        key: shotKey,
        controller: scrollController,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return buildItem('List Item $index');
              }, childCount: 15),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return buildItem('Grid Item $index');
              }, childCount: 24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String title) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey,
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.all(10),
      child: Text(title),
    );
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.active) {
      //等待Element树构建
      Future.delayed(Duration.zero, () {
        FitSystemScreenshotWidgetState? currentState = shotKey.currentState;
        if (currentState == null) return;
        currentState.attach();
      });
    } else if (event == LifecycleEvent.inactive) {
      FitSystemScreenshotWidgetState? currentState = shotKey.currentState;
      if (currentState == null) return;
      currentState.detach();
    }
  }
}
