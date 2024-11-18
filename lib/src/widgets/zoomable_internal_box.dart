import 'package:flutter/widgets.dart';
import 'package:zoomable/zoomable.dart';

class ZoomableInternalBox extends StatefulWidget{
  const ZoomableInternalBox({
    super.key,
    required this.id,
    required this.controller,
    required this.builder,
  });

  final ZoomableId id;
  final ZoomableController controller;
  final WidgetBuilder builder;

  @override
  State<ZoomableInternalBox> createState() => _ZoomableInternalBoxState();
}

class _ZoomableInternalBoxState extends State<ZoomableInternalBox> {

  @override
  void initState() {
    widget.controller.addZoomableBox(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.controller.zoomables.isEmpty) {
      debugPrint('ZoomableBox: ZoomableController is null, ZoomableController had and empty List<Zoomable>');
      return widget.builder(context);
    }

    return SizedBox(
      key: widget.controller.zoomables[widget.id]?.key,
      child: widget.builder(context),
    );
  }
}