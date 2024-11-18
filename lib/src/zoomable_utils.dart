import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_controller.dart';

class ZoomableUtils {
  static Offset calculateChildPosition({required GlobalKey parentKey, required GlobalKey childKey}) {
    final childRenderBox = childKey.currentContext?.findRenderObject() as RenderBox;
    final parentRenderBox = parentKey.currentContext?.findRenderObject() as RenderBox;
    final childOffset = childRenderBox.localToGlobal(Offset.zero);

    return parentRenderBox.globalToLocal(childOffset);
  }

  static Offset calculateChildPositionAccountingForScale({
    required GlobalKey parentKey,
    required GlobalKey childKey,
    required ZoomableController controller,
  }) {
    final childRenderBox = childKey.currentContext?.findRenderObject() as RenderBox;
    final parentRenderBox = parentKey.currentContext?.findRenderObject() as RenderBox;
    final childOffset = childRenderBox.localToGlobal(Offset.zero);

    // Calculate the child's scale based on the controller's scale type
    final childScale = calculateActualScale(
      controller: controller,
      boxSize: childRenderBox.size,
      screenSize: parentRenderBox.size,
    );

    debugPrint("controller.scaleType: ${controller.scaleType}");
    debugPrint("Child scale: $childScale");

    final adjustedOffset = Offset(childOffset.dx / childScale, childOffset.dy / childScale);
    return parentRenderBox.globalToLocal(adjustedOffset);
  }

  static Size getWidgetSize(GlobalKey key) {
    final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }

  static double calculateMaxScale({required Size boxSize, required Size screenSize}) {
    final boxWidth = boxSize.width;
    final boxHeight = boxSize.height;

    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final maxScaleX = screenWidth / boxWidth;
    final maxScaleY = screenHeight / boxHeight;
    final maxScale = maxScaleX < maxScaleY ? maxScaleX : maxScaleY;
    debugPrint("MaxScale: $maxScale");
    return maxScale;
  }

  static double calculateActualScale({
    required ZoomableController controller,
    required Size boxSize,
    required Size screenSize,
  }) {
    late double scale;
    final maxScale = calculateMaxScale(boxSize: boxSize, screenSize: screenSize);
    if (controller.scaleType == ZoomableScaleType.percentage) {
      scale = _scaleToPercentage(controller.scaleToPercentage, screenSize, boxSize);
      if (controller.allowScaleDown == false && scale < 1.0) {
        scale = 1.0;
      }
    } else {
      scale = maxScale < controller.scaleTo ? maxScale : controller.scaleTo;
    }
    return scale;
  }

  static double _scaleToPercentage(double percentage, Size screenSize, Size boxSize) {
    final smallestSide = screenSize.smallest;
    final largestBoxSide = boxSize.biggest;
    final targetBoxSize = smallestSide * percentage;
    return targetBoxSize / largestBoxSide;
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

extension Matrix4Extension on Matrix4 {
  double getMaxScaleOnAxis2() {
    final scaleX = this[0];
    final scaleY = this[5];
    return scaleX > scaleY ? scaleX : scaleY;
  }
}
