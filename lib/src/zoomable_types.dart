import 'package:flutter/widgets.dart';
import 'package:zoomable/src/widgets/zoomable_contrainer.dart';

typedef ZoomableId = String;

typedef ZoomableKey = GlobalKey<ZoomableContainerState>;

typedef ZoomableListener = void Function(ZoomableId id, bool isZoomed);
