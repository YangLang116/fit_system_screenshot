import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const String _METHOD_CHANNEL_NAME = 'fit.system.screenshot';

class _FitSystemScreenshot {
  late MethodChannel _methodChannel;
  ScrollController? _scrollController;

  _FitSystemScreenshot() {
    this._methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);
    this._methodChannel.setMethodCallHandler((call) {
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
    this._scrollController = scrollController;
  }

  void updateScrollArea(Rect scrollArea) {
    double radio = window.devicePixelRatio;
    int top = (scrollArea.top * radio).toInt();
    int left = (scrollArea.left * radio).toInt();
    int width = (scrollArea.width * radio).toInt();
    int height = (scrollArea.height * radio).toInt();
    _methodChannel.invokeMethod('updateScrollArea',
        {'top': top, 'left': left, 'width': width, 'height': height});
  }

  void detach() {
    this._scrollController = null;
  }

  void setDebug(bool isDebug) {
    _methodChannel.invokeMethod('setDebug', {'isDebug': isDebug});
  }
}

_FitSystemScreenshot fitSystemScreenshot = _FitSystemScreenshot();
