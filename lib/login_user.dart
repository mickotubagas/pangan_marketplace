import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pangan_marketplace/acc_user.dart';
import 'package:pangan_marketplace/home.dart';
import 'package:pangan_marketplace/themeColor.dart';

class LoginScreenUser extends StatefulWidget {
  const LoginScreenUser({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  State<LoginScreenUser> createState() => _LoginScreenUserState();
}

class _LoginScreenUserState extends State<LoginScreenUser> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailInput = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) => email != null && !EmailValidator.validate(email)
          ? 'E-mail tidak valid'
          : null,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          hintStyle: TextStyle(
            fontFamily: 'jaapokkienchance',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final passwordInput = TextFormField(
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password tidak Valid");
        }
        if (!regex.hasMatch(value)) {
          return ("Masukan password (Min. 6 karakter)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          hintStyle: TextStyle(
            fontFamily: 'jaapokkienchance',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Themes.color,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          LoginPage(emailController.text, passwordController.text);
        },
        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'jaapokkienchance',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "images/logo.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 30),
                    emailInput,
                    const SizedBox(height: 15),
                    passwordInput,
                    const AccountSwitchUsers(),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    loginButton,
                    const SizedBox(height: 10),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'jaapokkienchance',
                                color: Themes.color,
                                fontSize: 15),
                            text: "Belum Punya Akun?  ",
                            children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignUp,
                              text: 'Daftar',
                              style: TextStyle(
                                  fontFamily: 'jaapokkienchance',
                                  color:
                                      Theme.of(context).colorScheme.secondary))
                        ]))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void LoginPage(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Akun Berhasil Login"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Email yang anda masukan invalid";

            break;
          case "wrong-password":
            errorMessage = "password yang anda masukan salah";
            break;
          case "user-not-found":
            errorMessage = "Akun yang anda masukan tidak ditemukan";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Terlalu banyak request";
            break;
          case "operation-not-allowed":
            errorMessage = "Masukan email dan password tidak valid";
            break;
          default:
            errorMessage = "Error tidak teridentifikasi";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
