import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const String _METHOD_CHANNEL_NAME = 'fit.system.screenshot.method';
const String _EVENT_CHANNEL_NAME = 'fit.system.screenshot.event';

class _FitSystemScreenshot {
  MethodChannel? _methodChannel;
  StreamSubscription? _subscription;
  ScrollController? _scrollController;

  void init() {
    if (!Platform.isAndroid) return;
    this._methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);
    EventChannel _eventChannel = EventChannel(_EVENT_CHANNEL_NAME);
    this._subscription = _eventChannel.receiveBroadcastStream().listen((args) {
      double delta = args['delta']!;
      double radio = window.devicePixelRatio;
      _scrollController?.jumpTo(_scrollController!.offset + delta / radio);
    });
  }

  void release() {
    if (!Platform.isAndroid) return;
    this._subscription?.cancel();
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
    _methodChannel?.invokeMethod('updateScrollArea', {
      'top': top,
      'left': left,
      'width': width,
      'height': height,
    });
  }

  void detach() {
    if (!Platform.isAndroid) return;
    this._scrollController = null;
  }
}

_FitSystemScreenshot fitSystemScreenshot = _FitSystemScreenshot();
