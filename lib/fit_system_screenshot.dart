import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const String _METHOD_CHANNEL_NAME = 'fit.system.screenshot';

class _FitSystemScreenshot {
  MethodChannel? _methodChannel;
  ScrollController? _scrollController;

  _FitSystemScreenshot() {
    if (!Platform.isAndroid) return;
    this._methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);
    this._methodChannel!.setMethodCallHandler((call) {
      if (_scrollController == null) return Future.value(false);
      String methodName = call.method;
      if (methodName == 'scroll') {
        Map args = call.arguments;
        double delta = args['delta']!;
        double radio = window.devicePixelRatio;
        _scrollController!.jumpTo(_scrollController!.offset + delta / radio);
      }
      return Future.value(true);
    });
  }

  void attach(ScrollController scrollController) {
    if (!Platform.isAndroid) return;
    this._scrollController = scrollController;
  }

  void updateScrollArea(Rect scrollArea) {
    if (!Platform.isAndroid) return;
    double radio = window.devicePixelRatio;
    int top = (scrollArea.top * radio).toInt();
    int left = (scrollArea.left * radio).toInt();
    int width = (scrollArea.width * radio).toInt();
    int height = (scrollArea.height * radio).toInt();
    _methodChannel?.invokeMethod('updateScrollArea',
        {'top': top, 'left': left, 'width': width, 'height': height});
  }

  void detach() {
    if (!Platform.isAndroid) return;
    this._scrollController = null;
  }
}

_FitSystemScreenshot fitSystemScreenshot = _FitSystemScreenshot();
