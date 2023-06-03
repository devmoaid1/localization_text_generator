import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("first text from screen 1"),
        Text('second text from screen 1'),
        Text('third text from screen 1'),
      ],
    );
  }
}
