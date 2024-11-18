import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

/// Use-case 9
///
/// Tests out the percentage scale type
class UseCaseNine extends StatefulWidget {
  const UseCaseNine({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseNine> createState() => _UseCaseNine();
}

class _UseCaseNine extends State<UseCaseNine> {
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
        onZoomableChanged: (id, zoomed) {
          debugPrint('Zoomable $id is zoomed: $zoomed');
        },
        controller: controller,
        child: LayoutBuilder(
          builder: (context, constraints) {
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
              ],
            );
          }
        ),
      ),
    );
  }
}
