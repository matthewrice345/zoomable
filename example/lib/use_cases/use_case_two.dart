import 'package:exampleZoomable/main.dart';
import 'package:exampleZoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

class UseCaseTwo extends StatefulWidget {
  const UseCaseTwo({super.key, required this.useCase});
  final UseCases useCase;

  @override
  State<UseCaseTwo> createState() => _UseCaseTwoState();
}

class _UseCaseTwoState extends State<UseCaseTwo> {

  late ZoomableController controller;

  @override
  void initState() {
    super.initState();
    controller = ZoomableController(zoomables: [
      Zoomable(id: 'red', key: GlobalKey()),
      Zoomable(id: 'cyan', key: GlobalKey()),
      Zoomable(id: 'green', key: GlobalKey()),
      Zoomable(id: 'purple', key: GlobalKey()),
      Zoomable(id: 'blue', key: GlobalKey()),
      Zoomable(id: 'orange', key: GlobalKey()),
    ]);
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
        builder: (context, key) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ZoomableBox(
                        id: 'red',
                        controller: controller,
                        child: ColoredBoxChild(
                          text: 'Red',
                          color: Colors.red,
                          onTap: () => controller.zoomTo('red'),
                        ),
                      ),
                    ),
                    const Gap(24),
                    Expanded(
                      child: ZoomableBox(
                        id: 'cyan',
                        controller: controller,
                        child: ColoredBoxChild(
                          text: 'Cyan',
                          color: Colors.cyan,
                          onTap: () => controller.zoomTo('cyan'),
                        ),
                      ),
                    ),
                    const Gap(24),
                    Expanded(
                      child: ZoomableBox(
                        id: 'green',
                        controller: controller,
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
              const Gap(24),
              Expanded(
                child: ZoomableBox(
                  id: 'purple',
                  controller: controller,
                  child: ColoredBoxChild(
                    text: 'Purple',
                    color: Colors.purple,
                    onTap: () => controller.zoomTo('purple'),
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
                        controller: controller,
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
                        id: 'orange',
                        controller: controller,
                        child: ColoredBoxChild(
                          text: 'Orange',
                          color: Colors.orange,
                          onTap: () => controller.zoomTo('orange'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
