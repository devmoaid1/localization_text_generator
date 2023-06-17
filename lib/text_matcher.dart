/// Where magic happens using regular expressions (regex) to extract text within
/// any dart file
///
class TextMatcher {
  /// private gotten texts
  late Set<String> _texts;

  /// texts getter
  Set<String> get texts => _texts;

  /// Constructor
  TextMatcher() {
    // initialize texts
    _texts = <String>{};
  }

  /// extracts texts from dart file content and adds it to [texts]
  void matchAndExtractTexts(String fileContent) {
    //  RegExp(
    //       r'''(?:Text(?:Span|Painter|Theme|Button|Form|Field|FormField|Input|EditingController)?|AutoSizedText|RichText)\s*\(\s*(?:text:\s*)?(['"]{1,3})((?:.|[\r\n])*?)\1\s*(?:,|\))''',
    //       multiLine: true)
    /// Regular Expression for extraction
    final regex = RegExp(
        r'''(?<!import\s)(?<!Key\()(['"])((?:\\\1|(?!\1).)*)\1''',
        multiLine: true);

    /// Matching from [fileContent] in matches
    final matches = regex.allMatches(fileContent);
    // Looping over Matches
    for (Match match in matches) {
      if (match.groupCount != 0) {
        final text = match.group(2) ??
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
}
