import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/redux/state/AppState.dart';
import 'package:flutter_firebase_app/redux/reducer/AppStateReducer.dart';
import 'package:flutter_firebase_app/redux/action/Actions.dart';
import 'package:flutter_firebase_app/redux/middleware/Authentication.dart';
import 'package:flutter_firebase_app/widget/screen/SplashScreen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = Store<AppState>(
      appReducer,
      initialState: AppState.initState(),
      middleware: [checkAuthStatusMiddleware, signOutMiddleware],
    );

    return new StoreProvider(
        store: store,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Home Screen"),
          ),
          body: Center(
            child: StoreConnector<AppState, Authentication>(
              distinct: true,
              converter: (store) => store.state.authentication,
              builder: (context, authentication) {
                return Text(authentication.firebaseUser.displayName + " さん　ホームですよ〜");
              },
              onInit: (store) {
                store.dispatch(CheckAuthStatusAction());
              },
            ),
            //Text(_viewModel.displayName + " さん　ホームですよ〜"),
          ),
          drawer: new Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text("メニュー"),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/splash.png"),
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                StoreConnector<AppState, Authentication>(
                  distinct: true,
                  converter: (store) => store.state.authentication,
                  builder: (context, _) {
                    return ListTile(
                      title: Text("サインアウト"),
                      onTap: () {
                        store.dispatch(SignOutAction());
                      },
                    );
                  },
                  onInit: (store) {
                    store.dispatch(CheckAuthStatusAction());
                  },
                  onDidChange: (newState) {
                    if (newState.authStatus != AuthStatus.signedIn) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SplashScreen()));
                    }
                  },
                )
              ],
            ),
          ),
        ),
    );
  }

}