import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:localization_text_generator/text_matcher.dart';

class FileManger {
  late TextMatcher _textMatcher;
  late Directory _currentDirectory;

  Directory get currentDirectory => _currentDirectory;

  FileManger(TextMatcher textMatcher) {
    _textMatcher = textMatcher;
    _currentDirectory = Directory.current.absolute;
    if (!_currentDirectory.existsSync()) {
      _currentDirectory.createSync(recursive: true);
    }
  }

  List<FileSystemEntity> listDirectoryDartFiles() {
    final dartFiles = Glob('lib/**.dart').listSync();

    return dartFiles;
  }

  (bool, String) _checkIfScreenFile(File file) {
    String content = file.readAsStringSync();
    bool isScreenFile = content.contains('StatelessWidget') ||
        content.contains('StatefullWidget');
    return (isScreenFile, content);
  }

  List<String> getScreensTexts(List<FileSystemEntity> dartFiles) {
    for (final file in dartFiles) {
      // iterate over all files and get content
      if (file is File) {
        final result = _checkIfScreenFile(file);
        bool isScreenFile = result.$1;
        String content = result.$2;
        if (isScreenFile) {
          _textMatcher.matchTextWidgets(content);
          _textMatcher.getAllTexts();
        }
      }
    }

    return _textMatcher.texts;
  }

  void writeDataToFile(String data) {
    final file = File('${_currentDirectory.path}/localization.json');
    file.writeAsStringSync(data);
  }
}
