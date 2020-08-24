import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/redux/state/AppState.dart';
import 'package:flutter_firebase_app/redux/reducer/AppStateReducer.dart';
import 'package:flutter_firebase_app/redux/action/Actions.dart';
import 'package:flutter_firebase_app/redux/middleware/Authentication.dart';
import 'package:flutter_firebase_app/widget/component/PrimaryButton.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:redux/redux.dart';

import 'HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key, this.store, this.title}) : super(key: key);
  final Store<AppState> store;
  final String title;

  static final formKey = new GlobalKey<FormState>();

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  _ViewModel _viewModel;

  bool isValidate() {
    final form = SignUpScreen.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    _viewModel = _ViewModel.fromStore(widget.store);

    final ProgressDialog progress = new ProgressDialog(context);
    return new StoreProvider(
        store: widget.store,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text(widget.title),
            ),
            backgroundColor: Colors.grey[300],
            body: new SingleChildScrollView(child: new Container(
                padding: const EdgeInsets.all(16.0),
                child: new Column(
                    children: [
                      hintText(),
                      new Card(
                          child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: new Form(
                                        key: SignUpScreen.formKey,
                                        child: new Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            displayNameText(),
                                            emailText(),
                                            passwordText(),
                                            singUpButton(widget.store, progress),
                                            signInButton(),
                                          ],
                                        )
                                    )
                                ),
                              ])
                      ),
                    ]
                )
            ))
        )
    );
  }

  Widget displayNameText() {
    return padded(child: new TextFormField(
      key: new Key('displayName'),
      decoration: new InputDecoration(labelText: 'DisplayName'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? '表示名称を入力してください' : null,
      onSaved: (val) => {
        _viewModel.displayName = val
      },
    ));
  }

  Widget emailText() {
    return padded(child: new TextFormField(
      key: new Key('email'),
      decoration: new InputDecoration(labelText: 'Email'),
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'emailを入力してください' : null,
      onSaved: (val) => {
        _viewModel.email = val
      },
    ));
  }

  Widget passwordText() {
    return padded(child: new TextFormField(
      key: new Key('password'),
      decoration: new InputDecoration(labelText: 'Password'),
      obscureText: true,
      autocorrect: false,
      validator: (val) => val.isEmpty ? 'パスワードを入力してください' : null,
      onSaved: (val) => {
        _viewModel.password = val
      },
    ));
  }

  Widget singUpButton(Store<AppState> store, ProgressDialog progress) {
    return StoreConnector<AppState, Authentication>(
      distinct: true,
      converter: (store) => store.state.authentication,
      builder: (context, authentication) {
        return new PrimaryButton(
            key: new Key('singUp'),
            text: 'サインアップ',
            height: 44.0,
            onPressed: () {
              if (!isValidate() || _viewModel.isEmpty()) {
                return;
              }
              progress.show();
              store.dispatch(SignUpAction(
                  _viewModel.displayName,
                  _viewModel.email,
                  _viewModel.password));
            }
        );
      },
      onDidChange: (authentication) {
        progress.hide();
        if (authentication.errorCode.isNotEmpty) {
          return;
        }
        if (authentication.authStatus == AuthStatus.signedIn) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new HomeScreen(store: widget.store, title: 'Home')));
          return;
        }
      },
    );
  }

  Widget signInButton() {
    return new FlatButton(
        key: new Key('signIn'),
        textColor: Colors.green,
        child: new Text(
            "既にアカウントをお持ちの方\n（サインイン）",
            textAlign: TextAlign.center
        ),
        onPressed: () => Navigator.pop(context)
    );
  }

  Widget hintText() {
    return new Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: StoreConnector<AppState, Authentication>(
          distinct: false,
          converter: (store) => store.state.authentication,
          builder: (context, authentication) {
            return
              new Text(
                authentication.errorMessage,
                key: new Key('hint'),
                style: new TextStyle(fontSize: 18.0, color: Colors.grey),
                textAlign: TextAlign.center
              );
          },
        ),
    );
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}

class _ViewModel {
  String displayName;
  String email;
  String password;

  _ViewModel({
    @required this.displayName,
    @required this.email,
    @required this.password,
  });

  bool isEmpty() {
    if (displayName.isEmpty || email.isEmpty || password.isEmpty) {
      return true;
    }
    return false;
  }

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      displayName: store.state.authentication.firebaseUser?.displayName ?? "",
      email: store.state.authentication.firebaseUser?.email ?? "",
      password: "",
    );
  }

}