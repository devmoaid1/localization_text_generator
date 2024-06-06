import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalk_x11.dart';
import 'package:mason_logger/mason_logger.dart';

import 'ansi_logo.dart';

class PrintHelper {
  /// Prints logo + App Name + Version + Generating Localization Message
  factory PrintHelper() {
    _helper._logo();
    return _helper;
  }

  static final PrintHelper _helper = PrintHelper._internal();

  PrintHelper._internal();

  final Logger _print = Logger(theme: LogTheme(success: (s) => chalk.greenX11(s), err: (s) => chalk.red(s)));

  /// Prints the logo in ./ansi_logo.dart
  void _logo() => _print.info(
        logoFile(
          'Localization Text Generator: 0.0.3',
        ),
      );

  // print(chalk.magentaBright(logoFile));
  String msg = '';

  /// app name and version
  // void _nameVersion() => print(());
  late Progress _progress;

  addProgress(String message) {
    msg = message;
    _progress = _print.progress(message);
  }

  updateProgress(String message) {
    _progress.complete(chalk.green(msg));
    msg = message;
    _progress = _print.progress(message);
  }

  completeProgress() => _progress.complete(chalk.green(msg));

  failed(String error) => _progress.fail(chalk.red(error));
}
