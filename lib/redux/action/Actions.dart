import 'package:flutter_firebase_app/model/Authentication.dart';

// CheckAuthStatus
class CheckAuthStatusAction {}
class CheckAuthStatusCompleteAction {
  final Authentication authentication;
  const CheckAuthStatusCompleteAction(this.authentication);
}
class CheckAuthStatusFailedAction {
  final Authentication authentication;
  const CheckAuthStatusFailedAction(this.authentication);
}

// SignIn
class SignInAction {
  final String email;
  final String password;
  const SignInAction(this.email, this.password);
}
class SignInCompleteAction {
  final Authentication authentication;
  const SignInCompleteAction(this.authentication);
}
class SignInFailedAction {
  final Authentication authentication;
  const SignInFailedAction(this.authentication);
}

// SignUp
class SignUpAction {
  final String displayName;
  final String email;
  final String password;
  const SignUpAction(this.displayName, this.email, this.password);
}
class SignUpCompleteAction {
  final Authentication authentication;
  const SignUpCompleteAction(this.authentication);
}
class SignUpFailedAction {
  final Authentication authentication;
  const SignUpFailedAction(this.authentication);
}

// SignOut
class SignOutAction {}
class SignOutCompleteAction {
  final Authentication authentication;
  const SignOutCompleteAction(this.authentication);
}
class SignOutFailedAction {
  final Authentication authentication;
  const SignOutFailedAction(this.authentication);
}
