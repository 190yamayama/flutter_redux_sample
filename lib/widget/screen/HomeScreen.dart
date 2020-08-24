import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/redux/state/AppState.dart';
import 'package:flutter_firebase_app/redux/reducer/AppStateReducer.dart';
import 'package:flutter_firebase_app/redux/action/Actions.dart';
import 'package:flutter_firebase_app/redux/middleware/Authentication.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'SignInScreen.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.store, this.title}) : super(key: key);
  final Store<AppState> store;
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  _ViewModel _viewModel;

  @override
  Widget build(BuildContext context) {

    _viewModel = _ViewModel.fromStore(widget.store);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(_viewModel.displayName + ' さん　ホームですよ〜'),
      ),
      drawer: drawerMenu(widget.store),
    );
  }

  Widget drawerMenu(Store<AppState> store) {
    return new StoreProvider(
      store: store,
      child: new Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('メニュー'),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/splash.png'),
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
                  title: Text('サインアウト'),
                  onTap: () {
                    store.dispatch(SignOutAction());
                  },
                );
              },
              onDidChange: (newState) {
                if (newState.authStatus != AuthStatus.signedIn) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SignInScreen(store: widget.store, title: "Sign in")));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}


class _ViewModel {
  String displayName;
  String email;

  _ViewModel({
    @required this.displayName,
    @required this.email,
  });

  bool isEmpty() {
    if (displayName.isEmpty || email.isEmpty) {
      return true;
    }
    return false;
  }

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      displayName: store.state.authentication.firebaseUser?.displayName ?? "",
      email: store.state.authentication.firebaseUser?.email ?? "",
    );
  }

}