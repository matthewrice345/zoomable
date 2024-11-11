import 'package:example_zoomable/use_cases/use_case_eight.dart';
import 'package:example_zoomable/use_cases/use_case_eleven.dart';
import 'package:example_zoomable/use_cases/use_case_five.dart';
import 'package:example_zoomable/use_cases/use_case_four.dart';
import 'package:example_zoomable/use_cases/use_case_nine.dart';
import 'package:example_zoomable/use_cases/use_case_one.dart';
import 'package:example_zoomable/use_cases/use_case_seven.dart';
import 'package:example_zoomable/use_cases/use_case_six.dart';
import 'package:example_zoomable/use_cases/use_case_ten.dart';
import 'package:example_zoomable/use_cases/use_case_three.dart';
import 'package:example_zoomable/use_cases/use_case_twelve.dart';
import 'package:example_zoomable/use_cases/use_case_two.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoomable',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Example(),
    );
  }
}

enum UseCases {
  one('One'),
  two('Two'),
  three('Three'),
  four('Four'),
  five('Five'),
  six('Six'),
  seven('Seven'),
  eight('Eight'),
  nine('Nine'),
  ten('Ten'),
  eleven('Eleven'),
  twelve('Twelve'),
  ;

  const UseCases(this.title);

  final String title;
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.sizeOf(context).width ~/ 200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoomable Widget'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: UseCases.values.length,
        padding: const EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final useCase = UseCases.values[index];
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      switch (useCase) {
                        case UseCases.one:
                          return UseCaseOne(useCase: useCase);
                        case UseCases.two:
                          return UseCaseTwo(useCase: useCase);
                        case UseCases.three:
                          return UseCaseThree(useCase: useCase);
                        case UseCases.four:
                          return UseCaseFour(useCase: useCase);
                        case UseCases.five:
                          return UseCaseFive(useCase: useCase);
                        case UseCases.six:
                          return UseCaseSix(useCase: useCase);
                        case UseCases.seven:
                          return UseCaseSeven(useCase: useCase);
                        case UseCases.eight:
                          return UseCaseEight(useCase: useCase);
                        case UseCases.nine:
                          return UseCaseNine(useCase: useCase);
                        case UseCases.ten:
                          return UseCaseTen(useCase: useCase);
                        case UseCases.eleven:
                          return UseCaseEleven(useCase: useCase);
                        case UseCases.twelve:
                          return UseCaseTwelve(useCase: useCase);
                      }
                    },
                  ),
                );
              },
              child: Center(child: Text(useCase.title)),
            ),
          );
        },
      ),
    );
  }
}
