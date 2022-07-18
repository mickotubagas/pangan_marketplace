import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pangan_marketplace/authauto_user.dart';
import 'package:pangan_marketplace/themeColor.dart';
import 'package:pangan_marketplace/user_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? users = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(users!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: const Alignment(0.9, 0.9),
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 40.0, bottom: 8),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/iconuser.jpg'),
                    radius: 70,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Text.rich(TextSpan(
                text: "Personal ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: 'jaapokkienchance',
                ),
                children: [
                  TextSpan(
                    text: "Informasi",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontFamily: 'jaapokkienchance',
                    ),
                  ),
                ])),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                      child: Text(
                        "${loggedInUser.username}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'jaapokkienchance',
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                        child: Text("${loggedInUser.email}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'jaapokkienchance',
                                color: Colors.black))),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 43,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 95),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(30),
                      primary: Themes.color,
                    ),
                    icon: const Icon(
                      Icons.lock_open,
                      size: 25,
                    ),
                    label: const Text('Logout'),
                    onPressed: () => logout(context),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 43,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 95),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(30),
                      primary: Themes.color,
                    ),
                    icon: const Icon(
                      Icons.delete,
                      size: 25,
                    ),
                    label: const Text('Delete'),
                    onPressed: () => DeleteUser(),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    await FirebaseAuth.instance.signOut();
    Future.delayed(const Duration(seconds: 1));
    Fluttertoast.showToast(msg: "Berhasil Keluar Dari Akun");
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthAutoUser()));
  }

  DeleteUser() async {
    UserModel userModel = UserModel();
    bool step1 = true;
    bool step2 = false;
    bool step3 = false;
    bool step4 = false;
    while (true) {
      if (step1) {
        var delete = await FirebaseFirestore.instance
            .collection('users')
            .doc(users!.uid)
            .delete();
        step1 = false;
        step2 = true;
      }

      if (step2) {
        users!.delete();
        step2 = false;
        step3 = true;
      }

      if (step3) {
        await FirebaseAuth.instance.signOut();
        step3 = false;
        step4 = true;
      }

      if (step4) {
        await Navigator.pushNamed(context, '/');
        step4 = false;
      }

      if (!step1 && !step2 && !step3 && !step4) {
        break;
      }
    }
  }
}
