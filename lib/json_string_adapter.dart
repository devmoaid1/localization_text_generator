import 'dart:convert';

/// Json String Adapter Class
class JsonStringAdapter {
  /// Conversion of Map to string using [jsonEncode] from dart:convert library
  static String convertMapToString(Map<String, String> data) =>
      jsonEncode(data).replaceAll('\\\\', '\\').replaceAll("\\'", "'");
}
