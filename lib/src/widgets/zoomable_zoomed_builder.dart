import 'package:flutter/material.dart';
import 'package:zoomable/src/zoomable_controller.dart';

class ZoomableZoomedBuilder extends StatelessWidget {
  const ZoomableZoomedBuilder({super.key, required this.builder, required this.controller});
  final ZoomableController controller;
  final Widget Function(BuildContext context, bool isZoomed) builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller.isZoomed,
      builder: (context, _) {
        return builder(context, controller.isZoomed.value);
      }
    );
  }
}
