
import 'package:args/args.dart';

enum CommandType { option, flag, multiOption }

enum CommandName {
  path(CommandType.option),
  jsonPath(CommandType.option),
  screenOnly(CommandType.flag),
  replaceTextWithVariables(CommandType.flag),
  filename(CommandType.option),
  exclude(CommandType.multiOption),
  verbose(CommandType.flag);
  final CommandType type;

  const CommandName(this.type);
}

class Arg {
  final CommandName name;
  final dynamic value;

  Arg({required this.name, required this.value});
}

List<Arg> parseArgs(List<String> arguments) {
  var parser = ArgParser();
  /// Multi-Option
  /// ----------------------------------
  parser.addMultiOption(CommandName.exclude.name, abbr: 'e', defaultsTo: null,help: 'exclude a directory or a path | uses .contain on file paths');

  /// Options
  /// ----------------------------------
  // path
  parser.addOption(CommandName.path.name,
      abbr: 'p', defaultsTo: null, help: 'defaults to current directory if not used, example: "--path=./" or "-p ."');
  // json path
  parser.addOption(CommandName.jsonPath.name,defaultsTo: '');
  // filename
  parser.addOption(
    CommandName.filename.name,
    abbr: 'n',
    defaultsTo: 'RENAME_THIS',
    help: 'generated json file name, defaults to: "RENAME_THIS", should be named without ".json".',
  );
  /// Flags
  /// ----------------------------------
  parser.addFlag(CommandName.verbose.name,abbr: 'v',defaultsTo: false,help: 'if verbose or not');

  parser.addFlag(CommandName.screenOnly.name,
      defaultsTo: true, help: 'defaults to any screen with "StateFullWidget" or "StatelessWidget" ');
  parser.addFlag(CommandName.replaceTextWithVariables.name, defaultsTo: false, help: 'replaces all text in dart files with related variable');
  /// ----------------------------------
  /// ----------------------------------
  ArgResults results = parser.parse(arguments);
  List<Arg> args = [];
  for (CommandName name in CommandName.values) {
    if (name.type case CommandType.option) {
      args.add(Arg(name: name, value: results.option(name.name)));
    } else if (name.type case CommandType.flag) {
      args.add(Arg(name: name, value: results.flag(name.name)));
    } else if (name.type case CommandType.multiOption) {
      args.add(Arg(name: name, value: results.multiOption(name.name)));
    }
  }
  return args;
}
