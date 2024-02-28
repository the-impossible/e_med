extension StringExtension on String {
  String titleCase() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
