///Author: YangLang
///Email: yangl@inke.cn
///Date: 2023/6/12
import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:fit_system_screenshot_example/constants.dart';
import 'package:flutter/material.dart';

class SecondTabPage extends StatefulWidget {
  const SecondTabPage({Key? key}) : super(key: key);

  @override
  State<SecondTabPage> createState() => SecondTabPageState();
}

class SecondTabPageState extends State<SecondTabPage>
    with AutomaticKeepAliveClientMixin {
  Dispose? refreshDispose;
  final GlobalKey scrollAreaKey = GlobalKey();
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    refreshScreenShot();
    super.initState();
  }

  void refreshScreenShot() {
    refreshDispose = fitSystemScreenshot.attachToPage(
      scrollAreaKey,
      scrollController,
      scrollController.jumpTo,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> children = [];
    children.add(FlutterLogo(size: 120));
    for (int i = 0; i < 20; i++) {
      children.add(buildDataItem(i));
    }
    return SingleChildScrollView(
      key: scrollAreaKey,
      controller: scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget buildDataItem(int index) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20),
      color: colorList[index % colorList.length],
      child: Text('SecondTab Index = $index', style: TextStyle(fontSize: 18)),
    );
  }

  @override
  void dispose() {
    refreshDispose?.call();
    scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
