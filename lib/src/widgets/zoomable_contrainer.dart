import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_controller.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

class ZoomableContainer extends StatefulWidget {
  const ZoomableContainer({
    required ZoomableKey zoomableKey,
    required this.child,
    required this.controller,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.onZoomableChanged,
    this.minScale = 1,
    this.maxScale = 10,
    this.zoomInDuration = const Duration(milliseconds: 500),
    this.zoomOutDuration = const Duration(milliseconds: 500),
  }) : super(key: zoomableKey);

  final Widget child;
  final EdgeInsets padding;
  final Clip clipBehavior;
  final ZoomableListener? onZoomableChanged;
  final ZoomableController controller;
  final double minScale;
  final double maxScale;
  final Duration zoomInDuration;
  final Duration zoomOutDuration;

  @override
  State<ZoomableContainer> createState() => ZoomableContainerState();
}

class ZoomableContainerState extends State<ZoomableContainer> with TickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _zoomInAnimationController;
  late AnimationController _zoomOutAnimationController;
  late Animation<Matrix4> _zoomInAnimation;
  late Animation<Matrix4> _zoomOutAnimation;

  late void Function(AnimationStatus) _zoomInAnimationListener;
  late void Function(AnimationStatus) _zoomOutAnimationListener;

  bool get isZoomed => !isNotZoomed;

  bool get isNotZoomed => _controller.value.getMaxScaleOnAxis() == 1.0;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _controller.value = Matrix4.identity();
    _zoomInAnimationController = AnimationController(
      vsync: this,
      duration: widget.zoomInDuration,
    );
    _zoomOutAnimationController = AnimationController(
      vsync: this,
      duration: widget.zoomOutDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _zoomInAnimationController.dispose();
    _zoomOutAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, parentConstraints) {
        return InteractiveViewer(
          transformationController: _controller,
          constrained: false,
          panEnabled: false,
          scaleEnabled: false,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          clipBehavior: widget.clipBehavior,
          child: SizedBox(
            height: parentConstraints.maxHeight,
            width: parentConstraints.maxWidth,
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  void onZoomTo(ZoomableId id, Offset offset, Size boxSize) {
    if (widget.controller.isAnimating) {
      return;
    }

    final parentSize = ZoomableUtils.getWidgetSize(widget.key as ZoomableKey);
    _centerBox(boxSize, parentSize, offset, id);
  }

  void onZoomOut() {
    final beginMatrix = _controller.value.clone();
    final endMatrix = Matrix4.identity();

    final boxId = widget.controller.currentFocus;
    if (boxId != null) {
      _zoomOutAnimation = Matrix4Tween(begin: beginMatrix, end: endMatrix).animate(
        CurvedAnimation(parent: _zoomOutAnimationController, curve: Curves.easeInOut),
      );
      _zoomOutAnimation.addListener(() => _controller.value = _zoomOutAnimation.value);
      _zoomOutAnimationListener = (status) {
        // AnimationStatus.dismissed
        // AnimationStatus.forward
        // AnimationStatus.completed
        if (status == AnimationStatus.completed) {
          _zoomOutAnimationController.removeStatusListener(_zoomOutAnimationListener);
          _controller.value = Matrix4.identity();
          // These need to remain last.
          widget.controller.currentFocus = null;
          widget.controller.isAnimating = false;
        } else if(status == AnimationStatus.forward) {
          widget.onZoomableChanged?.call(boxId, false);
          widget.controller.setIsZoomed(false);
        }
      };
      _zoomOutAnimation.addStatusListener(_zoomOutAnimationListener);
      _zoomOutAnimationController.forward(from: 0);
    }
  }

  void _onZoomIn(Size boxSize, Size screenSize, Offset boxOffset, String boxId) {
    final boxWidth = boxSize.width;
    final boxHeight = boxSize.height;

    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final maxScaleX = screenWidth / boxWidth;
    final maxScaleY = screenHeight / boxHeight;
    final maxScale = maxScaleX < maxScaleY ? maxScaleX : maxScaleY;

    late double scale;

    if(widget.controller.scaleType == ZoomableScaleType.percentage) {
      scale = _scaleToPercentage(widget.controller.scaleToPercentage, screenSize, boxSize);
      if(widget.controller.allowScaleDown == false && scale < 1.0) {
        scale = 1.0;
      }
    } else {
      scale = maxScale < widget.controller.scaleTo ? maxScale : widget.controller.scaleTo;
    }

    final centerScreenOffset = Offset(screenWidth / 2, screenHeight / 2);
    final scaledBoxOffset = Offset(
      boxOffset.dx * scale,
      boxOffset.dy * scale,
    );
    final xOffset = centerScreenOffset.dx - (scaledBoxOffset.dx + (boxWidth * scale) / 2);
    final yOffset = centerScreenOffset.dy - (scaledBoxOffset.dy + (boxHeight * scale) / 2);

    final beginMatrix = _controller.value.clone();
    final endMatrix = Matrix4.identity()
      ..translate(xOffset, yOffset)
      ..scale(scale, scale);

    _zoomInAnimation = Matrix4Tween(begin: beginMatrix, end: endMatrix).animate(
      CurvedAnimation(parent: _zoomInAnimationController, curve: Curves.easeInOut),
    );

    _zoomInAnimation.addListener(() => _controller.value = _zoomInAnimation.value);
    _zoomInAnimationListener = (status) {
      // AnimationStatus.dismissed
      // AnimationStatus.forward
      // AnimationStatus.completed
      if (status == AnimationStatus.completed) {
        _zoomInAnimationController.removeStatusListener(_zoomInAnimationListener);
        widget.controller.isAnimating = false;
      } else if(status == AnimationStatus.forward) {
        widget.controller.setIsZoomed(true);
        widget.onZoomableChanged?.call(boxId, true);
      }
    };
    _zoomInAnimation.addStatusListener(_zoomInAnimationListener);
    _zoomInAnimationController.forward(from: 0);
    widget.controller.currentFocus = boxId;
  }


  double _scaleToPercentage(double percentage, Size screenSize, Size boxSize) {
    final smallestSide = screenSize.smallest;
    final largestBoxSide = boxSize.biggest;
    final targetBoxSize = smallestSide * percentage;
    return targetBoxSize / largestBoxSide;
  }

  void _centerBox(
    Size boxSize,
    Size screenSize,
    Offset boxOffset,
    String boxId,
  ) {
    setState(() {
      if (boxSize.isZero || screenSize.isZero) {
        return;
      }

      widget.controller.isAnimating = true;
      if (widget.controller.currentFocus == boxId) {
        onZoomOut();
      } else {
        _onZoomIn(boxSize, screenSize, boxOffset, boxId);
      }
    });
  }
}
