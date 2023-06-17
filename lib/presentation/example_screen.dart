import 'package:flutter/material.dart';

/// 'Start Point'
class StartPoint extends StatefulWidget {
  const StartPoint({Key? key}) : super(key: key);

  @override
  State<StartPoint> createState() => _StartPointState();
}

/// Start Point's State
class _StartPointState extends State<StartPoint> {
  @override
  Widget build(BuildContext context) {
    @override
    // ignore: unused_element
    void initState() {
      super.initState();
    }

    return MaterialApp(
      home: ExampleScreen(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/// "ExampleScreen"
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String text = '0 This is a text within a variable';
    final String textTwo = '1 This is the second text variable';
    return Scaffold(
      appBar: AppBar(
        leading: Text('2 This is text within AppBar'),
      ),
      body: Column(
        key: ValueKey('keyyyy'),
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.amber),
          ),
          RichText(
            text: TextSpan(
              text: '3 This is Text',
              children: [
                TextSpan(text: '4 Within'),
                TextSpan(text: "5 Rich Text"),
                TextSpan(text: '6 $text interpolation within another string'),
                //ignore: prefer_interpolation_to_compose_strings
                TextSpan(text: '7' + textTwo + 'interpolated with +'),
              ],
            ),
          ),
          Text('8 This is hard codded text within the Text Widget '),
          Text('8 This is hard \ncodded \rtext within\'the \\Text| /Widget '),
          Text('8 This is hard codded text within the Text Widget '),
          Text(
              '9 This one is Under Construction!\n it will be available soon :) '),
          Text(
              '10 Also, all of Flutter Community Contributions, I hope I\'m not forgetting anyone :\''),
          Text('''11 Triple
          Quoted
          Text\n x
          \\
          ''')
        ],
      ),
    );
  }
}
