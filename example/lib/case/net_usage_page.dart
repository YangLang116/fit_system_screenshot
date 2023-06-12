///Author: YangLang
///Email: yangl@inke.cn
///Date: 2023/6/12
import 'package:dio/dio.dart';
import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:flutter/material.dart';

class NetUsagePage extends StatefulWidget {
  const NetUsagePage({Key? key}) : super(key: key);

  @override
  State<NetUsagePage> createState() => _NetUsagePageState();
}

class _NetUsagePageState extends State<NetUsagePage> {
  String pageContent = '';

  Dispose? refreshDispose;
  GlobalKey scrollAreaKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    refreshPageData();
  }

  void refreshPageData() async {
    final dio = Dio();
    final response = await dio.get('https://dart.dev');
    setState(() {
      pageContent = response.data;
    });
    // 当首屏页面数据加载完成后调用
    refreshDispose = fitSystemScreenshot.attachToPage(
      scrollAreaKey,
      scrollController,
      scrollController.jumpTo,
    );
  }

  @override
  void dispose() {
    refreshDispose?.call();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Net Usage')),
      body: SingleChildScrollView(
        key: scrollAreaKey,
        controller: scrollController,
        child: Text(pageContent),
      ),
    );
  }
}
