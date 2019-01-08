class AuthCode {
  final String code;
  final String state;

  AuthCode({
    this.code,
    this.state,
  });

  @override
  String toString() {
    return "{code:$code, state:$state}";
  }
}
