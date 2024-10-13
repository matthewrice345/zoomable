import 'package:flutter/material.dart';

class ColoredBoxChild extends StatelessWidget {
  const ColoredBoxChild({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
