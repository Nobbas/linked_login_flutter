import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

typedef OnCloseListener = void Function();
typedef CloseRequestListener = void Function();

class SignInPageController {
  CloseRequestListener _closeRequestListener;
  OnCloseListener _onCloseListener;

  closeSignInPage() {
    if (_closeRequestListener != null) {
      _closeRequestListener();
    }
  }

  addOnCloseListener(OnCloseListener listener) {
    _onCloseListener = listener;
  }
}

class SignInPage extends StatefulWidget {
  final String url;
  final SignInPageController controller;

  const SignInPage({
    Key key,
    this.url,
    @required this.controller,
  })  : assert(controller != null),
        super(key: key);

  @override
  SignInPageState createState() {
    return new SignInPageState();
  }
}

class SignInPageState extends State<SignInPage> {

  bool _isWebViewLaunched = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isWebViewLaunched) {
      FlutterWebviewPlugin webViewPlugin = FlutterWebviewPlugin();
      webViewPlugin.launch(
        widget.url,
        rect: Rect.fromLTWH(
          0.0,
          MediaQuery.of(context).padding.top,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
        ),
      );
      _isWebViewLaunched = true;
    }
    return WillPopScope(
      onWillPop: () {
        print('Popping Scope');
        return Future.value(true);
      },
      child: Scaffold(),
    );
  }

  @override
  dispose() {
    super.dispose();
    if (widget.controller._onCloseListener != null) {
      widget.controller._onCloseListener();
    }
  }

  _initController() {
    widget.controller._closeRequestListener = () {
      Navigator.pop(context);
    };
  }
}
