import 'dart:convert';
import 'dart:io';

import 'package:code_builder/code_builder.dart';

class GenerateDartClass{

  String run(){
    /// Example
    Class((builder){
      var classBuilder = builder..fields.addAll([Field((c)=>c..static=true..type=Reference('String')..modifier=FieldModifier.constant)]);
    });
    return'';
  }

}

class JsonTextMapper{
   static Map<String,String> json={};
  void init(String path){
    json=jsonDecode(File(path).readAsStringSync());
  }
}