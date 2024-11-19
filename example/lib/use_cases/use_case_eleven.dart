import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

/// Use-case 11
///
/// Test case for the following condition:
/// 1. Zoom into a box
/// 2. Press the setState button. This button will do a zoom out and call setState
/// 3. Zoom in and the zoom offsets will be off.
/// Note: Zooming out resets correctly, zooming in will not.
class UseCaseEleven extends StatefulWidget {
  const UseCaseEleven({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseEleven> createState() => _UseCaseEleven();
}

class _UseCaseEleven extends State<UseCaseEleven> {
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
                child: ZoomableBox(
                  id: 'blue',
                  builder: (context) => ColoredBoxChild(
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
                  builder: (context) => ColoredBoxChild(
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
                  builder: (context) => ColoredBoxChild(
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
                  builder: (context) => ColoredBoxChild(
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
                  builder: (context) => ColoredBoxChild(
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
}
