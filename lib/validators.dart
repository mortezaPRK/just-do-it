import './strings.dart' as str;

String validateEmptyString(String value) {
  if (value.isEmpty) {
    return str.shouldNotBeEmptyMessage;
  }
  return null;
}
