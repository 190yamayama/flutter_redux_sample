
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/AuthStatus.dart';
import 'package:flutter_firebase_app/model/Authentication.dart';

@immutable
class AppState {

  final Authentication authentication;

  const AppState(
      {
        this.authentication = const Authentication(AuthStatus.initState, null, "", "", null),
      });

  factory AppState.initState() => const AppState();

  AppState copyWith({
    AuthStatus authStatus,
  }) {
    return new AppState(
      authentication: authentication ?? this.authentication,
    );
  }

  @override
  int get hashCode => authentication.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState && runtimeType == other.runtimeType &&
              authentication == other.authentication;

  @override
  String toString() {
    return 'AppState{authentication: $authentication}';
  }

}