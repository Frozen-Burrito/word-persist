extension DateTimeParsing on DateTime {

  static DateTime fromStringSecondsSinceEpoch(String source) {
    int? millisSinceEpoch = int.tryParse(source);

    return millisSinceEpoch != null 
      ? DateTime.fromMillisecondsSinceEpoch(millisSinceEpoch)
      : DateTime.now();
  }
}