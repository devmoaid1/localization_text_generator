// ignore_for_file: unnecessary_string_interpolations

import 'package:auto_size_text/auto_size_text.dart';
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
        RichText(text: TextSpan(children: [TextSpan(text: 'Richtext')])),
        AutoSizeText("""Example text 6"""),
        AutoSizeText("""Duplicated Text That Should be added once"""),
        AutoSizeText("""Duplicated Text That Should be added once"""),
        AutoSizeText("""Duplicated Text That Should be added once"""),
        AutoSizeText("""Duplicated Text That Should be added once"""),
        Text('''This is a long text
that spans across multiple lines
using triple quotes''')
      ],
    );
  }
}
