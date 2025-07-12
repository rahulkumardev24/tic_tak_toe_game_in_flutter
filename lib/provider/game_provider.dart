import 'package:flutter/material.dart';

class GameProvider extends ChangeNotifier {
  bool oTurn = true;
  bool gameOver = false;
  List<String> displayOX = List.filled(9, '');
  String resultDeclaration = "";
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  List<int> matchColor = [];

  bool showWinDialog = false;

  String playerFirst = '';
  String playerSecond = '';

  void setPlayers(String p1, String p2) {
    playerFirst = p1;
    playerSecond = p2;
    notifyListeners();
  }

  void tapped(int index) {
    if (displayOX[index] == "" && !gameOver && !showWinDialog) {
      displayOX[index] = oTurn ? "X" : "O";
      filledBoxes++;
      _checkWinner();
      notifyListeners();
    }
  }

  void _checkWinner() {
    List<List<int>> winPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var combo in winPositions) {
      String a = displayOX[combo[0]];
      String b = displayOX[combo[1]];
      String c = displayOX[combo[2]];
      if (a != "" && a == b && a == c) {
        matchColor = combo;
        resultDeclaration = "${a == "O" ? playerFirst : playerSecond} Wins!";
        _updateScore(a);
        gameOver = true;
        showWinDialog = true;
        return;
      }
    }

    if (!gameOver && filledBoxes == 9) {
      resultDeclaration = "It's a Draw!";
      gameOver = true;
      showWinDialog = true;
    } else {
      oTurn = !oTurn;
    }
  }

  void _updateScore(String winner) {
    if (winner == "X") {
      xScore++;
    } else if (winner == "O") {
      oScore++;
    }
  }

  void clearBoard() {
    displayOX = List.filled(9, '');
    matchColor = [];
    filledBoxes = 0;
    gameOver = false;
    resultDeclaration = "";
    oTurn = true;
    showWinDialog = false;
    notifyListeners();
  }

  void reStart() {
    xScore = 0;
    oScore = 0;
    clearBoard();
  }
}
