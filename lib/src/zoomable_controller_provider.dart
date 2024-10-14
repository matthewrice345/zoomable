import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_controller.dart';

class ZoomableControllerProvider extends InheritedWidget {
  const ZoomableControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  final ZoomableController controller;

  static ZoomableController of(BuildContext context) {
    final ZoomableControllerProvider? result = context.dependOnInheritedWidgetOfExactType<ZoomableControllerProvider>();
    assert(result != null, 'No ZoomableProvider found in context');
    return result!.controller;
  }

  static ZoomableController? ofMaybe(BuildContext context) {
    final ZoomableControllerProvider? result = context.dependOnInheritedWidgetOfExactType<ZoomableControllerProvider>();
    return result?.controller;
  }

  @override
  bool updateShouldNotify(ZoomableControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}