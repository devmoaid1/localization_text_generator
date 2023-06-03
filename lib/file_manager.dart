import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:localization_text_generator/text_matcher.dart';

class FileManger {
  late TextMatcher _textMatcher;

  FileManger() {
    _textMatcher = TextMatcher();
  }
  List<FileSystemEntity> listDirectoryDartFiles() {
    final dartFiles = Glob('lib/**.dart').listSync();

    return dartFiles;
  }

  (bool, String) checkIfScreenFile(File file) {
    String content = file.readAsStringSync();
    bool isScreenFile = content.contains('StatelessWidget') ||
        content.contains('StatefullWidget');
    return (isScreenFile, content);
  }

  List<String> getScreensTexts(List<FileSystemEntity> dartFiles) {
    for (final file in dartFiles) {
      // iterate over all files and get content
      if (file is File) {
        final result = checkIfScreenFile(file);
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
}
