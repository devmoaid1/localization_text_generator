import 'dart:io';

import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/console_Ui/printer.dart';
import 'package:localization_text_generator/exception/detailed_exception.dart';
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
  String? jsonPath;
  List<String>? exclude;
  late bool defaultsToScreensOnly;
  late bool replaceTextWithVariables;
  late bool verbose;
  // Constructor
  LocalizationJsonFacade(List<Arg> args) {
    _printer = PrintHelper();

    _initializeArgs(args);
    _textMatcher = TextMatcher();

    _fileManger = FileManger(_textMatcher, path == null ? Directory.current : Directory(path!));

    _generateDartClasses = GenerateDartClasses(_fileManger.currentDirectory.path);

    _textMapBuilder = TextMapBuilder(_fileManger, _generateDartClasses);

  }

  void _initializeArgs(List<Arg> args) {

    for (Arg arg in args) {
      _printer.print('${arg.name.name}:${arg.value}');
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
      else if( arg.name case CommandName.verbose){
        verbose=arg.value;
      }
      else if(arg.name case CommandName.jsonPath){
        jsonPath=arg.value;
      }
    }
    return;
  }

  /// Listing All Directory Files
  void _getAllFiles() {
    try {
      _dartFiles = _fileManger.listDirectoryDartFiles(exclude);
    } catch (e,s) {
      throw (DetailedException(stackTrace: s, message: Exceptions.noFilesFound,verboseMessage: e.toString()));
    }
    if (_dartFiles.isEmpty) {
      throw (DetailedException( message: Exceptions.noFilesFound,verboseMessage: '_dartFiles is empty'));
    }
  }

  /// Gets all files within lib folder, and returns files text
  void _fetchAllTexts() {
    try {
      _acceptedFiles = _fileManger.getScreensTexts(_dartFiles, defaultsToScreensOnly);
    } catch (e,s) {
      throw (DetailedException(stackTrace: s, message: Exceptions.noTextFound,verboseMessage: e.toString()));

    }
    if (_textMatcher.texts.isEmpty) {
      throw (DetailedException( message: Exceptions.noTextFound,verboseMessage: '_textMatcher.text.isEmpty'));
    }
  }

  /// Creation of texts map
  void _createTextsMap() {
    try {
      _textMapBuilder.generateTextMap(_textMatcher.texts, _acceptedFiles, _textMatcher.data);
    } catch (e,s) {
      throw (DetailedException(stackTrace: s, message: Exceptions.couldNotGenerateTextMap,verboseMessage: e.toString()));

    }
  }

  void _generateModelAndEnum() {
    try {
      final generatedClasses = _generateDartClasses.run();
      _fileManger.createGeneratedDartFile(generatedClasses.$1, 'json_text_mapper');
      _fileManger.createGeneratedDartFile(generatedClasses.$2, 'json_keys');
    } catch (e,s) {
      throw (DetailedException(stackTrace: s, message:Exceptions.couldNotGenerateModelOrEnum,verboseMessage: e.toString()));

    }
  }
void _createJson(){
    try{
      _fileManger.writeDataToJsonFile(_textMapBuilder.textsMap, name: filename,path:jsonPath);}
        catch(e,s){
          throw (DetailedException(stackTrace: s, message:Exceptions.couldNotCreateJsonFile,verboseMessage: e.toString()));

        }
    }

  /// helper func that generates it all
  void generateLocalizationFile() {
    try {
      _printer.showLogo();
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
      _printer.updateProgress(ProgressConsts.generatingJsonFile);

      /// Writing JSON File
      _createJson();
      _printer.completeProgress();
    } on DetailedException catch (e) {

      _printer.failed('${e.message}${verbose?'\n${e.verboseMessage}\n${e.stackTrace}':''}');

      return;
    }
  }
}
