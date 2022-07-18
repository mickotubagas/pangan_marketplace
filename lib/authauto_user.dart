import 'package:flutter/material.dart';
import 'package:pangan_marketplace/login_user.dart';
import 'package:pangan_marketplace/regis.dart';

class AuthAutoUser extends StatefulWidget {
  const AuthAutoUser({Key? key}) : super(key: key);

  @override
  State<AuthAutoUser> createState() => _AuthAutoUserState();
}

class _AuthAutoUserState extends State<AuthAutoUser> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreenUser(onClickedSignUp: toggle)
      : RegisScreen(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
