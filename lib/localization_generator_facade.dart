import 'dart:io';

import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/printer.dart';
import 'package:localization_text_generator/progress_bar.dart';
import 'package:localization_text_generator/text_map_builder.dart';
import 'package:localization_text_generator/text_matcher.dart';

/// A Facade-Pattern based class  helping seperating implementation from client`s code and  extracting text into json format to
/// allow easy implementation of translation of any flutter app.
class LocalizationJsonFacade {
  // Text Matcher
  late TextMatcher _textMatcher;
  // File Manager
  late FileManger _fileManger;
  // Text Map Builder
  late TextMapBuilder _textMapBuilder;
  late PrintHelper _print;
  // Constructor
  LocalizationJsonFacade() {
    _textMatcher = TextMatcher();
    _fileManger = FileManger(_textMatcher);
    _textMapBuilder = TextMapBuilder();
    _print = PrintHelper();
  }

  /// Gets all files within lib folder, and returns files text
  void _fetchAllTexts() {
    final dartFiles = _fileManger.listDirectoryDartFiles();
    _fileManger.getScreensTexts(dartFiles);
  }

  /// Creation of texts map
  void _createTextsMap() {
    final texts = _textMatcher.texts;
    if (texts.isNotEmpty) {
      _textMapBuilder.generateTextMap(texts);
    } else {
      _print.error(
          'Could not find any texts to generate, Please Make Sure you are running this command in your project directory.');
    }
  }

  /// helper func that generates it all
  void generateLocalizationFile() {
    _print.init();
    // Stopwatch watch = Stopwatch()..start();
    ProgressBar bar =
        ProgressBar(total: 100, desc: 'Running localization_text_generator...');
    sleep(Duration(seconds: 1));

    // bar.autoRender();
    try {
      /// Fetching all Text
      bar.updateIndexAndDesc(10, 'Fetching All Text...');
      sleep(Duration(seconds: 1));
      _fetchAllTexts();
      bar.updateIndexAndDesc(89, 'Creating Text Map...');
      sleep(Duration(seconds: 1));

      /// Text Map Creation
      _createTextsMap();
      bar.updateIndexAndDesc(96, 'Converting Map To String...');
      sleep(Duration(seconds: 1));

      /// Converting Map To String
      String localizationContent =
          JsonStringAdapter.convertMapToString(_textMapBuilder.textsMap);
      bar.updateIndexAndDesc(98, 'Generating JSON File...');
      sleep(Duration(seconds: 1));

      /// Writing JSON File
      _fileManger.writeDataToFile(
        localizationContent,
      );
    } catch (err) {
      bar.updateIndexAndDesc(100, 'Error Generating Localization File!',
          isError: true);
      return;
    }
    bar.updateIndexAndDesc(
        100, 'Done generating localization file , Happy Editing!',
        isError: false);
  }
}
