import 'package:fit_system_screenshot/fit_system_screenshot.dart';
import 'package:flutter/material.dart';

class FitSystemScreenshotWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;

  const FitSystemScreenshotWidget({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  State<FitSystemScreenshotWidget> createState() =>
      FitSystemScreenshotWidgetState();
}

class FitSystemScreenshotWidgetState extends State<FitSystemScreenshotWidget> {
  final GlobalKey key = GlobalKey();

  void attach() {
    BuildContext? context = key.currentContext;
    if (context == null) return;
    RenderObject? renderBox = (context as Element).renderObject;
    if (renderBox == null) return;
    Size size = (renderBox as RenderBox).size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    fitSystemScreenshot.attach(widget.controller);
    fitSystemScreenshot.updateScrollArea(offset & size);
  }

  void detach() {
    fitSystemScreenshot.detach();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
