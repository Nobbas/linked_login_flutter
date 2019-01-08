import 'package:linkedin_login_flutter/models/linkedin_login_status.dart';
import 'package:meta/meta.dart';

class LoginResult {
  final LinkedInLoginStatus status;
  final String accessToken;
  final int expiresIn;
  final String firstName;
  final String lastName;
  final String email;
  final String id;
  final String pictureUrl;

  LoginResult({
    @required this.status,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
    this.pictureUrl,
    this.accessToken,
    this.expiresIn,
  }) : assert(status != null);
}
