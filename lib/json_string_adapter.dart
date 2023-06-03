import 'dart:convert';

class JsonStringAdapter {
  static String convertMapToString(Map<String, String> data) {
    final jsonString = jsonEncode(data);
    return jsonString;
  }
}
