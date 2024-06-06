import 'dart:io';

import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/console_Ui/printer.dart';
import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/generate_dart_class.dart';
import 'package:localization_text_generator/text_map_builder.dart';
import 'package:localization_text_generator/text_matcher.dart';

import 'consts/exceptions.dart';
import 'consts/progress_consts.dart';

/// A Facade-Pattern based class  helping separating implementation from client`s code and  extracting text into json format to
/// allow easy implementation of translation of any flutter app.
class LocalizationJsonFacade {
  // Text Matcher
  late TextMatcher _textMatcher;

  // File Manager
  late FileManger _fileManger;
  late PrintHelper _printer;

  // Text Map Builder
  late TextMapBuilder _textMapBuilder;
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

    _generateDartClasses = GenerateDartClasses(_fileManger.currentDirectory.path);

    _textMapBuilder = TextMapBuilder(_fileManger, _generateDartClasses);
    try {
      _printer = PrintHelper();
    } catch (e, s) {
      print(e);
      print(s);
    }
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
      } else if (arg.name case CommandName.exclude) {
        exclude = arg.value;
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
      _acceptedFiles = _fileManger.getScreensTexts(_dartFiles, defaultsToScreensOnly);
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
      _textMapBuilder.generateTextMap(_textMatcher.texts, _acceptedFiles, _textMatcher.data);
    } catch (e) {
      throw (Exceptions.couldNotGenerateTextMap);
    }
  }

  void _generateModelAndEnum() {
    try {
      final generatedClasses = _generateDartClasses.run();
      _fileManger.createGeneratedDartFile(generatedClasses.$1, 'json_text_mapper');
      _fileManger.createGeneratedDartFile(generatedClasses.$2, 'json_keys');
    } catch (e, s) {
      print(s);
      throw (Exceptions.couldNotGenerateModelOrEnum);
    }
  }
void _createJson(){
    try{
      _fileManger.writeDataToJsonFile(_textMapBuilder.textsMap, name: filename);}
        catch(e){
      throw(Exceptions.couldNotCreateJsonFile);
        }
    }

  /// helper func that generates it all
  void generateLocalizationFile() {
    try {
      _printer.addProgress(ProgressConsts.getAllFiles);

      /// Listing Files
      _getAllFiles();

      _printer.updateProgress(ProgressConsts.fetchAllText);

      /// Fetching all Text
      _fetchAllTexts();

      _printer.updateProgress(ProgressConsts.creatingTextMap);

      /// Text Map Creation
      _createTextsMap();
      _printer.updateProgress(ProgressConsts.generatingJsonClass);

      /// Generating Dart model and enum
      _generateModelAndEnum();

      /// Converting Map To String
      // String localizationContent =
      //     JsonStringAdapter.convertMapToJsonString(_textMapBuilder.textsMap, _fileManger.currentDirectory);
      _printer.updateProgress(ProgressConsts.generatingJsonFile);

      /// Writing JSON File
      _createJson();
      _printer.completeProgress();
    } catch (err) {
      _printer.failed(err.toString());

      return;
    }
  }
}
