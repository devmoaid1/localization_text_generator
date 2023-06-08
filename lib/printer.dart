import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalk_x11.dart';

import 'ansi_logo.dart';

class PrintHelper {
  /// Prints logo + App Name + Version + Generating Localization Message
  void init() {
    _logo();
    _nameVersion();
    doingTask('Generating localization file...');
  }

  /// Prints the logo in ./ansi_logo.dart
  void _logo() => print(chalk.magentaBright(logoFile));

  /// app name and version
  void _nameVersion() => print(
      chalk.black.onBrightMagenta(' Localization Text Generator: 1.0.0 \n'));

  /// prints current task
  void doingTask(String task) => print(chalk.yellowGreen.italic('$task\n'));

  /// prints error message
  void error(String errorMsg) => print(chalk.redBright.bold('$errorMsg\n'));

  /// prints done message
  void done(String doneMsg) => print(chalk.bold.greenBright(doneMsg));
}
