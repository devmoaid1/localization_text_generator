import 'dart:async';
import 'dart:io';

import 'package:localization_text_generator/console_Ui/printer.dart';

/// A normal bar that fills up when value is updated
///
/// Looks like this:
///
/// Loading : ████████████████████████████████████████.................... 673/1000 67.3% [ 0:00:13.28 / 0:00:06.45 ]

class ProgressBar {
  /// Total number of steps
  final int total;

  int _current = 0;
  int _progress = 0;
  late int max;

  // Time
  final _clock = Stopwatch();

  /// Whether a timer should be present
  final bool time;

  /// Percentage should be displayed or not
  final bool percentage;

  // Decorations

  /// The description of the bar
  final String desc;
  late String _desc;

  /// The character to used as space
  final String space;

  /// The character to used as fill
  final String fill;

  /// Scale of the bar relative to the terminal width
  final double scale;

  /// Width of the bar
  final int? width;

  /// Arguments:
  /// - total : Total number of steps
  /// - desc : Simple text shown before the bar (optional)
  /// - space : Character denoting empty space (default : '.')
  /// - fill : Character denoting filled space (default : '█')
  /// - time : Toggle timing mode (default : false)
  /// - percentage : Toggle percentage display (default : false)
  /// - scale : Scale of the bar relative to width (between: 0 and 1, default: 0.5, Irrelevant if width is specified)
  /// - width : Width of the bar (If not specified, it will be automatically calculated using the terminal width and scale)
  ProgressBar(
      {required this.total,
      this.desc = "",
      this.space = ".",
      this.fill = "█",
      this.time = false,
      this.percentage = false,
      this.scale = 0.5,
      this.width}) {
    _desc = desc;
    // Handles width of the bar, throws an error if it's not specified and the terminal width is not available
    _updateMax();
    if (time) {
      _clock.start();
      scheduleMicrotask(autoRender);
    }
    _render();
  }
  void _updateMax() {
    try {
      max = width ?? ((stdout.terminalColumns - _desc.length) * scale).toInt();
    } on StdoutException {
      throw StdoutException(
          "Could not get terminal width, try specifying a width manually");
    }
  }

  void updateIndexAndDesc(int index, String newDesc, {bool? isError}) {
    _current = index;
    _desc = newDesc;
    _updateMax();
    _render(isError: isError);
  }

  /// Updates the _current value to n
  void updateIndex(int index) {
    _current = index;
    _render();
  }

  /// Automatically updates the frame asynchronously
  void autoRender() async {
    while (_clock.isRunning) {
      await Future.delayed(Duration(seconds: 1));
      _render();
    }
  }

  /// Renders a frame of the bar
  void _render({
    bool? isError,
  }) {
    PrintHelper printer = PrintHelper();
    _progress = ((_current / total) * max).toInt();
    if (_progress >= max) {
      _progress = max;
      if (_clock.isRunning) {
        _clock.stop();
      }
    }
    String timeStr = "";
    if (time) {
      final rate = _clock.elapsedMicroseconds / (_current == 0 ? 1 : _current);
      final eta = Duration(microseconds: ((total - _current) * rate).toInt());
      timeStr =
          "[ ${_clock.elapsed.toString().substring(0, 10)} / ${eta.toString().substring(0, 10)} ]";
    }
    String perc = '';
    if (percentage) {
      perc = "${_current * 100 / total}%";
    }
    String frame =
        "$_desc : ${fill * _progress}${space * (max - _progress)} $_current/$total $perc $timeStr";
    if (isError == null) {
      frame = printer.doingTask(frame);
    } else if (isError) {
      frame = printer.error(frame);
    } else {
      frame = printer.done(frame);
    }
    if (Platform.isWindows) {
      if (stdout.supportsAnsiEscapes) {
        stdout.write('\x1B[2J\x1B[3J\x1B[H');
      } else {
        // Fallback method
        final result = Process.runSync('cmd', ['/c', 'cls']);
        stdout.write(result.stdout);
      }
    } else {
      stdout.write('\x1B[2J\x1B[0;0H');
    }
    printer.init();
    stdout.write(frame);
  }
}
