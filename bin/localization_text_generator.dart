import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/localization_generator_facade.dart';

/// Entry Point for the package
void main(List<String> arguments) {
 final List<Arg> args= parseArgs(arguments);

  /// creating object from [LocalizationJsonFacade]
 LocalizationJsonFacade(args).generateLocalizationFile();
}
