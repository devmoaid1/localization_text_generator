import 'package:localization_text_generator/localization_generator_facade.dart';

/// Entry Point for the package
void main(List<String> arguments) {
  /// creating object from [LocalizationJsonFacade]
  LocalizationJsonFacade localizationGenerator = LocalizationJsonFacade();

  /// Generate Localization in action
  localizationGenerator.generateLocalizationFile();
}
