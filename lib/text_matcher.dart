/// Where magic happens using regular expressions (regex) to extract text within
/// any dart file
///
class TextMatcher {
  /// private gotten texts
  late List<Set<String>> _texts;
  late List<Set<String>> _textsWithQuotes;

  /// texts getter
  List<Set<String>> get texts => _texts;

  List<Set<String>> get textsWithQuotes => _textsWithQuotes;
  Map<String, bool> data = {};

  /// Constructor
  TextMatcher() {
    // initialize texts
    _texts = [];
    _textsWithQuotes = [];
  }

  /// extracts texts from dart file content and adds it to [texts]
  void matchAndExtractTexts(String fileContent,String path) {

    _texts.add({});
    _textsWithQuotes.add({});

    /// Regular Expression for extraction
    final textExtractorExpression = RegExp(r'''(?<!import\s)(?<!fontFamily:\s)(?<!{\s)(?<!//\s)(?<!Key\()(?<!print\()(?<!log\()(?<!RegExp\()(?<!^\/\/\/?\s*)(['"])((?:\\\1|(?!\1).)*)\1''', multiLine: true);

    /// Matching from [fileContent] in matches
    final matches = textExtractorExpression.allMatches(fileContent);
    // Looping over Matches
    for (Match match in matches) {
      if (match.groupCount != 0) {
        final textWithQuotes = match.group(0) ?? '';
        final text = (match.group(2) ?? match.group(3) ?? match.group(4) ?? match.group(5) ?? '').trim();
        final Uri? link = Uri.tryParse(text);
        final bool isNotLink = link == null ? true : !(link.isAbsolute);
        final containsEnglish =
        RegExp(r"[a-zA-Z-/*#&$@!_().{};><?,+=؛؟،:‘`%^€¥£|'\[\]\\]")
        // RegExp(r"[a-zA-Z^€¥£|'\[\]\\]")
            .hasMatch(text);
        /// adding to [_texts] and [textsWithQuotes]
        if (text.length>1 &&
            // text.contains('assets/') == false &&
            // text.contains('\$') == false &&
            // text.contains('{') == false &&
            // text.contains('}') == false &&
            isNotLink
            && !containsEnglish
        ) {
          if (textWithQuotes.isNotEmpty) _textsWithQuotes.last.add(match.group(0)!);
          if (data.containsKey(text) == false) {
            data[text] = true;
            _texts.last.add(text);
          }
        }
      }
    }
    print(data);
  }
}
