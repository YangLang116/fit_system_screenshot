import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

const String _METHOD_CHANNEL_NAME = 'fit.system.screenshot.method';
const String _EVENT_CHANNEL_NAME = 'fit.system.screenshot.event';

typedef void OnScreenShotScroll(double offset);

typedef void Dispose();

final double radio = window.devicePixelRatio;

class _FitSystemScreenshot {
  MethodChannel? _methodChannel;
  StreamSubscription? _subscription;

  OnScreenShotScroll? onScreenShotScroll;

  bool isScreenShot = false;

  ///应用启动时调用，初始化截屏环境
  void init() {
    if (!Platform.isAndroid) return;
    this._methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);
    EventChannel _eventChannel = EventChannel(_EVENT_CHANNEL_NAME);
    this._subscription = _eventChannel.receiveBroadcastStream().listen((args) {
      double top = args['top']!;
      isScreenShot = true;
      onScreenShotScroll?.call(top / radio);
      isScreenShot = false;
    });
  }

  ///应用退出时调用，释放截屏资源
  void release() {
    if (!Platform.isAndroid) return;
    this._subscription?.cancel();
  }

  ///页面展示到前台时调用【注意当A页面打开B页面，再退回到A页面时，A页面需要重新调用该方法】
  ///返回一个函数，释放当前页面截屏资源
  Dispose attachToPage(
    GlobalKey scrollAreaKey,
    ScrollController scrollController,
    OnScreenShotScroll onScreenShotScroll,
  ) {
    if (!Platform.isAndroid) return () {};
    final onScrollListener = () {
      if (isScreenShot) return;
      updateScrollPosition(scrollController.offset);
    };
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      this.onScreenShotScroll = onScreenShotScroll;
      updateScrollAreaWithKey(scrollAreaKey);
      scrollController.position.addListener(onScrollListener);
    });
    return () {
      this.onScreenShotScroll = null;
      scrollController.position.removeListener(onScrollListener);
    };
  }

  void updateScrollAreaWithKey(GlobalKey scrollAreaKey) {
    if (!Platform.isAndroid) return;
    BuildContext? context = scrollAreaKey.currentContext;
    if (context == null) return;
    RenderObject? renderBox = (context as Element).renderObject;
    if (renderBox == null) return;
    Size size = (renderBox as RenderBox).size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    updateScrollArea(offset & size);
  }

  void updateScrollArea(Rect scrollArea) {
    if (!Platform.isAndroid) return;
    int top = (scrollArea.top * radio).toInt();
    int left = (scrollArea.left * radio).toInt();
    int width = (scrollArea.width * radio).toInt();
    int height = (scrollArea.height * radio).toInt();
    _methodChannel?.invokeMethod('updateScrollArea', {
      'top': top,
      'left': left,
      'width': width,
      'height': height,
    });
  }

  void updateScrollLength(double maxScrollExtent) {
    if (!Platform.isAndroid) return;
    _methodChannel?.invokeMethod(
      'updateScrollLength',
      {'length': maxScrollExtent * radio},
    );
  }

  void updateScrollPosition(double position) {
    if (!Platform.isAndroid) return;
    _methodChannel?.invokeMethod(
      'updateScrollPosition',
      {'position': position * radio},
    );
  }
}

_FitSystemScreenshot fitSystemScreenshot = _FitSystemScreenshot();
