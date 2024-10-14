import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

/// ZoomableController
class ZoomableController extends ChangeNotifier {
  ZoomableController({
    required List<Zoomable> zoomables,
    double scaleTo = 1.5,
  })  : _zoomables = Map.fromEntries(
          zoomables.map(
            (zoomable) => MapEntry(zoomable.id, zoomable),
          ),
        ),
        _scaleTo = scaleTo;

  ValueNotifier<bool> get isZoomedNotifier => _isZoomedNotifier;
  final ValueNotifier<bool> _isZoomedNotifier = ValueNotifier(false);

  void setIsZoomed(bool value) {
    _isZoomedNotifier.value = value;
  }

  double get scaleTo => _scaleTo;
  late double _scaleTo;

  set scaleTo(double value) {
    _scaleTo = value;
    notifyListeners();
  }

  ZoomableId? get currentFocus => _currentFocus;
  ZoomableId? _currentFocus;

  set currentFocus(ZoomableId? id) {
    if (_currentFocus == id) return;
    _currentFocus = id;
    notifyListeners();
  }

  bool get isAnimating => _isAnimating;
  bool _isAnimating = false;

  set isAnimating(bool value) {
    if (_isAnimating == value) return;
    _isAnimating = value;
    notifyListeners();
  }

  ZoomableKey get zoomableKey => _zoomableKey;
  final ZoomableKey _zoomableKey = GlobalKey();

  Map<ZoomableId, Zoomable> get zoomables => _zoomables;
  late final Map<ZoomableId, Zoomable> _zoomables;

  final Map<ZoomableId, Offset> _zoomableOffsets = {};

  void setZoomableOffset(ZoomableId id, Offset offset) {
    _zoomableOffsets[id] ??= offset;
  }

  void zoomTo(ZoomableId id) {
    final zoomable = zoomables[id];
    if (zoomable != null) {
      final offset = _zoomableOffsets[id];
      if (offset != null) {
        final boxSize = ZoomableUtils.getWidgetSize(zoomable.key);
        zoomableKey.currentState?.onZoomTo(id, offset, boxSize);
        notifyListeners();
      }
    }
  }

  void zoomOut() {
    zoomableKey.currentState?.onZoomOut();
    notifyListeners();
  }
}
