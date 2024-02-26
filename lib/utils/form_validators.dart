class FormValidator {
  static String? validateRegNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Valid RegNo is Required!';
    }
    return null;
  }

    static String? validatePosition(String? value) {
    if (value == null || value.isEmpty) {
      return 'Position is Required!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is Required!';
    } else if (value.length < 6) {
      return 'Password should be at least 6 characters!';
    }
    return null;
  }

 }

