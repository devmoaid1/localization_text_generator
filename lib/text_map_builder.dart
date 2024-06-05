import 'dart:io';

import 'package:localization_text_generator/file_manager.dart';

import 'generate_dart_class.dart';

class TextMapBuilder {
  /// Texts Map
  late Map<String, String> _textsMap;
  /// Texts Map Getter
  Map<String, String> get textsMap => _textsMap;
  late FileManger _fileManger;
  late GenerateDartClasses _generateDartClasses;
  TextMapBuilder(FileManger fileManger,GenerateDartClasses generateDartClasses) {
    _fileManger=fileManger;
    _generateDartClasses=generateDartClasses;
    _textsMap = {};
  }

  /// Builds a Map from a List of String(s) with a value of String and key of
  /// a generated name text{number}
  void generateTextMap(List<Set<String>> texts,List<File> files,Map<String,(String,String)> textsMapQ) {
    for(int i=0; i<files.length;i++){
          // TODO: Get File Content
          String fileContent = files[i].readAsStringSync();
          String newContent = fileContent;
        for(String key in textsMapQ.keys){
         if(textsMapQ[key]!=null) {
           _generateDartClasses.addKey(textsMapQ[key]!.$1);
           fileContent = fileContent.replaceAll(key, 'JsonKeys.${textsMapQ[key]!.$1}.get()');
          textsMap[(textsMapQ[key]!.$1)] = textsMapQ[key]!.$2;
        }
      }

      if(fileContent!=newContent)_fileManger.writeDateToDartFile(_generateDartClasses.importPackageNameFor(filename: 'json_keys.g')+fileContent, files[i]);
    }


  }
}
