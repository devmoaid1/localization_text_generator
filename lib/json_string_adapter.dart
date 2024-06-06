import 'dart:convert';

/// Json String Adapter Class
class JsonStringAdapter {
  /// Conversion of Map to string using [jsonEncode] from dart:convert library
     String convertMapToJsonString(Map<String, String> data) {

      // Map<String,String> contentOfJson={};
      //
      //   for (var map in data) {
      //     contentOfJson.addAll(map);
      //   }
      return jsonEncode(data).replaceAll('\\\\', '\\').replaceAll("\\'", "'");
      }
      Map<String,String> convertJsonToMap(String json)=>jsonDecode(json);
}
