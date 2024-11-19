import 'package:flutter/material.dart';
import 'package:zoomable/src/zoomable_controller.dart';

class ZoomableBuilder extends StatefulWidget {
  const ZoomableBuilder({super.key, required this.builder, required this.controller});
  final ZoomableController controller;
  final Widget Function(BuildContext context, bool isZoomed) builder;

  @override
  State<ZoomableBuilder> createState() => _ZoomableBuilderState();
}

class _ZoomableBuilderState extends State<ZoomableBuilder> {

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onZoomableChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onZoomableChanged);
    super.dispose();
  }

  void _onZoomableChanged() {
    if(mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.controller.isZoomed);
  }
}
