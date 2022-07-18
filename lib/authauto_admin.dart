import 'package:flutter/material.dart';
import 'package:pangan_marketplace/login_admin.dart';
import 'package:pangan_marketplace/regis.dart';

class AuthAutoAdmin extends StatefulWidget {
  const AuthAutoAdmin({Key? key}) : super(key: key);

  @override
  State<AuthAutoAdmin> createState() => _AuthAutoAdminState();
}

class _AuthAutoAdminState extends State<AuthAutoAdmin> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreenAdmin(onClickedSignUp: toggle)
      : RegisScreen(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
