import 'package:flutter/material.dart';
import 'package:zoomable/src/widgets/zoomable_contrainer.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_controller_provider.dart';
import 'package:zoomable/src/zoomable_types.dart';

class ZoomableWidget extends StatelessWidget {
  const ZoomableWidget({
    super.key,
    required this.child,
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.onZoomableChanged,
  });

  final Widget child;
  final EdgeInsets padding;
  final Clip clipBehavior;
  final ZoomableListener? onZoomableChanged;
  final ZoomableController controller;

  @override
  Widget build(BuildContext context) {
    return ZoomableControllerProvider(
      controller: controller,
      child: ZoomableContainer(
        zoomableKey: controller.zoomableKey,
        padding: padding,
        clipBehavior: clipBehavior,
        onZoomableChanged: onZoomableChanged,
        controller: controller,
        child: child,
      ),
    );
  }
}

