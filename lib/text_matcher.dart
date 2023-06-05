/// Where magic happens using regular expressions (regex) to extract text within
/// any dart file
///
class TextMatcher {
  /// private gotten texts
  late List<String> _texts;

  /// texts getter
  List<String> get texts => _texts;

  /// Constructor
  TextMatcher() {
    // initialize texts
    _texts = List.empty(growable: true);
  }

  /// extracts texts from dart file content and adds it to [texts]
  void matchAndExtractTexts(String fileContent) {
    /// Regular Expression for extraction
    final regex = RegExp(
        r'''Text\s*\(\s*(?:(?:"([^"]*)")|(?:'([^']*)')|(?:\\?\$([a-zA-Z_]\w*))|(?:\\?\$\{([^}]*)\})|([a-zA-Z_]\w*))''');

    /// Matching from [fileContent] in matches
    final matches = regex.allMatches(fileContent);
    // Looping over Matches
    for (Match match in matches) {
      final text = match.group(1) ??
          match.group(2) ??
          match.group(3) ??
          match.group(4) ??
          match.group(5) ??
          '';
      // adding to [texts] if not empty
      if (text.isNotEmpty) {
        _texts.add(text);
      }
    }
  }
}
