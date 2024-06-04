import 'dart:io';

import 'package:localization_text_generator/file_manager.dart';

import 'generate_dart_class.dart';

class TextMapBuilder {
  /// Texts Map
  late List<Map<String, String>> _textsMap;
  /// Texts Map Getter
  List<Map<String, String>> get textsMap => _textsMap;
  late FileManger _fileManger;
  late GenerateDartClasses _generateDartClasses;
  TextMapBuilder(FileManger fileManger,GenerateDartClasses generateDartClasses) {
    _fileManger=fileManger;
    _generateDartClasses=generateDartClasses;
    _textsMap = [];
  }

  /// Builds a Map from a List of String(s) with a value of String and key of
  /// a generated name text{number}
  void generateTextMap(List<Set<String>> textsWithoutQuotes,List<Set<String>> textsWithQuotes,List<File> files) {
    for(int i=0; i<textsWithoutQuotes.length;i++){
          // TODO: Get File Content
          String fileContent = files[i].readAsStringSync();

      _textsMap.add({});
      for (int g = 0; g < textsWithoutQuotes[i].length; g++) {
        String key='${files[i].path.split('/').last.split('.').first}_$g';
        _textsMap.last[key] = textsWithoutQuotes[i].elementAt(g);
              _generateDartClasses.addKey(key);
              fileContent=fileContent.replaceAll(textsWithQuotes[i].elementAt(g),'JsonKeys.$key.get()');

      }
      if(_textsMap.last.isNotEmpty)_fileManger.writeDateToDartFile(_generateDartClasses.packageNameFor(filename: 'json_keys.g')+fileContent, files[i]);
    }
    final generatedClasses=_generateDartClasses.run();
    _fileManger.createGeneratedDartFile(generatedClasses.$1, 'json_text_mapper');
    _fileManger.createGeneratedDartFile(generatedClasses.$2, 'json_keys');
   print (generatedClasses.$1);
   print (generatedClasses.$2);

  }
}
