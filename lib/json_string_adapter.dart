import 'dart:convert';

/// Json String Adapter Class
class JsonStringAdapter {
  /// Conversion of Map to string using [jsonEncode] from dart:convert library
    static String convertMapToJsonString(List<Map<String, String>> data) {

      Map<String,String> contentOfJson={};

        for (var map in data) {
          contentOfJson.addAll(map);
        }
      return jsonEncode(contentOfJson).replaceAll('\\\\', '\\').replaceAll("\\'", "'");
      }
}
