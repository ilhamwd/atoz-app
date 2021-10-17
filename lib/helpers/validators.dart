class Validators {
  static String? emailValidator(String? email) {
    final regex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-z]+');

    if (email == null || !regex.hasMatch(email)) return "Invalid email!";
  }

  static String? passwordValidator(String? password) {
    if (password == null || password.length < 6) {
      return "Enter at least 6 characters!";
    }
  }
}
