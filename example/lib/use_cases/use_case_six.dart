import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

/// Use-case 6
///
/// Tests out the percentage scale type
class UseCaseSix extends StatefulWidget {
  const UseCaseSix({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseSix> createState() => _UseCaseState();
}

class _UseCaseState extends State<UseCaseSix> {
  late ZoomableController controller;

  @override
  void initState() {
    super.initState();
    controller = ZoomableController(
      // zoomables: [
      //   Zoomable(id: 'red', key: GlobalKey()),
      //   Zoomable(id: 'green', key: GlobalKey()),
      //   Zoomable(id: 'blue', key: GlobalKey()),
      // ],
      scaleToPercentage: 1.0,
      scaleType: ZoomableScaleType.percentage,
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
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 200,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
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
                    const Gap(24),
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
                    const Gap(24),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
