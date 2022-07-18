import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pangan_marketplace/home.dart';
import 'package:pangan_marketplace/themeColor.dart';
import 'package:pangan_marketplace/user_model.dart';

class RegisScreen extends StatefulWidget {
  const RegisScreen({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  final VoidCallback onClickedSignIn;

  @override
  State<RegisScreen> createState() => _RegisScreenState();
}

class _RegisScreenState extends State<RegisScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final usernameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final usernameField = TextFormField(
        autofocus: false,
        controller: usernameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Mohon isi username anda");
          }
          if (!regex.hasMatch(value)) {
            return ("username tidak valid (Min. 3 karakter)");
          }
          return null;
        },
        onSaved: (value) {
          usernameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Username",
          hintStyle: TextStyle(
            fontFamily: 'jaapokkienchance',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Mohon isi E-mail anda");
          }
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("E-mail tidak valid");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "E-mail",
          hintStyle: TextStyle(
            fontFamily: 'jaapokkienchance',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Mohon isi password anda");
          }
          if (!regex.hasMatch(value)) {
            return ("Password tidak valid (Min. 6 karakter)");
          }
          return null;
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          hintStyle: TextStyle(
            fontFamily: 'jaapokkienchance',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final singUpButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Themes.color,
        child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: const Text(
            "Daftar",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'jaapokkienchance',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ));

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
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "images/logo.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 40),
                    usernameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 20),
                    singUpButton,
                    const SizedBox(height: 15),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: Themes.color,
                                fontFamily: 'jaapokkienchance',
                                fontSize: 15),
                            text: "Sudah Punya Akun?  ",
                            children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignIn,
                              text: 'Login',
                              style: TextStyle(
                                  fontFamily: 'jaapokkienchance',
                                  color:
                                      Theme.of(context).colorScheme.secondary))
                        ]))
                  ],
                ),
              ),
            ),
          )),
        ));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.username = usernameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Akun Berhasil Dibuat");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }
}
