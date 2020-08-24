import 'package:firebase_auth/firebase_auth.dart';

import 'AuthStatus.dart';

class Authentication {
  final AuthStatus authStatus;
  final FirebaseUser firebaseUser;
  final String errorCode;
  final String errorMessage;
  final Exception e;
  const Authentication(this.authStatus, this.firebaseUser, this.errorCode, this.errorMessage, this.e);
}