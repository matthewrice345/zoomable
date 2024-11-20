import 'package:flutter/widgets.dart';
import 'package:zoomable/src/zoomable.dart';
import 'package:zoomable/src/zoomable_controller_provider.dart';
import 'package:zoomable/src/zoomable_types.dart';
import 'package:zoomable/src/zoomable_utils.dart';

enum ZoomableScaleType {
  value,
  percentage;
}

enum ZoomStatus {
  zoomedIn,
  zoomedInStarted,
  zoomedOut,
  zoomedOutStarted;

  bool get isZoomedIn => this == zoomedIn || this == zoomedInStarted;
  bool get isZoomedOut => this == zoomedOut || this == zoomedOutStarted;
}

/// ZoomableController
class ZoomableController extends ChangeNotifier {
  ZoomableController({
    double scaleTo = 1.5,
    double scaleToPercentage = 0.75,
    ZoomableScaleType scaleType = ZoomableScaleType.value,
    bool allowScaleDown = true,
  })  : _scaleTo = scaleTo,
        _scaleToPercentage = scaleToPercentage,
        _scaleType = scaleType,
        _allowScaleDown = allowScaleDown,
        _matrixController = TransformationController()..value = Matrix4.identity();

  TransformationController get matrixController => _matrixController;
  late final TransformationController _matrixController;

  ValueNotifier<ZoomStatus> get zoomStatusNotifier => _zoomStatusNotifier;
  final ValueNotifier<ZoomStatus> _zoomStatusNotifier = ValueNotifier(ZoomStatus.zoomedOut);

  ZoomStatus get status => _status;
  ZoomStatus _status = ZoomStatus.zoomedOut;
  set status(ZoomStatus value) {
    _status = value;
    _zoomStatusNotifier.value = value;
    notifyListeners();
  }

  // bool get isZoomed => !isNotZoomed;
  // bool get isNotZoomed => matrixController.value.isIdentity();

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

  void clearCurrentFocus() {
    // only clear if zoomed out
    if (status.isZoomedOut) {
      debugPrint("Clearing current focus");
      _currentFocus = null;
      notifyListeners();
    }
  }

  void setCurrentFocus(ZoomableId? id) {
    if (_currentFocus == id) return;
    _currentFocus = id;
    notifyListeners();
  }

  ZoomableKey get zoomableKey => _zoomableKey;
  final ZoomableKey _zoomableKey = GlobalKey();

  Map<ZoomableId, Zoomable> get zoomables => _zoomables;
  final Map<ZoomableId, Zoomable> _zoomables = {};

  void addZoomableBox(ZoomableId id) {
    if (!zoomables.containsKey(id)) {
      debugPrint("Adding zoomable box with id: $id");
      _zoomables[id] = Zoomable(id: id, key: GlobalKey());
    }
  }

  void updateZoomableOffset(ZoomableId id, Offset offset) {
    if (_zoomableOffsets.containsKey(id)) {
      _zoomableOffsets[id] = offset;
    }
  }

  void clearZoomableBoxes() {
    _zoomables.clear();
  }

  final Map<ZoomableId, Offset> _zoomableOffsets = {};

  void swapZoomableOffsets(ZoomableId z1, ZoomableId z2) {
    final tempZ1 = _zoomableOffsets[z1];
    final tempZ2 = _zoomableOffsets[z2];
    if (tempZ2 != null) {
      _zoomableOffsets[z1] = tempZ2;
    }
    if (tempZ1 != null) {
      _zoomableOffsets[z2] = tempZ1;
    }

    notifyListeners();
  }

  void zoomTo(ZoomableId id) {
    final zoomable = zoomables[id];
    if (zoomable != null) {
      if (matrixController.value.isIdentity()) {
        debugPrint('Identity matrix, getting all offsets');
        // Gets the current size for all Zoomables and stores them
        zoomables.forEach((id, zoomable) {
          _zoomableOffsets[id] = ZoomableUtils.calculateChildPosition(
            parentKey: zoomableKey,
            childKey: zoomable.key,
          );
        });
      }

      final boxSize = ZoomableUtils.getWidgetSize(zoomable.key);
      zoomableKey.currentState?.onZoomTo(id, _zoomableOffsets[zoomable.id] ?? Offset.zero, boxSize);
      notifyListeners();
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
