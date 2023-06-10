import 'dart:io';

import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/console_Ui/printer.dart';
import 'package:localization_text_generator/text_map_builder.dart';
import 'package:localization_text_generator/text_matcher.dart';

import 'console_Ui/progress_bar.dart';

/// A Facade-Pattern based class  helping separating implementation from client`s code and  extracting text into json format to
/// allow easy implementation of translation of any flutter app.
class LocalizationJsonFacade {
  // Text Matcher
  late TextMatcher _textMatcher;
  // File Manager
  late FileManger _fileManger;
  // Text Map Builder
  late TextMapBuilder _textMapBuilder;
  late PrintHelper _print;
  late List<FileSystemEntity> _dartFiles;
  // Constructor
  LocalizationJsonFacade() {
    _textMatcher = TextMatcher();
    _fileManger = FileManger(_textMatcher);
    _textMapBuilder = TextMapBuilder();
    _print = PrintHelper();
  }

  /// Listing All Directory Files
  void _getAllFiles() {
    _dartFiles = _fileManger.listDirectoryDartFiles();
    if (_dartFiles.isEmpty) {
      throw ('Could Not Get Any Files, Please Make Sure you are running this command in your project directory.');
    }
  }

  /// Gets all files within lib folder, and returns files text
  void _fetchAllTexts() {
    _fileManger.getScreensTexts(_dartFiles);
    if (_textMatcher.texts.isEmpty) {
      throw ('Could Not Find Any Text, Please Make Sure you are running this command in your project directory.');
    }
  }

  /// Creation of texts map
  void _createTextsMap() {
    // if (_textMatcher.texts.isNotEmpty) {
    try {
      _textMapBuilder.generateTextMap(_textMatcher.texts);
    } catch (e) {
      throw ('Could Not Generate TextMap, Please Add an Issue on our Repo: https://github.com/devmoaid1/localization_text_generator');
    }
    // }
    // else {
    //   throw ('Could not find any texts to generate, Please Make Sure you are running this command in your project directory.');
    // }
  }

  /// helper func that generates it all
  void generateLocalizationFile() {
    _print.init();
    // Stopwatch watch = Stopwatch()..start();
    ProgressBar bar = ProgressBar(
        total: 100, desc: 'Running localization_text_generator...', width: 70);

    // bar.autoRender();
    try {
      /// Listing Files
      bar.updateIndexAndDesc(22, 'Getting All Dart Files...');
      _getAllFiles();

      /// Fetching all Text
      bar.updateIndexAndDesc(44, 'Fetching All Text...');
      _fetchAllTexts();
      bar.updateIndexAndDesc(72, 'Creating Text Map...');

      /// Text Map Creation
      _createTextsMap();

      bar.updateIndexAndDesc(85, 'Converting Map To String...');

      /// Converting Map To String
      String localizationContent =
          JsonStringAdapter.convertMapToString(_textMapBuilder.textsMap);

      bar.updateIndexAndDesc(91, 'Generating JSON File...');

      /// Writing JSON File
      _fileManger.writeDataToFile(
        localizationContent,
      );
      bar.updateIndexAndDesc(100,
          'Done generating localization file Change it to your language and Happy Editing!',
          isError: false);
    } catch (err) {
      bar.updateIndexAndDesc(0, err.toString(), isError: true);
      return;
    }
  }
}
