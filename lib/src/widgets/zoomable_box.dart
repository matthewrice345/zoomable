import 'package:flutter/material.dart';
import 'package:zoomable/src/widgets/zoomable_internal_box.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_types.dart';

class ZoomableBox extends StatelessWidget {
  const ZoomableBox({
    super.key,
    required this.id,
    required this.child,
  });

  final ZoomableId id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ZoomableInternalBox(
      id: id,
      controller: ZoomableController.of(context),
      child: child,
    );
  }
}
