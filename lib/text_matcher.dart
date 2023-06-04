class TextMatcher {
  late List<String> _texts;

  List<String> get texts => _texts;

  TextMatcher() {
    // intialize texts

    _texts = List.empty(growable: true);
  }

  void matchAndExtractTexts(String fileContent) {
    final regex = RegExp(
        r'''Text\s*\(\s*(?:(?:"([^"]*)")|(?:'([^']*)')|(?:\\?\$([a-zA-Z_]\w*))|(?:\\?\$\{([^}]*)\})|([a-zA-Z_]\w*))''');
    final matches = regex.allMatches(fileContent);

    for (Match match in matches) {
      final text = match.group(1) ??
          match.group(2) ??
          match.group(3) ??
          match.group(4) ??
          match.group(5) ??
          '';
      if (text.isNotEmpty) {
        _texts.add(text);
      }
    }
  }
}
