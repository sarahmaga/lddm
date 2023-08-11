class SharedVariables {
  static final SharedVariables _singleton = SharedVariables._internal();

  double? inputFontSize, bigFontSize, smallFontSize, iconSize, baseSize;
  String? elderlyId;
  bool? hasCaretaker;
  String? pictureText;

  factory SharedVariables() {
    return _singleton;
  }

  SharedVariables._internal();
}