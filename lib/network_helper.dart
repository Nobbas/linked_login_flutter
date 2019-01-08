import 'package:http/http.dart' as http;
import 'dart:convert';

const String _LINKED_IN_BASE_URL = "www.linkedin.com";
const String _LINKED_IN_PROFILE_URL =
    "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url)?format=json";

class NetworkHelper {
  Future<AccessResponse> getLinkedInAccessToken(AccessOptions options) async {
    final url = Uri.https(_LINKED_IN_BASE_URL, 'oauth/v2/accessToken', {
      'grant_type': 'authorization_code',
      'code': options.code,
      'redirect_uri': options.redirectUrl,
      'client_id': options.clientId,
      'client_secret': options.clientSecret,
    });

    try {
      final result = await http.post(url);

      if (result.statusCode == 200) {
        final parsedBody = jsonDecode(result.body);
        return AccessResponse(
          hasError: false,
          accessToken: parsedBody['access_token'],
          expiresIn: parsedBody['expires_in'],
        );
      } else {
        return AccessResponse(
          hasError: true,
        );
      }
    } catch (error) {
      return AccessResponse(
        hasError: true,
      );
    }
  }

  Future<LinkedInProfileResponse> getLinkedInInformation(
      String accessToken) async {
    try {
      final response = await http.get(_LINKED_IN_PROFILE_URL,
          headers: {'Authorization': 'Bearer $accessToken'});

      final parsedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LinkedInProfileResponse(
          hasError: false,
          pictureUrl: parsedResponse['pictureUrl'],
          lastName: parsedResponse['lastName'],
          firstName: parsedResponse['firstName'],
          email: parsedResponse['emailAddress'],
          id: parsedResponse['id'],
        );
      } else {
        return LinkedInProfileResponse(hasError: true);
      }
    } catch (error) {
      return LinkedInProfileResponse(hasError: true);
    }
  }
}

class AccessOptions {
  final String code;
  final String clientId;
  final String clientSecret;
  final String redirectUrl;

  AccessOptions({
    this.redirectUrl,
    this.code,
    this.clientId,
    this.clientSecret,
  });
}

class AccessResponse {
  final bool hasError;
  final String accessToken;
  final int expiresIn;

  AccessResponse({
    this.hasError,
    this.accessToken,
    this.expiresIn,
  });
}

class LinkedInProfileResponse {
  final bool hasError;
  final String firstName;
  final String lastName;
  final String email;
  final String id;
  final String pictureUrl;

  LinkedInProfileResponse({
    this.hasError,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
    this.pictureUrl,
  });
}
