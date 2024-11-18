import 'package:equatable/equatable.dart';
import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

enum ColorValues {
  blue('blue', Colors.blue),
  green('green', Colors.green),
  red('red', Colors.red),
  purple('purple', Colors.purple),
  orange('orange', Colors.orange);

  const ColorValues(this.id, this.color);
  final String id;
  final Color color;

  static find(String id) {
    return values.firstWhere((element) => element.id == id);
  }
}

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
      scaleType: ZoomableScaleType.value,
      allowScaleDown: false,
    );

    data = [
      const ColorData(value: ColorValues.blue, position: 0),
      const ColorData(value: ColorValues.green, position: 1),
      const ColorData(value: ColorValues.red, position: 2),
      const ColorData(value: ColorValues.orange, position: 3),
      const ColorData(value: ColorValues.purple, position: 4),
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
                  id: data[0].value.id,
                  color: data[0].value.color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
              const Gap(12),
              Expanded(
                child: DraggableItem(
                  id: data[1].value.id,
                  color: data[1].value.color,
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
                  id: data[2].value.id,
                  color: data[2].value.color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
              const Gap(12),
              Expanded(
                child: DraggableItem(
                  id: data[3].value.id,
                  color: data[3].value.color,
                  onTap: (id) => controller.zoomTo(id),
                  swap: swap,
                ),
              ),
              const Gap(12),
              Expanded(
                child: DraggableItem(
                  id: data[4].value.id,
                  color: data[4].value.color,
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
      final z1 = ColorValues.find(to).id;
      final z2 = ColorValues.find(from).id;

      final z1data = data.indexWhere((c) => c.value.id == z1);
      final z2data = data.indexWhere((c) => c.value.id == z2);
      final tempPosZ1 = data[z1data].position;
      data[z1data] = ColorData(value: ColorValues.find(from), position: data[z2data].position);
      data[z2data] = ColorData(value: ColorValues.find(to), position: tempPosZ1);

      controller.swapZoomableOffsets(z1, z2);
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
            builder: (context) => ColoredBoxChild(
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
  const ColorData({required this.value, required this.position});

  final ColorValues value;
  final int position;

  @override
  List<Object?> get props => [value, position];
}
