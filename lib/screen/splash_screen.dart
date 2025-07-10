import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';
import 'package:tic_tak_toe/screen/start_screen.dart';
import 'package:tic_tak_toe/utils/custom_text_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => StartScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryLight,

        /// --- BODY --- ///
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.primaryDark])),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// logo
                      Container(
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 2, color: AppColors.primary),
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/tic-tac-toe.png"),
                                fit: BoxFit.cover)),
                      ),

                      /// name
                      Text("Tic Tac Toe",
                          style: myTextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.1,
                              fontFamily: "secondary")),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Challenge Your Brain ",
                          style: myTextStyle(
                              fontSize: size.width * 0.05,
                              fontColor: AppColors.textSecondary)),
                      SizedBox(
                        height: size.height * 0.02,
                      ),

                      /// Liner Progress bar
                      SizedBox(
                          width: size.width * 0.8,
                          child: LinearProgressIndicator(
                            minHeight: size.height * 0.01,
                            backgroundColor:
                                AppColors.textSecondary.withAlpha(150),
                            color: AppColors.textPrimary,
                            borderRadius: BorderRadius.circular(20),
                          )),
                      SizedBox(
                        height: size.height * 0.1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
