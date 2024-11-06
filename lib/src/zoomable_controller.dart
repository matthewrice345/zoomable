import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable.dart';
import 'package:zoomable/src/zoomable_controller_provider.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

enum ZoomableScaleType {
  value,
  percentage;
}

/// ZoomableController
class ZoomableController extends ChangeNotifier {
  ZoomableController({
    double scaleTo = 1.5,
    double scaleToPercentage = 0.75,
    ZoomableScaleType scaleType = ZoomableScaleType.value,
    bool allowScaleDown = true,
  }) : _scaleTo = scaleTo,
        _scaleToPercentage = scaleToPercentage,
        _scaleType = scaleType,
        _allowScaleDown = allowScaleDown;

  ValueNotifier<bool> get isZoomedNotifier => _isZoomedNotifier;
  final ValueNotifier<bool> _isZoomedNotifier = ValueNotifier(false);

  void setIsZoomed(bool value) {
    _isZoomedNotifier.value = value;
  }

  bool get allowScaleDown => _allowScaleDown;
  late final bool _allowScaleDown;

  ZoomableScaleType get scaleType => _scaleType;
  late final ZoomableScaleType _scaleType;

  double get scaleToPercentage => _scaleToPercentage;
  late double _scaleToPercentage;

  set scaleToPercentage(double value) {
    _scaleToPercentage = value;
    notifyListeners();
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
  final Map<ZoomableId, Zoomable> _zoomables = {};

  void addZoomableBox(ZoomableId id) {
    if(!zoomables.containsKey(id)) {
      _zoomables[id] = Zoomable(id: id, key: GlobalKey());
    }
  }

  void clearZoomableBoxes() {
    _zoomables.clear();
  }

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

  @override
  void dispose() {
    _zoomables.clear();
    super.dispose();
  }

  static ZoomableController of(BuildContext context) {
    final ZoomableControllerProvider? result = context.dependOnInheritedWidgetOfExactType<ZoomableControllerProvider>();
    assert(result != null, 'No ZoomableProvider found in context');
    return result!.controller;
  }

  static ZoomableController? ofMaybe(BuildContext context) {
    final ZoomableControllerProvider? result = context.dependOnInheritedWidgetOfExactType<ZoomableControllerProvider>();
    return result?.controller;
  }
}
