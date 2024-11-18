import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoomable/zoomable.dart';

/// Use-case 5
///
/// Makes use of the [ZoomableController]s notifier to know when we are zoomed in or out.
/// Hides a widget when zoomed.
class UseCaseFive extends StatefulWidget {
  const UseCaseFive({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseFive> createState() => _UseCaseState();
}

class _UseCaseState extends State<UseCaseFive> {
  late ZoomableController controller;

  @override
  void initState() {
    super.initState();
    controller = ZoomableController(
      // zoomables: [
      //   Zoomable(id: 'red', key: GlobalKey()),
      //   Zoomable(id: 'green', key: GlobalKey()),
      //   Zoomable(id: 'blue', key: GlobalKey()),
      //   Zoomable(id: 'orange', key: GlobalKey()),
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
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: ZoomableBox(
                        id: 'red',
                        builder: (context) => ColoredBoxChild(
                          text: 'Red',
                          color: Colors.red,
                          onTap: () => controller.zoomTo('red'),
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
                          onTap: () => controller.zoomTo('blue'),
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
                          onTap: () => controller.zoomTo('green'),
                        ),
                      ),
                    ),
                    const Gap(24),
                    Expanded(
                      child: ZoomableBox(
                        id: 'orange',
                        builder: (context) => ColoredBoxChild(
                          text: 'Orange',
                          color: Colors.orange,
                          onTap: () => controller.zoomTo('orange'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              ignoring: true,
              child: ValueListenableBuilder(
                valueListenable: controller.isZoomedNotifier,
                builder: (context, isZoomed, _) {
                  return Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 280),
                      opacity: isZoomed ? 0.0 : 1.0,
                      child: const Text(
                        'Zoomable Example!',
                        style: TextStyle(fontSize: 44, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
