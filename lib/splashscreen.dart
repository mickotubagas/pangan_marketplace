import 'package:flutter/material.dart';
import 'package:pangan_marketplace/main.dart';
import 'package:pangan_marketplace/themeColor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), (() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainController(),
          ));
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          children: [
            Expanded(child: _getLogo()),
            Text(
              'Creat By :',
              style: TextStyle(
                  fontFamily: 'jaapokkienchance',
                  color: Themes.color,
                  fontSize: 15),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Micko Tubagas',
                style: TextStyle(
                    fontFamily: 'jaapokkienchance',
                    color: Themes.color,
                    fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getLogo() {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Image.asset(
          "images/logo.png",
          height: 380,
          width: 380,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 270,
        ),
        child: Center(
          child: Text(
            "Pangan Marketplace",
            style: TextStyle(
                fontFamily: 'jaapokkienchance',
                color: Themes.color,
                fontSize: 15),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 320),
        child: Center(
          child: Text(
            ". . .",
            style: TextStyle(
                fontFamily: 'jaapokkienchance',
                color: Themes.color,
                fontSize: 35),
          ),
        ),
      ),
    ]);
  }
}
