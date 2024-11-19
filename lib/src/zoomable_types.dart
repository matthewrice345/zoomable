import 'package:flutter/widgets.dart';
import 'package:zoomable/src/widgets/zoomable_animated_container.dart';

typedef ZoomableId = String;

typedef ZoomableKey = GlobalKey<ZoomableAnimatedContainerState>;

typedef ZoomableListener = void Function(ZoomableId id, bool isZoomed);
