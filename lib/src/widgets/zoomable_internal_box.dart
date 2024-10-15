import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_controller_provider.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

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
    final controller = ZoomableControllerProvider.ofMaybe(context);

    if(controller == null || controller.zoomables.isEmpty) {
      debugPrint('ZoomableBox: ZoomableController is null or ZoomableController had and empty List<Zoomable>');
      return widget.child;
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