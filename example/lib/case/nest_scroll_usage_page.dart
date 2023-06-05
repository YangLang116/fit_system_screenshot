import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/constants.dart';
import 'package:flutter/material.dart';

class NestScrollUsagePage extends StatefulWidget {
  const NestScrollUsagePage({Key? key}) : super(key: key);

  @override
  State<NestScrollUsagePage> createState() => _NestScrollUsagePageState();
}

class _NestScrollUsagePageState extends State<NestScrollUsagePage> {
  final int itemCount = 10;
  final double itemHeight = 120;
  final double headHeight = 200;

  Dispose? screenShotDispose;
  final GlobalKey<NestedScrollViewState> scrollAreaKey =
      GlobalKey<NestedScrollViewState>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    screenShotDispose = fitSystemScreenshot.attachToPage<NestedScrollViewState>(
        scrollAreaKey, scrollController, (offset) {
      NestedScrollViewState? state = scrollAreaKey.currentState;
      if (offset <= headHeight) {
        state?.outerController.jumpTo(offset);
      } else {
        state?.innerController.jumpTo(offset - headHeight);
      }
    });
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
      appBar: AppBar(title: Text('NestedScrollView Usage')),
      body: NestedScrollView(
        key: scrollAreaKey,
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () {
                  NestedScrollViewState? state = scrollAreaKey.currentState;
                  state?.outerController.animateTo(
                    headHeight,
                    duration: Duration(seconds: 1),
                    curve: Curves.linear,
                  );
                  Future.delayed(Duration(seconds: 1), () {
                    state?.innerController.animateTo(
                      itemHeight * itemCount,
                      duration: Duration(seconds: 3),
                      curve: Curves.linear,
                    );
                  });
                },
                child: FlutterLogo(size: headHeight),
              ),
            )
          ];
        },
        body: ListView.builder(
          itemExtent: itemHeight,
          itemCount: itemCount,
          itemBuilder: (context, index) => buildDataItem(index),
        ),
      ),
    );
  }

  Widget buildDataItem(int i) {
    return Container(
      height: itemHeight,
      alignment: Alignment.center,
      color: colorList[i % colorList.length],
      child: Text('Column Index = $i', style: TextStyle(fontSize: 18)),
    );
  }
}
