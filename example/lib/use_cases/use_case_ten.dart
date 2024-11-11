import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

/// Use-case 10
///
/// Changing the fundamental layout
class UseCaseTen extends StatefulWidget {
  const UseCaseTen({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseTen> createState() => _UseCaseTen();
}

class _UseCaseTen extends State<UseCaseTen> {
  late ZoomableController controller;

  @override
  void initState() {
    super.initState();
    controller = ZoomableController(
      scaleToPercentage: 0.6,
      scaleType: ZoomableScaleType.percentage,
      allowScaleDown: false,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int _layout = 0;

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
              child: Builder(
                builder: (context) {
                  switch (_layout) {
                    case 0:
                      return _layoutOne(context);
                    default:
                      return _layoutTwo(context);
                  }
                },
              ),
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
                        setState(() => _layout = 0);
                      },
                      child: const Text('Layout One'),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.zoomOut();
                        setState(() => _layout = 1);
                      },
                      child: const Text('Layout Two'),
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
                child: ZoomableBox(
                  id: 'blue',
                  child: ColoredBoxChild(
                    text: 'Blue',
                    color: Colors.blue,
                    borderColor: Colors.blueAccent,
                    onTap: () => controller.zoomTo('blue'),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ZoomableBox(
                  id: 'green',
                  child: ColoredBoxChild(
                    text: 'Green',
                    color: Colors.green,
                    borderColor: Colors.greenAccent,
                    onTap: () => controller.zoomTo('green'),
                  ),
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
                child: ZoomableBox(
                  id: 'red',
                  child: ColoredBoxChild(
                    text: 'Red',
                    color: Colors.red,
                    borderColor: Colors.redAccent,
                    onTap: () => controller.zoomTo('red'),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ZoomableBox(
                  id: 'purple',
                  child: ColoredBoxChild(
                    text: 'Purple',
                    color: Colors.purple,
                    borderColor: Colors.purpleAccent,
                    onTap: () => controller.zoomTo('purple'),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ZoomableBox(
                  id: 'orange',
                  child: ColoredBoxChild(
                    text: 'Orange',
                    color: Colors.orange,
                    borderColor: Colors.orangeAccent,
                    onTap: () => controller.zoomTo('orange'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _layoutTwo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: ZoomableBox(
                  id: 'orange',
                  child: ColoredBoxChild(
                    text: 'Orange',
                    color: Colors.orange,
                    borderColor: Colors.orangeAccent,
                    onTap: () => controller.zoomTo('orange'),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ZoomableBox(
                  id: 'green',
                  child: ColoredBoxChild(
                    text: 'Green',
                    color: Colors.green,
                    borderColor: Colors.greenAccent,
                    onTap: () => controller.zoomTo('green'),
                  ),
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
                child: ZoomableBox(
                  id: 'red',
                  child: ColoredBoxChild(
                    text: 'Red',
                    color: Colors.red,
                    borderColor: Colors.redAccent,
                    onTap: () => controller.zoomTo('red'),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: ZoomableBox(
                  id: 'purple',
                  child: ColoredBoxChild(
                    text: 'Purple',
                    color: Colors.purple,
                    borderColor: Colors.purpleAccent,
                    onTap: () => controller.zoomTo('purple'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
