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

class Interactive {
  Interactive({
    this.panEnabled,
    this.scaleEnabled,
    this.minScale,
    this.maxScale,
    this.clipBehavior,
    this.transformationController,
});
  final bool? panEnabled;
  final bool? scaleEnabled;
  final double? minScale;
  final double? maxScale;
  final Clip? clipBehavior;
  final TransformationController? transformationController;
}

class ZoomableInteractiveWidget extends StatelessWidget {
  const ZoomableInteractiveWidget({
    super.key,
    required this.child,
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.zoomDuration,
    this.interactive,
  });

  final Widget child;
  final EdgeInsets padding;
  final Clip clipBehavior;
  final ZoomableController controller;
  final Duration? zoomDuration;
  final Interactive? interactive;

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
        child: InteractiveViewer(
          panEnabled: interactive?.panEnabled ?? true,
          scaleEnabled: interactive?.scaleEnabled ?? true,
          minScale: interactive?.minScale ?? 1,
          maxScale: interactive?.maxScale ?? 2.5,
          clipBehavior: interactive?.clipBehavior ?? Clip.hardEdge,
          transformationController: interactive?.transformationController,
          child: child,
        ),
      ),
    );
  }
}

