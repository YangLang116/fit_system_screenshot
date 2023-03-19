import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const String _METHOD_CHANNEL_NAME = 'fit.system.screenshot';

class _FitSystemScreenshot {
  late MethodChannel _methodChannel;
  ScrollController? _scrollController;

  _FitSystemScreenshot() {
    this._methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);
    this._methodChannel.setMethodCallHandler((call) {
      if (_scrollController == null) return Future.value('');
      String methodName = call.method;
      Map args = call.arguments;
      if (methodName == 'scroll') {
        double delta = args['delta']!;
        _scrollController!.jumpTo(_scrollController!.offset + delta);
      }
      return Future.value("");
    });
  }

  void attach(ScrollController scrollController) {
    this._scrollController = scrollController;
  }

  void detach() {
    this._scrollController = null;
  }
}

_FitSystemScreenshot fitSystemScreenshot = _FitSystemScreenshot();
