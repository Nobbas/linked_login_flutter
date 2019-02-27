import 'package:flutter/material.dart';
import 'package:linkedin_login_flutter/linkedin_login_flutter.dart';
import 'package:linkedin_login_flutter_example/linked_in_config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LinkedIn Login'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Login with LinkedIn'),
          onPressed: () {
            final linkedInLogin = LinkedInLogin(
              context: context,
              options: LinkedInOptions(
                clientId: LinkedInConfig.CLIENT_ID,
                clientSecret: LinkedInConfig.CLIENT_SECRET,
                redirectUrl: LinkedInConfig.REDIRECT_URL,
                appBarTitle: 'Your app bar title',
              ),
            );

            linkedInLogin.addResultListener((result) {
              print(result.status);

              switch (result.status) {
                case LinkedInLoginStatus.loggedIn:
                  {
                    print(result.accessToken);
                    print(result.firstName);
                    break;
                  }
                case LinkedInLoginStatus.error:
                  {
                    break;
                  }
              }
            });

            linkedInLogin.signIn();
          },
        ),
      ),
    );
  }
}
