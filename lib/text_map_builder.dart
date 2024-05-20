class TextMapBuilder {
  /// Texts Map
  late List<Map<String, String>> _textsMap;

  /// Texts Map Getter
  List<Map<String, String>> get textsMap => _textsMap;

  TextMapBuilder() {
    _textsMap = [];
  }

  /// Builds a Map from a List of String(s) with a value of String and key of
  /// a generated name text{number}
  void generateTextMap(List<Set<String>> texts,List<String> fileNames) {

    for(int i=0; i<texts.length;i++){
      _textsMap.add({});
      for (int g = 0; g < texts[i].length; g++) {
        _textsMap.last['${fileNames[i]}-$g'] = texts[i].elementAt(g);
      }
    }

  }
}
