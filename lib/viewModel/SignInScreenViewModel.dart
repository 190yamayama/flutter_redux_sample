import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/redux/state/AppState.dart';
import 'package:redux/redux.dart';

class SignInScreenViewModel {
  String email;
  String password;

  SignInScreenViewModel({
    @required this.email,
    @required this.password,
  });

  bool isEmpty() {
    if (email.isEmpty || password.isEmpty) {
      return true;
    }
    return false;
  }

  static SignInScreenViewModel fromStore(Store<AppState> store) {
    return SignInScreenViewModel(
      email: store?.state?.authentication?.firebaseUser?.email ?? "",
      password: "",
    );
  }

}