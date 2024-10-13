import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable_types.dart';

class Zoomable {
  Zoomable({required this.id, required this.key});

  final GlobalKey key;
  final ZoomableId id;
}
