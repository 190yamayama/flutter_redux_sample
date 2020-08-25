import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/redux/middleware/Authentication.dart';
import 'package:flutter_firebase_app/redux/reducer/AppStateReducer.dart';
import 'package:flutter_firebase_app/redux/state/AppState.dart';
import 'package:flutter_firebase_app/redux/action/Actions.dart';
import 'package:flutter_firebase_app/viewModel/SignInScreenViewModel.dart';
import 'package:flutter_firebase_app/widget/component/PrimaryButton.dart';
import 'package:flutter_firebase_app/widget/screen/HomeScreen.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:redux/redux.dart';

import 'SignUpScreen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  static final formKey = new GlobalKey<FormState>();

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  SignInScreenViewModel _viewModel;

  bool validateAndSave() {
    final form = SignInScreen.formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Store<AppState> store = Store<AppState>(
      appReducer,
      initialState: AppState.initState(),
      middleware: [checkAuthStatusMiddleware, signInMiddleware],
    );

    _viewModel = SignInScreenViewModel.fromStore(store);

    final ProgressDialog progress = new ProgressDialog(context);
    return new StoreProvider(
      store: store,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login Screen"),
        ),
        body: new Center(
          child: new Form(
            child: new SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget> [
                  const SizedBox(
                    height: 200.0,
                    width: 200.0,
                    child: Image(
                      image: AssetImage("assets/splash.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  hintText(),
                  const SizedBox(height: 10.0),
                  new Center(
                      child: new Form(
                          key: SignInScreen.formKey,
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                emailText(),
                                passwordText(),
                                signInButton(store, progress),
                                signUpButton(),
                              ]
                          )
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailText() {
    return padded(child: new TextFormField(
      key: new Key("email"),
      decoration: new InputDecoration(labelText: "Email"),
      autocorrect: false,
      validator: (val) => val.isEmpty ? "emailを入力してください" : null,
      onSaved: (val) => {
        _viewModel.email = val
      },
    ));
  }

  Widget passwordText() {
    return padded(child: new TextFormField(
      key: new Key("password"),
      decoration: new InputDecoration(labelText: "Password"),
      obscureText: true,
      autocorrect: false,
      validator: (val) => val.isEmpty ? "パスワードを入力してください" : null,
      onSaved: (val) => {
        _viewModel.password = val
      },
    ));
  }

  Widget signInButton(Store<AppState> store, ProgressDialog progress) {
    return StoreConnector<AppState, Authentication>(
      distinct: true,
      converter: (store) => store.state.authentication,
      builder: (context, authentication) {
        return new PrimaryButton(
            key: new Key("signIn"),
            text: "サインイン",
            height: 44.0,
            onPressed: () {
              if (!validateAndSave() || _viewModel.isEmpty()) {
                return;
              }
              progress.show();
              store.dispatch(SignInAction(
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
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          return;
        }
      },
    );
  }

  Widget signUpButton() {
    return new FlatButton(
        key: new Key("need-account"),
        textColor: Colors.green,
        child: new Text(
            "初めて利用する方\n（サインアップ）",
            textAlign: TextAlign.center
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        }
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
              key: new Key("hint"),
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