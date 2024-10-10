import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';
import 'package:tic_tak_toe/screen/start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  Widget build(BuildContext context) {
    return const Scaffold();
  }

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => StartScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: spColorTTT,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset("assets/images/tic-tac-toe.png")),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Tie - Tac - Toe",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontFamily: "myBoxNew",
                    color: appAppBar,
                    shadows: [Shadow(color: Colors.black, blurRadius: 5)]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
