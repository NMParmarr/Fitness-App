class AppRegExp {
  /// --- VALID MOBILE NUMBER
  static final RegExp mobileNumberExp = RegExp(r'[6-9][0-9]{9}');

  /// --- VALID EMAIL ID
  static final RegExp emailExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  /// --- VALLID PASSWORD (8 DIGIT, ONE CAP LETTER, ONE SMALL LETTER, ONE NUMBER)
  static final RegExp passwordExp = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
}

extension Validation on String {
  bool get isValidEmail => !this.isEmpty && AppRegExp.emailExp.hasMatch(this);
  bool get isValidPass => !this.isEmpty && AppRegExp.passwordExp.hasMatch(this);
  bool get isValidMobile => !this.isEmpty && AppRegExp.mobileNumberExp.hasMatch(this);
  bool asSameAs(String str) => this == str;
}
