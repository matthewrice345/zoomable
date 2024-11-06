import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_controller.dart';

class ZoomableControllerProvider extends InheritedWidget {
  const ZoomableControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  final ZoomableController controller;

  @override
  bool updateShouldNotify(ZoomableControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}