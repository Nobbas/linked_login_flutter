import 'package:linkedin_login_flutter/models/auth_code.dart';

/// Convenience class that contains all the conversions
class AppConvert {
  static Uri toParsedUri(String url) {
    return Uri.parse(url);
  }

  static AuthCode convertToAuthCode(String url) {
    final parsedUri = toParsedUri(url);
    final AuthCode code = AuthCode(
      code: parsedUri.queryParameters['code'],
      state: parsedUri.queryParameters['state'],
    );
    return code;
  }
}