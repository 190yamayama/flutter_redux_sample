import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_app/api/firebase/Auth.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';
import 'package:flutter_firebase_app/redux/action/Actions.dart';
import 'package:redux/redux.dart';

import '../state/AppState.dart';

void checkAuthStatusMiddleware(Store<AppState> store, action, NextDispatcher next) {
  if (action is CheckAuthStatusAction) {
    final BaseAuth auth = new Auth();
    String errorCode = "";
    String errorMessage = "";
    try {
      auth.currentUser().then((user) {
        AuthStatus status = user != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
        next(new CheckAuthStatusCompleteAction(new Authentication(status, user, "", "", null)));
      });
    } on PlatformException catch(e) {
      errorCode = e.code.toString();
      errorMessage = "";
      next(new CheckAuthStatusFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } catch (e) {
      errorMessage = "状態確認でエラーが発生しました。\n\n${e.toString()}";
      next(new CheckAuthStatusFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } finally {

    }
  }
  next(action);
}

Future<void> signInMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SignInAction) {
    if (action.email.isEmpty || action.password.isEmpty) {
      return;
    }
    final BaseAuth auth = new Auth();
    String errorCode = "";
    String errorMessage = "";
    try {
      await auth.signIn(action.email, action.password);
      FirebaseUser user = await auth.currentUser();
      next(new SignInCompleteAction(new Authentication(AuthStatus.signedIn, user, "", "", null)));
    } on PlatformException catch(e) {
      errorCode = e.code.toString();
      errorMessage = "";
      if (errorCode == "ERROR_USER_NOT_FOUND") {
        errorMessage = "ユーザが存在しません\nサインアップしてください";
      } else if (errorCode == "ERROR_WRONG_PASSWORD") {
        errorMessage = "パスワードが間違っています";
      } else {
        errorMessage = "サインインでエラーが発生しました。\n\n${e.toString()}";
      }
      next(new SignInFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } catch (e) {
      errorMessage = "サインインでエラーが発生しました。\n\n${e.toString()}";
      next(new SignInFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } finally {

    }
  }
  next(action);
}

Future<void> signUpMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SignUpAction) {
    if (action.displayName.isEmpty || action.email.isEmpty || action.password.isEmpty) {
      return;
    }
    final BaseAuth auth = new Auth();
    String errorCode = "";
    String errorMessage = "";
    try {
      await auth.createUser(action.displayName, action.email, action.password);
      FirebaseUser user = await auth.currentUser();
      next(new SignUpCompleteAction(new Authentication(AuthStatus.signedIn, user, "", "", null)));
    } on PlatformException catch(e) {
      errorCode = e.code.toString();
      errorMessage = "";
      if (errorCode == "ERROR_EMAIL_ALREADY_IN_USE") {
        errorMessage = "既にユーザが存在します\nサインインしてください";
      } else {
        errorMessage = "サインアップでエラーが発生しました。\n\n${e.toString()}";
      }
      next(new SignUpFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } catch (e) {
      errorMessage = "サインアップでエラーが発生しました。\n\n${e.toString()}";
      next(new SignUpFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } finally {

    }
  }
  next(action);
}

Future<void> signOutMiddleware(Store<AppState> store, action, NextDispatcher next) async {
  if (action is SignOutAction) {
    final BaseAuth auth = new Auth();
    String errorCode = '';
    String errorMessage = '';
    try {
      await auth.signOut();
      next(new SignOutCompleteAction(new Authentication(AuthStatus.notSignedIn, null, "", "", null)));
    } on PlatformException catch(e) {
      errorCode = e.code.toString();
      errorMessage = '';
      next(new SignOutFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } catch (e) {
      errorMessage = 'サインアウトでエラーが発生しました。\n\n${e.toString()}';
      next(new SignOutFailedAction(new Authentication(AuthStatus.failed, null, errorCode, errorMessage, e)));
    } finally {

    }
  }
  next(action);
}
