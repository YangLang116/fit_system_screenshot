import 'package:fit_system_screenshot/fit_system_screenshot_widget.dart';
import 'package:flutter/material.dart';
import 'package:lifecycle/lifecycle.dart';

class NestScrollUsagePage extends StatefulWidget {
  const NestScrollUsagePage({Key? key}) : super(key: key);

  @override
  State<NestScrollUsagePage> createState() => _NestScrollUsagePageState();
}

class _NestScrollUsagePageState extends State<NestScrollUsagePage>
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
      appBar: AppBar(title: Text('NestedScrollView Usage')),
      body: FitSystemScreenshotWidget(
        key: shotKey,
        controller: scrollController,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [SliverToBoxAdapter(child: FlutterLogo(size: 200))];
          },
          body: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item $index'));
            },
            itemCount: 20,
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
