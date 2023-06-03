import 'package:flutter/material.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('first text from screen 2'),
        Text('second text from screen 2'),
        Text('third text from screen 2'),
      ],
    );
  }
}
