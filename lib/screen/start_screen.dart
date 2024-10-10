import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';
import 'package:tic_tak_toe/screen/home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  var player1Controller = TextEditingController();
  var player2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tie Tac Toe",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 35, fontFamily: "myBox"),
        ),
        centerTitle: true,
        backgroundColor: appAppBar,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: spColorTTT,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),

              SizedBox(
                height: 300,
                width: 300,
                child: Image.asset("assets/images/tic-tac-toe.png"),
              ),

              const SizedBox(
                height: 20,
              ),

              /// player 1
              Container(
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: player1Controller,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 2, color: Colors.greenAccent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Colors.greenAccent),
                          borderRadius: BorderRadius.circular(12)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 2, color: Colors.greenAccent)),
                      label: const Text(
                        "Player First",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "myFonts",
                            color: Colors.deepPurple),
                      )),
                  style: const TextStyle(fontSize: 30, fontFamily: "myBoxNew"),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              /// ------------- player 2 ----------------//
              Container(
                margin: const EdgeInsets.all(16),
                child: TextField(
                  controller: player2Controller,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 2, color: Colors.greenAccent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Colors.greenAccent),
                          borderRadius: BorderRadius.circular(12)),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              width: 2, color: Colors.greenAccent)),
                      label: const Text(
                        "Player Second",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "myFonts",
                            color: Colors.deepPurple),
                      )),
                  style: const TextStyle(fontSize: 30, fontFamily: "myBoxNew"),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              /// ...................START BUTTON ......................///
              SizedBox(
                width: 300,
                height: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    String player1 = player1Controller.text.isEmpty
                        ? "Player 1"
                        : player1Controller.text;
                    String player2 = player2Controller.text.isEmpty
                        ? "Player 2"
                        : player2Controller.text;

                    Navigator.of(context).push(_createRoute(HomeScreen(
                      player1,
                      player2,
                    )));
                  },
                  child: const Text(
                    "Start Game",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.pink,
                      fontFamily: "myBoxNew",
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
