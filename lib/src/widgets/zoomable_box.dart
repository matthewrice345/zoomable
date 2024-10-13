import 'package:flutter/material.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

class ZoomableBox extends StatelessWidget {
  const ZoomableBox({
    super.key,
    required this.controller,
    required this.id,
    required this.child,
  });

  final ZoomableController controller;
  final ZoomableId id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final zoomable = controller.zoomables[id]!;
    return SizedBox(
      key: zoomable.key,
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.setZoomableOffset(
              id,
              ZoomableUtils.getChildPosition(
                controller.zoomableKey,
                zoomable.key,
              ),
            );
          });

          return child;
        },
      ),
    );
  }
}
