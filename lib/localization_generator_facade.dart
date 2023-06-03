import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/text_map_builder.dart';
import 'package:localization_text_generator/text_matcher.dart';

class LocalizationJsonFacade {
  late TextMatcher _textMatcher;
  late FileManger _fileManger;
  late TextMapBuilder _textMapBuilder;

  LocalizationJsonFacade() {
    _textMatcher = TextMatcher();
    _fileManger = FileManger(_textMatcher);
    _textMapBuilder = TextMapBuilder();
  }

  void _fetchAllTexts() {
    final dartFiles = _fileManger.listDirectoryDartFiles();
    _fileManger.getScreensTexts(dartFiles);
  }

  void _createTextsMap() {
    final texts = _textMatcher.texts;
    if (texts.isNotEmpty) {
      _textMapBuilder.generateTextMap(texts);
    } else {
      print('couldn`t find any texts to generate');
    }
  }

  void generateLocalizationFile() {
    try {
      print('generting localization file');
      _fetchAllTexts();
      _createTextsMap();
      String localizationContent =
          JsonStringAdapter.convertMapToString(_textMapBuilder.textsMap);
      _fileManger.writeDataToFile(
        localizationContent,
      );
      print('done generting localization file , happy editing');
    } catch (err) {
      print('failed to generate localization file');
    }
  }
}
