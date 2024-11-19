import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

class ZoomableAnimatedContainer extends StatefulWidget {
  const ZoomableAnimatedContainer({
    required ZoomableKey zoomableKey,
    required this.child,
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.minScale = 1,
    this.maxScale = 10,
    Duration? zoomDuration,
  })  : zoomDuration = zoomDuration ?? const Duration(milliseconds: 500),
        super(key: zoomableKey);

  final Widget child;
  final EdgeInsets padding;
  final Clip clipBehavior;
  final ZoomableController controller;
  final double minScale;
  final double maxScale;
  final Duration zoomDuration;

  @override
  State<ZoomableAnimatedContainer> createState() => ZoomableAnimatedContainerState();
}

class ZoomableAnimatedContainerState extends State<ZoomableAnimatedContainer> with SingleTickerProviderStateMixin {

  late AnimationController _zoomAnimationController;
  Animation<Matrix4>? _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: widget.zoomDuration,
    );
    _zoomAnimation = Matrix4Tween(begin: Matrix4.identity(), end: Matrix4.identity()).animate(
      CurvedAnimation(parent: _zoomAnimationController, curve: Curves.easeInOut),
    );
    _zoomAnimation!.addListener(unifiedZoomListener);
  }

  @override
  void dispose() {
    _zoomAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const ValueKey('zoomable-container-LayoutBuilder'),
      builder: (context, parentConstraints) {
        debugPrint("ZoomableContainer: parentConstraints: $parentConstraints");
        return InteractiveViewer(
          key: const ValueKey('zoomable-container-InteractiveViewer'),
          transformationController: widget.controller.matrixController,
          constrained: false,
          panEnabled: false,
          scaleEnabled: false,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          clipBehavior: widget.clipBehavior,
          child: SizedBox(
            key: const ValueKey('zoomable-container-SizedBox'),
            height: parentConstraints.maxHeight,
            width: parentConstraints.maxWidth,
            child: Padding(
              key: const ValueKey('zoomable-container-Padding'),
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  void onZoomTo(ZoomableId id, Offset boxOffset, Size boxSize) {
    debugPrint('onZoomTo: ZoomableId: $id');

    final parentSize = ZoomableUtils.getWidgetSize(widget.key as ZoomableKey);

    setState(() {
      if (boxSize.isZero || parentSize.isZero) {
        return;
      }

      debugPrint('onZoomTo currentFocus: ${widget.controller.currentFocus}');
      if (widget.controller.currentFocus == id) {
        _onZoomOut();
      } else {
        _onZoomIn(boxSize, parentSize, boxOffset, id);
      }
    });
  }

  void onZoomOut() => _onZoomOut();

  void _onZoomOut() {
    if (widget.controller.status.isZoomedIn) {
      final beginMatrix = widget.controller.matrixController.value.clone();
      final endMatrix = Matrix4.identity();

      _zoomAnimation = Matrix4Tween(begin: beginMatrix, end: endMatrix).animate(
        CurvedAnimation(parent: _zoomAnimationController, curve: Curves.easeInOut),
      );

      widget.controller.status = ZoomStatus.zoomedOutStarted;
      _zoomAnimationController.forward(from: 0).then((_) {
        debugPrint('ZOOM OUT: AnimationStatus.completed');
        widget.controller.status = ZoomStatus.zoomedOut;
        widget.controller.matrixController.value = Matrix4.identity();
        widget.controller.clearCurrentFocus();
      });
    }
  }

  void unifiedZoomListener() {
    widget.controller.matrixController.value = _zoomAnimation?.value ?? Matrix4.identity();
  }

  void _onZoomIn(Size boxSize, Size screenSize, Offset boxOffset, String boxId) {
    final boxWidth = boxSize.width;
    final boxHeight = boxSize.height;

    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final double scale = ZoomableUtils.calculateActualScale(
      controller: widget.controller,
      boxSize: boxSize,
      screenSize: screenSize,
    );

    final centerScreenOffset = Offset(screenWidth / 2, screenHeight / 2);
    final scaledBoxOffset = Offset(
      boxOffset.dx * scale,
      boxOffset.dy * scale,
    );

    final xOffset = centerScreenOffset.dx - (scaledBoxOffset.dx + (boxWidth * scale) / 2);
    final yOffset = centerScreenOffset.dy - (scaledBoxOffset.dy + (boxHeight * scale) / 2);

    final beginMatrix = widget.controller.matrixController.value.clone();
    final endMatrix = Matrix4.identity()
      ..translate(xOffset, yOffset)
      ..scale(scale, scale);

    _zoomAnimation = Matrix4Tween(begin: beginMatrix, end: endMatrix).animate(
      CurvedAnimation(parent: _zoomAnimationController, curve: Curves.easeInOut),
    );

    widget.controller.setCurrentFocus(boxId);
    widget.controller.status = ZoomStatus.zoomedInStarted;
    _zoomAnimationController.forward(from: 0).then((_) {
      debugPrint('ZOOM IN: AnimationStatus.completed');
      widget.controller.status = ZoomStatus.zoomedIn;
    });
  }
}
