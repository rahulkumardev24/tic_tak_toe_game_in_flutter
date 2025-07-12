import 'package:flutter/material.dart';

class AiGameProvider extends ChangeNotifier {
  List<String> displayOX = List.filled(9, '');
  bool playerTurn = true;
  bool gameOver = false;
  String resultMessage = '';
  bool aiThinking = false;
  int playerScore = 0;
  int aiScore = 0;
  List<int> matchColor = [];
  bool showWinDialog = false;
  String playerName = "You";

  void setPlayerName(String name) {
    playerName = name;
  }

  void makeMove(int index) {
    if (displayOX[index] == "" && !gameOver && !showWinDialog && playerTurn) {
      displayOX[index] = 'X';
      playerTurn = false;
      _checkWinner();
      notifyListeners();

      if (!gameOver) {
        aiThinking = true;
        notifyListeners();
        _aiMove();
      }
    }
  }

  Future<void> _aiMove() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (gameOver) return;

    int bestMove = _findBestMove();
    displayOX[bestMove] = 'O';
    playerTurn = true;
    aiThinking = false;
    _checkWinner();
    notifyListeners();
  }

  int _findBestMove() {
    for (int i = 0; i < 9; i++) {
      if (displayOX[i] == '') {
        displayOX[i] = 'O';
        if (_isWinning('O')) {
          displayOX[i] = '';
          return i;
        }
        displayOX[i] = '';
      }
    }

    for (int i = 0; i < 9; i++) {
      if (displayOX[i] == '') {
        displayOX[i] = 'X';
        if (_isWinning('X')) {
          displayOX[i] = '';
          return i;
        }
        displayOX[i] = '';
      }
    }

    if (displayOX[4] == '') return 4;

    List<int> corners = [0, 2, 6, 8]..shuffle();
    for (int corner in corners) {
      if (displayOX[corner] == '') return corner;
    }

    List<int> edges = [1, 3, 5, 7]..shuffle();
    for (int edge in edges) {
      if (displayOX[edge] == '') return edge;
    }

    return displayOX.indexWhere((e) => e == '');
  }

  bool _isWinning(String symbol) {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var pattern in winPatterns) {
      if (displayOX[pattern[0]] == symbol &&
          displayOX[pattern[1]] == symbol &&
          displayOX[pattern[2]] == symbol) {
        return true;
      }
    }
    return false;
  }

  void _checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      final a = pattern[0], b = pattern[1], c = pattern[2];
      if (displayOX[a] != '' && displayOX[a] == displayOX[b] && displayOX[b] == displayOX[c]) {
        matchColor = pattern;
        gameOver = true;
        showWinDialog = true;

        if (displayOX[a] == 'X') {
          playerScore++;
          resultMessage = "$playerName Wins!";
        } else {
          aiScore++;
          resultMessage = "AI Wins!";
        }
        return;
      }
    }

    if (!displayOX.contains('')) {
      resultMessage = "It's a Draw!";
      gameOver = true;
      showWinDialog = true;
    }
  }

  void resetGame() {
    displayOX = List.filled(9, '');
    gameOver = false;
    resultMessage = '';
    playerTurn = true;
    aiThinking = false;
    matchColor = [];
    showWinDialog = false;
    notifyListeners();
  }

  void newGame() {
    resetGame();
    playerScore = 0;
    aiScore = 0;
    notifyListeners();
  }
}
