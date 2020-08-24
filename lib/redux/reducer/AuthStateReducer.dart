import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/redux/action/Actions.dart';
import 'package:redux/redux.dart';

final authStateReducer = combineReducers<Authentication>([
  TypedReducer<Authentication, CheckAuthStatusCompleteAction>(_setAuthStatusCheckAction),
  TypedReducer<Authentication, SignInCompleteAction>(_setAuthStatusSignInAction),
  TypedReducer<Authentication, SignInFailedAction>(_setAuthStatusSignInFailedAction),
  TypedReducer<Authentication, SignUpCompleteAction>(_setAuthStatusSignUpAction),
  TypedReducer<Authentication, SignUpFailedAction>(_setAuthStatusSignUpFailedAction),
  TypedReducer<Authentication, SignOutCompleteAction>(_setAuthStatusSignOutAction),
]);

Authentication _setAuthStatusCheckAction(Authentication state, CheckAuthStatusCompleteAction action) {
  return action.authentication;
}

Authentication _setAuthStatusSignInAction(Authentication state, SignInCompleteAction action) {
  return action.authentication;
}
Authentication _setAuthStatusSignInFailedAction(Authentication state, SignInFailedAction action) {
  return action.authentication;
}

Authentication _setAuthStatusSignUpAction(Authentication state, SignUpCompleteAction action) {
  return action.authentication;
}
Authentication _setAuthStatusSignUpFailedAction(Authentication state, SignUpFailedAction action) {
  return action.authentication;
}

Authentication _setAuthStatusSignOutAction(Authentication state, SignOutCompleteAction action) {
  return action.authentication;
}