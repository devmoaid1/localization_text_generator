import 'dart:io';

import 'package:localization_text_generator/file_manager.dart';

class TextMapBuilder {
  /// Texts Map
  late List<Map<String, String>> _textsMap;
  late FileManger _fileManger;
  /// Texts Map Getter
  List<Map<String, String>> get textsMap => _textsMap;

  TextMapBuilder(FileManger fileManger) {
    _textsMap = [];
    _fileManger=fileManger;
  }

  /// Builds a Map from a List of String(s) with a value of String and key of
  /// a generated name text{number}
  void generateTextMap(List<Set<String>> textsWithoutQuotes,List<Set<String>> textsWithQuotes,List<File> files) {

    for(int i=0; i<textsWithoutQuotes.length;i++){
          // TODO: Get File Content
          // String fileContent = files[i].readAsStringSync();

      _textsMap.add({});
      for (int g = 0; g < textsWithoutQuotes[i].length; g++) {
          final parent=files[i].parent.path.split('/').last;
        _textsMap.last['${parent=='lib'?'':'$parent/'}${files[i].path.split('/').last.split('.').first}-$g'] = textsWithoutQuotes[i].elementAt(g);
              // TODO: add file content with replaced data.
              // fileContent=fileContent.replaceAll(textsWithQuotes[i].elementAt(g),'');

      }
      //TODO: Write to dart files back.
      // _fileManger.writeDateToDartFile(fileContent, files[i]);
    }

  }
}
