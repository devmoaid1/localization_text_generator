import 'package:localization_text_generator/file_manager.dart';

void main(List<String> arguments) {
  FileManger fileManger = FileManger();

  // all dart files
  final dartFiles = fileManger.listDirectoryDartFiles();
  final texts = fileManger.getScreensTexts(dartFiles);
  print(texts);
}
