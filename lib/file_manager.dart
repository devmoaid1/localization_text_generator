import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:localization_text_generator/text_matcher.dart';

class FileManger {
  /// TextMatcher for current File
  late TextMatcher _textMatcher;

  /// Current Working Directory
  late Directory _currentDirectory;

  /// Current Working Directory Getter
  Directory get currentDirectory => _currentDirectory;

  /// Constructor
  FileManger(TextMatcher textMatcher) {
    _textMatcher = textMatcher;
    _currentDirectory = Directory.current.absolute;
    if (!_currentDirectory.existsSync()) {
      _currentDirectory.createSync(recursive: true);
    }
  }

  /// List Directories inside lib folder
  List<FileSystemEntity> listDirectoryDartFiles() {
    final dartFiles = Glob('lib/**.dart').listSync();

    return dartFiles;
  }

  /// Using Dart's New Record Feature, Checking if file has a screen  widget currently works on StatelessWidget(s) and
  /// StatefulWidget(s)
  (bool, String) _checkIfScreenFile(File file) {
    String content = file.readAsStringSync();
    bool isScreenFile = content.contains('package:flutter/material.dart') ||
        content.contains('package:flutter/cupertino.dart');
    return (isScreenFile, content);
  }

  /// Get Scree
  Set<String> getScreensTexts(List<FileSystemEntity> dartFiles) {
    for (final file in dartFiles) {
      // iterate over all files and get content
      if (file is File) {
        final result = _checkIfScreenFile(file);
        bool isScreenFile = result.$1;
        String content = result.$2;
        if (isScreenFile) {
          _textMatcher.matchAndExtractTexts(content);
          // _textMatcher.getAllTexts();
        }
      }
    }

    return _textMatcher.texts;
  }

  void writeDataToFile(String data) {
    try {
      final file =
          File('${_currentDirectory.path}/RENAME_TO_YOUR_LANGUAGE.json');
      file.writeAsStringSync(data);
    } catch (e) {
      throw ('Could Not Write JSON File...');
    }
  }
}
