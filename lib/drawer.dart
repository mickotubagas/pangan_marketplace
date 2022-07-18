import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pangan_marketplace/admin_Akses.dart';
import 'package:pangan_marketplace/admin_info.dart';
import 'package:pangan_marketplace/authauto_admin.dart';
import 'package:pangan_marketplace/themeColor.dart';
import 'package:pangan_marketplace/user_model.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "${loggedInUser.username}",
                style: TextStyle(
                    fontFamily: 'jaapokkienchance',
                    color: Colors.black,
                    shadows: [
                      Shadow(
                          color: Themes.color.withOpacity(0.9),
                          offset: const Offset(0, 3),
                          blurRadius: 2),
                    ]),
              ),
            ),
            accountEmail: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "${loggedInUser.email}",
                style: TextStyle(
                    fontFamily: 'jaapokkienchance',
                    color: Colors.black,
                    shadows: [
                      Shadow(
                          color: Themes.color.withOpacity(0.9),
                          offset: const Offset(0, 3),
                          blurRadius: 2),
                    ]),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "images/admin.jpg",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('images/backgrounddrawer.jpg'),
                  fit: BoxFit.cover,
                )),
          ),
          ListTile(
            leading: const Icon(
              Icons.dashboard,
              color: Colors.black,
            ),
            title: const Text(
              "Dashboard",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'jaapokkienchance'),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminAkses()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.black,
            ),
            title: const Text(
              "About",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'jaapokkienchance'),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminInfo()));
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'jaapokkienchance'),
            ),
            onTap: () => logout(context),
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
    Fluttertoast.showToast(msg: "Berhasil Keluar Dari Akun");
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthAutoAdmin()));
  }
}
