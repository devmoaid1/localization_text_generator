class TextMatcher {
  late List<String> _textWidgets;
  late List<String> _texts;

  List<String> get textWidgets => _textWidgets;
  List<String> get texts => _texts;

  TextMatcher() {
    // intialize texts and textwidgets
    _textWidgets = List.empty(growable: true);
    _texts = List.empty(growable: true);
  }

  void matchTextWidgets(String fileContent) {
    final textMatches = RegExp(r'Text\((.*?)\)')
        .allMatches(fileContent)
        .toList(); // get all matches for  Text() widgets
    if (textMatches.isNotEmpty) {
      for (final match in textMatches) {
        // for each mach if not null add it to list
        final textWidget = match.group(0);
        if (textWidget != null) {
          _textWidgets.add(textWidget);
        }
      }
    }
  }

  String _extractText(String textWidget) {
    String text = '';
    RegExp regExp = RegExp(
        r'''['"](.+?)['"]'''); // regex for getting content between '' or ""

    RegExpMatch? textMatch = regExp.firstMatch(textWidget);
    if (textMatch != null) {
      text = textMatch.group(1) ?? ''; // get content from match
    }
    return text;
  }

  void getAllTexts() {
    if (_textWidgets.isNotEmpty) {
      // iterate over all text widgets
      for (final textWidget in _textWidgets) {
        final text = _extractText(textWidget); // get text for each text widget
        if (text.isNotEmpty) {
          _texts.add(text);
        }
      }
    }
  }
}
