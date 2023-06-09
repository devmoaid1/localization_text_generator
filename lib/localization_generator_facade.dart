import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/printer.dart';
import 'package:localization_text_generator/text_map_builder.dart';
import 'package:localization_text_generator/text_matcher.dart';

/// A Facade-Pattern based class helping extracting text into json format to
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
    Stopwatch watch = Stopwatch()..start();
    // final bar= FillingBar(total: 100);
    try {
      /// Fetching all Text
      _fetchAllTexts();
      watch.stop();
      print('Fetch All Text${watch.elapsed}');
      watch
        ..reset()
        ..start();

      /// Text Map Creation
      _createTextsMap();
      watch.stop();
      print('Create Text Map${watch.elapsed}');
      watch
        ..reset()
        ..start();

      /// Converting Map To String
      String localizationContent =
          JsonStringAdapter.convertMapToString(_textMapBuilder.textsMap);
      watch.stop();
      print('Map to String: ${watch.elapsed}');
      watch
        ..reset()
        ..start();

      /// Writing JSON File
      _fileManger.writeDataToFile(
        localizationContent,
      );
      watch.stop();
      print('Write Json File: ${watch.elapsed}');
      _print.done('Done generating localization file , Happy Editing!');
    } catch (err) {
      _print.error('Failed to generate localization file!');
    }
  }
}
