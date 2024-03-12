class Validation {
  static bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  static bool validatePassword(String value) {
    RegExp regex = RegExp('[a-zA-Z0-9]{6,}');
    return regex.hasMatch(value);
  }
}
