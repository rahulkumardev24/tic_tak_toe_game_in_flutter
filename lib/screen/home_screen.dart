import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';

class HomeScreen extends StatefulWidget {
  String playerFirst;
  String playerSecond;

  HomeScreen(this.playerFirst, this.playerSecond, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool oTurn = true;
  bool gameOver = false;
  List<String> displayOX = ['', '', '', '', '', '', '', '', ''];
  String resultDeclaration = "";
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  bool winnerFound = false;

  List<int> matchColor = [];
  Color first = Colors.yellow;
  Color second = Colors.greenAccent;

  bool isBlinking = false; // Variable to control blinking effect

  @override
  MediaQueryData? mqData;
  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      /// ..................body................................//
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: spColorTTT,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
          const SizedBox(
            height: 50,
          ),

          /// player 1 part
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.greenAccent),
                  child: const Center(
                      child: Text(
                    "O",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "myBoxNew"),
                  ))),
              Container(
                  height: 50,
                  width: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.greenAccent, width: 1),
                      boxShadow: const [
                        BoxShadow(color: Colors.greenAccent, blurRadius: 10)
                      ],
                      color:
                          oTurn ? Colors.orangeAccent.shade200 : Colors.white),
                  child: Center(
                      child: Text(
                    widget.playerFirst,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "myBoxNew"),
                  ))),
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.greenAccent, width: 1),
                      boxShadow: const [
                        BoxShadow(color: spBox, blurRadius: 10)
                      ],
                      color: Colors.white),
                  child: Center(
                      child: Text(
                    oScore.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "myBox"),
                  ))),
            ],
          ),

          SizedBox(
            height: mqData!.size.height * 0.05,
          ),

          /// ............box......................//
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _tapped(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: matchColor.contains(index) ? first : second,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: displayOX[index] == ""
                          ? null
                          : Image.asset(
                              displayOX[index] == "X"
                                  ? 'assets/images/xicon.webp'
                                  : 'assets/images/0icon.png',
                              width: 60,
                              height: 60,
                            ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// operation part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _clearBoard();
                      });
                    },
                    child: const Text(
                      "Clear",
                      style: TextStyle(fontFamily: "myBox", fontSize: 20),
                    ),
                  ),
                ),
                Container(
                    width: mqData!.size.width * 0.5,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(
                      resultDeclaration,
                      style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontFamily: "myBoxNew"),
                    ))),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _reStart();
                      });
                    },
                    child: const Icon(
                      Icons.restart_alt_outlined,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: mqData!.size.height * 0.05,
          ),

          /// player 2 part
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.greenAccent, width: 1),
                        boxShadow: const [
                          BoxShadow(color: spBox, blurRadius: 10)
                        ],
                        color: Colors.white),
                    child: Center(
                        child: Text(
                      xScore.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: "myBox"),
                    ))),
                Container(
                    height: 50,
                    width: 220,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.greenAccent, width: 1),
                        boxShadow: const [
                          BoxShadow(color: Colors.greenAccent, blurRadius: 10)
                        ],
                        color: oTurn
                            ? Colors.white
                            : Colors.orangeAccent.shade200),
                    child: Center(
                        child: Text(
                      widget.playerSecond,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: "myBoxNew"),
                    ))),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.greenAccent),
                    child: const Center(
                        child: Text(
                      "X",
                      style: TextStyle(fontSize: 30, fontFamily: "myBoxNew"),
                    ))),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  /// ..................................FUNCTION ............................///
  void _tapped(int index) {
    setState(() {
      if (displayOX[index] == "" && !gameOver) {
        displayOX[index] = oTurn ? "O" : "X";
        filledBoxes++;
        oTurn = !oTurn;
        _checkWinner();
      }
    });
  }

  void _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6] // diagonals
    ];

    for (List<int> combo in winningCombinations) {
      if (displayOX[combo[0]] != "" &&
          displayOX[combo[0]] == displayOX[combo[1]] &&
          displayOX[combo[0]] == displayOX[combo[2]]) {
        setState(() {
          resultDeclaration =
              "${displayOX[combo[0]] == "O" ? widget.playerFirst : widget.playerSecond} Wins";
          matchColor.addAll(combo);
          _updateScore(displayOX[combo[0]]);
          gameOver = true; // Game khatam hone par gameOver ko true set karo
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _clearBoard();
          });
        });
      }
    }

    // Check for draw
    if (!gameOver && filledBoxes == 9) {
      setState(() {
        resultDeclaration = "It's a Draw";
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == "X") {
      xScore++;
    } else if (winner == "O") {
      oScore++;
    }
  }

  void _clearBoard() {
    setState(() {
      displayOX = ['', '', '', '', '', '', '', '', ''];
      matchColor = [];
      filledBoxes = 0;
      gameOver = false; // Reset game over state
      resultDeclaration = "";
      isBlinking = false; // Reset blinking effect
    });
  }

  void _reStart() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _clearBoard();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
