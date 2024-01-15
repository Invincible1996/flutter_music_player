extension StringExtension on String {
  // get file name from path
  String get fileName => split('/').last;

  // get file extension from path
  String get fileExtension => split('.').last;

  // get file name without extension from path and remove . from file name
  String get fileNameWithoutExtension =>
      fileName.replaceAll(RegExp(r'\.' + fileExtension), '');
}
