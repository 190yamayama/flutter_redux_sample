import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/redux/state/AppState.dart';
import 'package:redux/redux.dart';

class SignUpScreenViewModel {
  String displayName;
  String email;
  String password;

  SignUpScreenViewModel({
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

  static SignUpScreenViewModel fromStore(Store<AppState> store) {
    return SignUpScreenViewModel(
      displayName: store?.state?.authentication?.firebaseUser?.displayName ?? "",
      email: store?.state?.authentication?.firebaseUser?.email ?? "",
      password: "",
    );
  }

}