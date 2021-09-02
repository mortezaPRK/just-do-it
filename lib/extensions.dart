extension StringParser on String {
  int get asInt {
    return int.parse(replaceAll(',', ''));
  }
}
