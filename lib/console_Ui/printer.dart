import 'package:mason_logger/mason_logger.dart';

import 'ansi_logo.dart';

class PrintHelper {
  /// Prints logo + App Name + Version + Generating Localization Message
  factory PrintHelper() {
   _helper._logo();
    return _helper;
  }
  static final PrintHelper _helper=  PrintHelper._internal();

  PrintHelper._internal();
  final Logger _print= Logger();

  /// Prints the logo in ./ansi_logo.dart
  void _logo() =>  _print.info(logoFile('Localization Text Generator: 0.0.3',),);
      // print(chalk.magentaBright(logoFile));

  /// app name and version
  // void _nameVersion() => print(());
  late Progress _progress;
  addProgress(String message)=> _progress=_print.progress(message);

  updateProgress(String message) {
    _progress.complete();
    _progress=_print.progress(message);
  }
  completeProgress()=>_progress.complete();

  failed(String error)=> _progress.fail(error);
  // /// prints current task
  // String doingTask(String task) => chalk.magentaBright.italic('$task\n');
  //
  // /// prints error message
  // String error(String errorMsg) => chalk.redBright.bold('$errorMsg\n');
  //
  // /// prints done message
  // String done(String doneMsg) => chalk.bold.greenBright(doneMsg);
}
