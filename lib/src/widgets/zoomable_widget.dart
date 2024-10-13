import 'package:flutter/material.dart';
import 'package:zoomable/src/widgets/zoomable_contrainer.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_types.dart';

class ZoomableWidget extends StatelessWidget {
  const ZoomableWidget({
    super.key,
    required this.builder,
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.onZoomableChanged,
  });

  final ZoomableBuilder builder;
  final EdgeInsets padding;
  final Clip clipBehavior;
  final ZoomableListener? onZoomableChanged;
  final ZoomableController controller;

  @override
  Widget build(BuildContext context) {
    return ZoomableContainer(
      zoomableKey: controller.zoomableKey,
      builder: builder,
      padding: padding,
      clipBehavior: clipBehavior,
      onZoomableChanged: onZoomableChanged,
      controller: controller,
    );
  }
}

