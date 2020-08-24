
import '../state/AppState.dart';
import 'AuthStateReducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    authentication: authStateReducer(state.authentication, action),
  );
}