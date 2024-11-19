import 'package:example_zoomable/main.dart';
import 'package:example_zoomable/widgets/colored_box_child.dart';
import 'package:flutter/material.dart';
import 'package:zoomable/zoomable.dart';

/// Use-case 7
///
/// Tests out the percentage scale type
class UseCaseSeven extends StatefulWidget {
  const UseCaseSeven({super.key, required this.useCase});

  final UseCases useCase;

  @override
  State<UseCaseSeven> createState() => _UseCaseState();
}

class _UseCaseState extends State<UseCaseSeven> {
  late ZoomableController controller;

  @override
  void initState() {
    super.initState();
    controller = ZoomableController(
      // zoomables: [
      //   Zoomable(id: 'blue', key: GlobalKey()),
      // ],
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
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                width: MediaQuery.sizeOf(context).width * 0.8,
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
