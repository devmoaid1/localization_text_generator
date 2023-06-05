class TextMapBuilder {
  /// Texts Map
  late Map<String, String> _textsMap;

  /// Texts Map Getter
  Map<String, String> get textsMap => _textsMap;

  TextMapBuilder() {
    _textsMap = {};
  }

  /// Builds a Map from a List of String(s) with a key of String and value of
  /// empty String
  void generateTextMap(List<String> texts) {
    for (final text in texts) {
      _textsMap[text] = '';
    }
  }
}
