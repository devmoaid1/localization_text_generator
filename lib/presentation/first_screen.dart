// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    final value = '';
    return Column(
      children: [
        Text(
          "first text from screen 1",
          style: TextStyle(),
        ),
        Text('second text from screen 1'),
        Text('third text from screen 1'),
        Text(
          '$value',
        ),
        Text(
          value,
        ),
        Text(
          value,
          style: TextStyle(),
        ),
      ],
    );
  }
}
