class DetailedException implements Exception{
  final StackTrace? stackTrace;
  final String? message;
  final String? verboseMessage;
  DetailedException({this.stackTrace, required this.message,this.verboseMessage, });
}