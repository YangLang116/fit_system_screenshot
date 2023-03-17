import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const String _METHOD_CHANNEL_NAME = 'fit.system.screenshot';

class _FitScreenShotHelper {
  late MethodChannel methodChannel;
  ScrollController? scrollController;

  _FitScreenShotHelper() {
    this.methodChannel = MethodChannel(_METHOD_CHANNEL_NAME);
    this.methodChannel.setMethodCallHandler((call) {
      if (scrollController == null) return Future.value('');
      String methodName = call.method;
      Map args = call.arguments;
      if (methodName == 'scroll') {
        double delta = args['delta']!;
        scrollController!.jumpTo(scrollController!.offset + delta);
      }
      return Future.value("");
    });
  }

  void attach(ScrollController scrollController) {
    this.scrollController = scrollController;
  }

  void detach() {
    this.scrollController = null;
  }
}

_FitScreenShotHelper screenShotHelper = _FitScreenShotHelper();
