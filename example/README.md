# linkedin_login_flutter_example

## How to use

Add dependency.
```dart
dependencies:
  linkedin_login_flutter:
      git:
        url: git@github.com:Nobbas/linked_login_flutter.git
```

Import ```linkedin_login_flutter```.
```dart
import 'package:linkedin_login_flutter/linkedin_login_flutter.dart';
```

Create an instance of ```LinkedInLogin```.
````dart
final linkedInLogin = LinkedInLogin(
  context: context,
  options: LinkedInOptions(
    clientId: 'Your client id here.',
    clientSecret: 'Your client secret here.',
    redirectUrl: 'Your redirect url',
    appBarTitle: 'Your app bar title',
    popUntilPageName: '/',
  ),
);
````

Add Result Listener.
```dart
linkedInLogin.addResultListener((result) {
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
```

Call signIn function.
```dart
linkedInLogin.signIn();
```