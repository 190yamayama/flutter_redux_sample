import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/redux/state/AppState.dart';
import 'package:flutter_firebase_app/redux/reducer/AppStateReducer.dart';
import 'package:flutter_firebase_app/redux/action/Actions.dart';
import 'package:flutter_firebase_app/redux/middleware/Authentication.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'HomeScreen.dart';
import 'SignInScreen.dart';
import 'SignUpScreen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
    super.initState();

    // Push通知の許可
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    // Push通知の許可・設定(iOS)
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = Store<AppState>(
      appReducer,
      initialState: AppState.initState(),
      middleware: [checkAuthStatusMiddleware],
    );

    return new StoreProvider(
      store: store,
      child:Scaffold(
        body: Center(
          child: StoreConnector<AppState, Authentication>(
            distinct: true,
            converter: (store) => store.state.authentication,
            builder: (context, authState) {
              return Image(image: AssetImage('assets/splash.png'));
            },
            onInit: (store) {
              store.dispatch(CheckAuthStatusAction());
            },
            onDidChange: (authentication) {
              Timer(Duration(seconds: 2), ()
              {
                Navigator.of(context).popUntil((route) => route.isFirst);
                // 置き換えて遷移する（backで戻れないように）
                switch (authentication.authStatus) {
                  case AuthStatus.notSignedIn:
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen())
                    );
                    break;
                  case AuthStatus.signedUp:
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen())
                    );
                    break;
                  case AuthStatus.signedIn:
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen())
                    );
                    break;
                  case AuthStatus.failed:
                    break;
                  case AuthStatus.initState:
                    break;
                }
              });
            },
          ),
        ),
      ),
    );
  }

}