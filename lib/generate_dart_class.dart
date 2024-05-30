import 'dart:convert';
import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class GenerateDartClass{
  String _generateEnums(List<String> ld){
    return '';
  }
  String _generateModel(){
    /// Example
  final modelClass =   Class((builder){
      var classBuilder = builder..fields.add(Field((c)=>c..static=true..type=Reference('String')..modifier=FieldModifier.constant));
    });
  final DartEmitter emitter = DartEmitter();

    return DartFormatter().format('${modelClass.accept(emitter)}');
  }

}

class JsonTextMapper {
   static Map<String,String> json={};
  void init(String path){
    json=jsonDecode(File(path).readAsStringSync());
  }

}