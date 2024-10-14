import 'package:flutter/material.dart';
import 'package:zoomable/src/zoomable_controller_provider.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

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
    final controller = ZoomableControllerProvider.ofMaybe(context);

    if(controller == null || controller.zoomables.isEmpty) {
      debugPrint('ZoomableBox: ZoomableController is null or ZoomableController had and empty List<Zoomable>');
      return child;
    }

    final zoomable = controller.zoomables[id]!;

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
          return child;
        },
      ),
    );
  }
}
