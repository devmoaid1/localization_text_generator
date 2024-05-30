import 'dart:io';

import 'package:args/args.dart';

enum Name {
  path(true),
  screenOnly(false),
  replaceTextWithVariables(false),
  fileName(true);
  final bool isOptionOrFlag;

  const Name(this.isOptionOrFlag);
}

class Arg {
  final Name name;
  final dynamic value;

  Arg({required this.name, required this.value});
}

List<Arg> parseArgs(List<String> arguments) {
  var parser = ArgParser();
  parser.addOption(Name.path.name,
      abbr: 'p',
      defaultsTo: null,
      help:
          'defaults to current directory if not used, example: "--path=./" or "-p ."');
  print(Directory.current.path);
  parser.addOption(Name.fileName.name,
      abbr: 'n',
      defaultsTo: 'RENAME_THIS',
      help:
          'generated json file name, defaults to: "RENAME_THIS", should be named without ".json".',);
  parser.addFlag(Name.screenOnly.name, defaultsTo: false, help: 'defaults to any screen with "StateFullWidget" or "StatelessWidget" ');
  parser.addFlag(Name.replaceTextWithVariables.name, defaultsTo: false, help: 'replaces all text in dart files with related variable');
  ArgResults results = parser.parse(arguments);
  List<Arg> args = [];
  for (Name name in Name.values) {
    if (name.isOptionOrFlag) {
      args.add(Arg(name: name, value: results.option(name.name)));
    } else {
      args.add(Arg(name: name, value: results.flag(name.name)));
    }
  }
  return args;
}
