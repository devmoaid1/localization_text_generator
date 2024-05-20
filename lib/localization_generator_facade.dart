import 'dart:io';

import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/consts/progress.dart';
import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/console_Ui/printer.dart';
import 'package:localization_text_generator/text_map_builder.dart';
import 'package:localization_text_generator/text_matcher.dart';

import 'console_Ui/progress_bar.dart';
import 'consts/exceptions.dart';

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
  late List<String> _dartFileNames;

  /// Args values initiated in [_initializeArgs]
  String? path;
  String? fileName;
  late bool defaultsToScreensOnly;
  late bool replaceTextWithVariables;

  // Constructor
  LocalizationJsonFacade(List<Arg> args) {
    _initializeArgs(args);
    _textMatcher = TextMatcher();
    _fileManger = FileManger(
        _textMatcher, path == null ? Directory.current : Directory(path!));
    _textMapBuilder = TextMapBuilder();
    _print = PrintHelper();
  }

  _initializeArgs(List<Arg> args) {
    for (Arg arg in args) {
      if (arg.name case Name.path) {
        path = arg.value;
      } else if (arg.name case Name.defaultsToScreensOnly) {
        defaultsToScreensOnly = arg.value;
      } else if (arg.name case Name.replaceTextWithVariables) {
        replaceTextWithVariables = arg.value;
      } else if (arg.name case Name.fileName) {
        fileName = arg.value;
      }
    }
    return;
  }

  /// Listing All Directory Files
  void _getAllFiles() {
    try {
      _dartFiles = _fileManger.listDirectoryDartFiles();
    } catch (e) {
      throw (Exceptions.noFilesFound);
    }
    if (_dartFiles.isEmpty) {
      throw (Exceptions.noFilesFound);
    }
  }

  /// Gets all files within lib folder, and returns files text
  void _fetchAllTexts() {
    try {
     _dartFileNames= _fileManger.getScreensTexts(_dartFiles, defaultsToScreensOnly);
    } catch (e) {
      throw (Exceptions.noTextFound);
    }
    if (_textMatcher.texts.isEmpty) {
      throw (Exceptions.noTextFound);
    }
  }

  /// Creation of texts map
  void _createTextsMap() {
    try {
      _textMapBuilder.generateTextMap(_textMatcher.texts,_dartFileNames);
    } catch (e) {
      throw (Exceptions.couldNotGenerateTextMap);
    }
  }

  /// helper func that generates it all
  void generateLocalizationFile() {
    int current = 0;
    _print.init();
    // Stopwatch watch = Stopwatch()..start();
    ProgressBar bar = ProgressBar(
        total: 100, desc: 'Running localization_text_generator...', width: 70);

    // bar.autoRender();
    try {
      /// Listing Files
      current = 22;
      bar.updateIndexAndDesc(current, Progress.getAllFiles);
      _getAllFiles();
      current = 44;

      /// Fetching all Text
      bar.updateIndexAndDesc(current, Progress.fetchAllText);
      _fetchAllTexts();
      current = 72;
      bar.updateIndexAndDesc(current, Progress.creatingTextMap);

      /// Text Map Creation
      _createTextsMap();
      current = 85;
      bar.updateIndexAndDesc(current, Progress.convertingMapToString);

      /// Converting Map To String
      String localizationContent =
          JsonStringAdapter.convertMapToString(_textMapBuilder.textsMap);
      current = 91;
      bar.updateIndexAndDesc(current, Progress.generatingJsonFile);

      /// Writing JSON File
      _fileManger.writeDataToJsonFile(
        localizationContent,name: fileName
      );
      current = 100;
      bar.updateIndexAndDesc(current, Progress.done, isError: false);
    } catch (err) {
      bar.updateIndexAndDesc(current, err.toString(), isError: true);
      return;
    }
  }
}
