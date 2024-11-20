import 'package:flutter/material.dart';
import 'package:zoomable/src/zoomable_controller.dart';

class ZoomableBuilder extends StatefulWidget {
  const ZoomableBuilder({super.key, required this.builder, required this.controller});

  final ZoomableController controller;
  final Widget Function(BuildContext context, ZoomableController controller) builder;

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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.controller);
  }
}

// Rebuilds only for changes to the zoom status
class ZoomableStatusBuilder extends StatefulWidget {
  const ZoomableStatusBuilder({super.key, required this.builder, required this.controller});

  final ZoomableController controller;
  final Widget Function(BuildContext context, ZoomStatus zoomStatus) builder;

  @override
  State<ZoomableStatusBuilder> createState() => _ZoomableStatusBuilderState();
}

class _ZoomableStatusBuilderState extends State<ZoomableStatusBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller.zoomStatusNotifier,
      builder: (context, _) {
        return widget.builder(
          context,
          widget.controller.zoomStatusNotifier.value,
        );
      },
    );
  }
}
