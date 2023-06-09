import 'package:chalkdart/chalk.dart';

import 'ansi_logo.dart';

class PrintHelper {
  /// Prints logo + App Name + Version + Generating Localization Message
  void init() {
    _logo();
    _nameVersion();
  }

  /// Prints the logo in ./ansi_logo.dart
  void _logo() => print(chalk.magentaBright(logoFile));

  /// app name and version
  void _nameVersion() => print(
      chalk.black.onBrightMagenta(' Localization Text Generator: 0.0.1 \n'));

  /// prints current task
  String doingTask(String task) => chalk.magentaBright.italic('$task\n');

  /// prints error message
  String error(String errorMsg) => chalk.redBright.bold('$errorMsg\n');

  /// prints done message
  String done(String doneMsg) => chalk.bold.greenBright(doneMsg);
}
