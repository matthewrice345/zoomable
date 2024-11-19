import 'package:flutter/material.dart';
import 'package:zoomable/src/widgets/zoomable_animated_container.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_controller_provider.dart';

class ZoomableWidget extends StatelessWidget {
  const ZoomableWidget({
    super.key,
    required this.child,
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.zoomDuration,
  });

  final Widget child;
  final EdgeInsets padding;
  final Clip clipBehavior;
  final ZoomableController controller;
  final Duration? zoomDuration;

  @override
  Widget build(BuildContext context) {
    return ZoomableControllerProvider(
      controller: controller,
      child: ZoomableAnimatedContainer(
        zoomableKey: controller.zoomableKey,
        padding: padding,
        clipBehavior: clipBehavior,
        controller: controller,
        zoomDuration: zoomDuration,
        child: child,
      ),
    );
  }
}

