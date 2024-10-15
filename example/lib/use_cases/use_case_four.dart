import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

class UseCaseFour extends StatefulWidget {
  const UseCaseFour({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseFour> createState() => _UseCaseState();
}

class _UseCaseState extends State<UseCaseFour> {
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
        child: Row(
          children: [
            Expanded(
              child: ZoomableBox(
                id: 'red',
                child: ColoredBoxChild(
                  text: 'Red',
                  color: Colors.red,
                  onTap: () => controller.zoomTo('red'),
                ),
              ),
            ),
            const Gap(24),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ZoomableBox(
                      id: 'blue',
                      child: ColoredBoxChild(
                        text: 'Blue',
                        color: Colors.blue,
                        onTap: () => controller.zoomTo('blue'),
                      ),
                    ),
                  ),
                  const Gap(24),
                  Expanded(
                    child: ZoomableBox(
                      id: 'green',
                      child: ColoredBoxChild(
                        text: 'Green',
                        color: Colors.green,
                        onTap: () => controller.zoomTo('green'),
                      ),
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
}
