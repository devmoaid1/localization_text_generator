import 'dart:io';

import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/generate_dart_class.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/text_map_builder.dart';
import 'package:localization_text_generator/text_matcher.dart';

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
  // late Logger _print;
  late List<FileSystemEntity> _dartFiles;
  late List<File> _acceptedFiles;
  late GenerateDartClasses _generateDartClasses;
  /// Args values initiated in [_initializeArgs]
  String? path;
  String? filename;
  List<String>? exclude;
  late bool defaultsToScreensOnly;
  late bool replaceTextWithVariables;

  // Constructor
  LocalizationJsonFacade(List<Arg> args) {
    _initializeArgs(args);
    _textMatcher = TextMatcher();

    _fileManger = FileManger(_textMatcher, path == null ? Directory.current : Directory(path!));

    _generateDartClasses=GenerateDartClasses(_fileManger.currentDirectory.path);

    _textMapBuilder = TextMapBuilder(_fileManger,_generateDartClasses);
    // _print = Logger();
  }

  void _initializeArgs(List<Arg> args) {
    for (Arg arg in args) {
      if (arg.name case CommandName.path) {
        path = arg.value;
      } else if (arg.name case CommandName.screenOnly) {
        defaultsToScreensOnly = arg.value;
      } else if (arg.name case CommandName.replaceTextWithVariables) {
        replaceTextWithVariables = arg.value;
      } else if (arg.name case CommandName.filename) {
        filename = arg.value;
      }else if(arg.name case CommandName.exclude){
        exclude=arg.value;
      }
    }
    return;
  }

  /// Listing All Directory Files
  void _getAllFiles() {
    try {
      _dartFiles = _fileManger.listDirectoryDartFiles(exclude);
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
     _acceptedFiles= _fileManger.getScreensTexts(_dartFiles, defaultsToScreensOnly);
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
      _textMapBuilder.generateTextMap(_textMatcher.texts,_acceptedFiles,_textMatcher.data);
    } catch (e) {

      throw (Exceptions.couldNotGenerateTextMap);
    }
  }

  void _generateModelAndEnum(){
    try{
      final generatedClasses=_generateDartClasses.run();
      _fileManger.createGeneratedDartFile(generatedClasses.$1, 'json_text_mapper');
      _fileManger.createGeneratedDartFile(generatedClasses.$2, 'json_keys');

    }catch(e){
      throw(Exceptions.couldNotGenerateModelOrEnum);
    }
  }

  /// helper func that generates it all
  void generateLocalizationFile() {
    // int current = 0;
    // _print.init();
    // Stopwatch watch = Stopwatch()..start();
    // ProgressBar bar = ProgressBar(
    //     total: 100, desc: 'Running localization_text_generator...', width: 70);

    // bar.autoRender();
    try {
      /// Listing Files
      // current = 22;
      // bar.updateIndexAndDesc(current, Progress.getAllFiles);
      _getAllFiles();
      // current = 44;

      /// Fetching all Text
      // bar.updateIndexAndDesc(current, Progress.fetchAllText);
      _fetchAllTexts();
      // current = 52;
      // bar.updateIndexAndDesc(current, Progress.creatingTextMap);

      /// Text Map Creation
      _createTextsMap();
      // current = 75;
      // bar.updateIndexAndDesc(current, Progress.convertingMapToString);

      _generateModelAndEnum();
      // current = 85;
      // bar.updateIndexAndDesc(current, Progress.generatingJsonClass);
      /// Converting Map To String
      String localizationContent = JsonStringAdapter.convertMapToJsonString(_textMapBuilder.textsMap);
      // current = 91;
      // bar.updateIndexAndDesc(current, Progress.generatingJsonFile);

      /// Writing JSON File
      _fileManger.writeDataToJsonFile(
        localizationContent,name: filename
      );
      // current = 100;
      // bar.updateIndexAndDesc(current, Progress.done, isError: false);
    } catch (err) {
      // bar.updateIndexAndDesc(current, err.toString(), isError: true);
      return;
    }
  }
}
