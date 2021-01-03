import 'dart:io';

enum AuthMode { LOGIN, SIGNUP }

class AuthData {
  String name;
  String email;
  String password;
  File image;
  AuthMode _authMode = AuthMode.LOGIN;

  bool get isSignup {
    return _authMode == AuthMode.SIGNUP;
  }

  bool get isLogin {
    return _authMode == AuthMode.LOGIN;
  }

  void toggleMode() {
    _authMode = _authMode == AuthMode.LOGIN ? AuthMode.SIGNUP : AuthMode.LOGIN;
  }
}
