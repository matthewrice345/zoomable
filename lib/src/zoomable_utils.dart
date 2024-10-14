import 'package:flutter/widgets.dart';

class ZoomableUtils {
  static Offset getChildPosition(GlobalKey parentKey, GlobalKey childKey) {
    final childRenderBox = childKey.currentContext?.findRenderObject() as RenderBox;
    final parentRenderBox = parentKey.currentContext?.findRenderObject() as RenderBox;
    final childOffset = childRenderBox.localToGlobal(Offset.zero);
    return parentRenderBox.globalToLocal(childOffset);
  }

  static Size getWidgetSize(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }
}

extension BoxConstraintsExtensions on BoxConstraints {
  bool get isZero => maxWidth == 0 || maxHeight == 0;
}

extension SizeExtensions on Size {
  bool get isZero => width == 0 || height == 0;
  double get smallest => width < height ? width : height;
  double get biggest => width > height ? width : height;
}
