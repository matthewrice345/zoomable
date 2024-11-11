import 'package:equatable/equatable.dart';
import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

/// Use-case 12
///
/// Test case for dragging and dropping.
class UseCaseTwelve extends StatefulWidget {
  const UseCaseTwelve({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseTwelve> createState() => _UseCaseTwelve();
}

class _UseCaseTwelve extends State<UseCaseTwelve> {
  late ZoomableController controller;

  List<ColorData> data = [];

  @override
  void initState() {
    super.initState();
    controller = ZoomableController(
      scaleToPercentage: 0.6,
      scaleType: ZoomableScaleType.percentage,
      allowScaleDown: false,
    );

    data = [
      const ColorData(id: 'blue', color: Colors.blue),
      const ColorData(id: 'green', color: Colors.green),
      const ColorData(id: 'red', color: Colors.red),
      const ColorData(id: 'purple', color: Colors.purple),
      const ColorData(id: 'orange', color: Colors.orange),
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.useCase.title),
        centerTitle: true,
      ),
      body: ZoomableWidget(
        padding: const EdgeInsets.all(30),
        clipBehavior: Clip.none,
        onZoomableChanged: (id, zoomed) {
          debugPrint('Zoomable $id is zoomed: $zoomed');
        },
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _layoutOne(context),
            ),
            const Gap(12),
            SizedBox(
              height: 52,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.zoomOut();
                        setState(() {});
                      },
                      child: const Text('SetState'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutOne(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: DraggableItem(
                  id: data[0].id,
                  color: data[0].color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
              const Gap(12),
              Expanded(
                child: DraggableItem(
                  id: data[1].id,
                  color: data[1].color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
            ],
          ),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: DraggableItem(
                  id: data[2].id,
                  color: data[2].color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
              const Gap(12),
              Expanded(
                child: DraggableItem(
                  id: data[3].id,
                  color: data[3].color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
              const Gap(12),
              Expanded(
                child: DraggableItem(
                  id: data[4].id,
                  color: data[4].color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void swap(String to, String from) {
    debugPrint('Swapping $from with $to');
    setState(() {
      final fromIndex = data.indexWhere((element) => element.id == from);
      final toIndex = data.indexWhere((element) => element.id == to);
      final temp = data[fromIndex];
      data[fromIndex] = data[toIndex];
      data[toIndex] = temp;

      // resets the offsets so that the next build they can reset.
      controller.resetZoomableOffset(to);
      controller.resetZoomableOffset(from);
    });
  }
}

class DraggableItem extends StatelessWidget {
  const DraggableItem({super.key, required this.id, required this.color, required this.onTap, required this.swap});

  final String id;
  final Color color;
  final void Function(String id) onTap;
  final void Function(String to, String from) swap;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (details) async {
        swap(details.data, id);
      },
      builder: (context, candidateData, rejectedData) {
        return LongPressDraggable<String>(
          data: id,
          onDragStarted: () {},
          onDragEnd: (_) {},
          onDragCompleted: () {},
          onDraggableCanceled: (_, __) {},
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 100, width: 100,
              child: Opacity(
                key: ValueKey('feedback_$key'),
                opacity: 0.5,
                child: ColoredBoxChild(
                  text: id,
                  color: color,
                  borderColor: Colors.white10,
                  onTap: () => onTap(id),
                ),
              ),
            ),
          ),
          childWhenDragging: Material(
            color: Colors.transparent,
            child: Opacity(
              key: ValueKey('childWhenDragging_$key'),
              opacity: 0.5,
              child: ColoredBoxChild(
                text: id,
                color: color,
                borderColor: Colors.white10,
                onTap: () => onTap(id),
              ),
            ),
          ),
          child: ZoomableBox(
            key: ValueKey('child_$key'),
            id: id,
            child: ColoredBoxChild(
              text: id,
              color: color,
              borderColor: Colors.white10,
              onTap: () => onTap(id),
            ),
          ),
        );
      },
    );
  }
}

class ColorData extends Equatable {
  const ColorData({required this.id, required this.color});

  final String id;
  final Color color;

  @override
  List<Object?> get props => [id, color];
}
