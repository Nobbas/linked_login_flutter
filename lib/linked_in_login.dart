import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:linkedin_login_flutter/app_convert.dart';
import 'package:linkedin_login_flutter/models/linkedin_login_status.dart';
import 'package:linkedin_login_flutter/models/login_result.dart';
import 'package:linkedin_login_flutter/network_helper.dart';

const String _DEFAULT_APP_BAR_TITLE = "LinkedIn Login";
const String _LINKED_IN_AUTH_URL =
    "https://www.linkedin.com/oauth/v2/authorization";
const String _DEFAULT_ROUTE_NAME = '/lingkedinloginpage';

typedef ResultListener = void Function(LoginResult);

class LinkedInLogin {
  final BuildContext context;
  final LinkedInOptions options;
  ResultListener _listener;
  final webViewPlugin = FlutterWebviewPlugin();

  /// With some websites the [FlutterWebviewPlugin] calls the onUrlChanged
  /// multiple times to ignore the extra events this boolean is used.
  bool _isRedirectedUrlReceived = false;

  LinkedInLogin({
    @required this.context,
    @required this.options,
  }) : assert(context != null && options != null) {
    _init();
  }

  void _init() {
    webViewPlugin.onUrlChanged.listen((url) async {
      // If we are landed on redirect url
      if (AppConvert.toParsedUri(url).origin == this.options.redirectUrl &&
          !_isRedirectedUrlReceived) {
        _isRedirectedUrlReceived = true;

        // Check if query parameters exist
        final auth = AppConvert.convertToAuthCode(url);

        if (auth.code != null && auth.state != null) {
          // TODO: Test if the state is same

          // Get the access code from access API
          NetworkHelper networkHelper = NetworkHelper();

          AccessResponse accessResponse;

          networkHelper
              .getLinkedInAccessToken(AccessOptions(
            code: auth.code,
            clientId: this.options.clientId,
            clientSecret: this.options.clientSecret,
            redirectUrl: this.options.redirectUrl,
          ))
              .then((response) {
            if (response.hasError) {
              throw Exception('Error getting access token.');
            }

            accessResponse = response;
            return networkHelper.getLinkedInInformation(response.accessToken);
          }).then((response) async {
            if (response.hasError) {
              throw Exception('Error getting profile information.');
            }

            _notifyListener(LoginResult(
              status: LinkedInLoginStatus.loggedIn,
              accessToken: accessResponse.accessToken,
              expiresIn: accessResponse.expiresIn,
              id: response.id,
              email: response.email,
              firstName: response.firstName,
              lastName: response.lastName,
              pictureUrl: response.pictureUrl,
            ));

            await webViewPlugin.close();
            _popWebView();
          }).catchError((error) async {
            _notifyListener(LoginResult(status: LinkedInLoginStatus.error));
            await webViewPlugin.close();
            _popWebView();
          });
        }
      }
    });
  }

  void signIn() {
    _isRedirectedUrlReceived = false;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return WebviewScaffold(
            url: _buildAuthUrl(),
            initialChild: Center(
              child: Text('Logged in with LinkedIn! Please close window.'),
            ),
            withJavascript: true,
            appBar: AppBar(
              title: Text(this.options.appBarTitle ?? _DEFAULT_APP_BAR_TITLE),
            ),
          );
        },
        settings: RouteSettings(
          name: _DEFAULT_ROUTE_NAME,
        ),
      ),
    );
  }

  void addResultListener(ResultListener listener) {
    _listener = listener;
  }

  /// Send response to listener provided by user
  void _notifyListener(LoginResult result) {
    if (_listener != null) {
      _listener(result);
    }
  }

  /// Build the complete url for LinkedIn auth code
  String _buildAuthUrl() {
    String url = "$_LINKED_IN_AUTH_URL?response_type=code"
        "&client_id=${this.options.clientId}"
        "&redirect_uri=${this.options.redirectUrl}"
        "&state=testing"
        "&scope=r_basicprofile,r_emailaddress";
    return url;
  }

  void _popWebView() {
    Navigator.popUntil(context, (route) {
      if (route.isFirst) return false;

      return route.settings.name == _DEFAULT_ROUTE_NAME;
    });
  }
}

class LinkedInOptions {
  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final String appBarTitle;

  /// The page you want to pop the web view until
  //final String popUntilPageName;

  LinkedInOptions({
    @required this.clientId,
    @required this.clientSecret,
    @required this.redirectUrl,
    //@required this.popUntilPageName,
    this.appBarTitle,
  }) : assert(redirectUrl != null && clientId != null && clientSecret != null);
}
