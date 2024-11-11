import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_utils.dart';
import 'package:zoomable/zoomable.dart';

class ZoomableInternalBox extends StatefulWidget {
  const ZoomableInternalBox({
    super.key,
    required this.id,
    required this.controller,
    required this.child,
  });

  final ZoomableId id;
  final ZoomableController controller;
  final Widget child;

  @override
  State<ZoomableInternalBox> createState() => _ZoomableInternalBoxState();
}

class _ZoomableInternalBoxState extends State<ZoomableInternalBox> {

  @override
  void initState() {
    super.initState();
    widget.controller.addZoomableBox(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ZoomableController.ofMaybe(context);

    if(controller == null || controller.zoomables.isEmpty) {
      debugPrint('ZoomableBox: ZoomableController is null, ZoomableController had and empty List<Zoomable>');
      debugPrint('Zoomables: ${controller?.zoomables}');
      return widget.child;
    }

    if(controller.zoomables.containsKey(widget.id) == false) {
      debugPrint("ZoomableBox: Id was missing from the controller, adding it now");
      controller.addZoomableBox(widget.id);
    }

    final zoomable = controller.zoomables[widget.id]!;

    return SizedBox(
      key: zoomable.key,
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.setZoomableOffset(
              zoomable.id,
              ZoomableUtils.getChildPosition(
                controller.zoomableKey,
                zoomable.key,
              ),
            );
          });
          return widget.child;
        },
      ),
    );
  }
}