class TextMapBuilder {
  late Map<String, String> _textsMap;
  Map<String, String> get textsMap => _textsMap;

  TextMapBuilder() {
    _textsMap = {};
  }

  void generateTextMap(List<String> texts) {
    for (final text in texts) {
      _textsMap[text] = '';
    }
  }
}
