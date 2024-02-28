class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is Required!';
    }
    return null;
  }

    static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is Required!';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Gender is Required!';
    }
    return null;
  }

  static String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is Required!';
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

