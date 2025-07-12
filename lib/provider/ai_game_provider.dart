import 'package:flutter/material.dart';

class AiGameProvider extends ChangeNotifier {
  List<String> board = List.filled(9, '');
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
    playerName = name.isNotEmpty ? name : "You";
    notifyListeners();
  }

  void makeMove(int index) {
    if (board[index] == "" && !gameOver && !showWinDialog && playerTurn) {
      board[index] = 'X';
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
    board[bestMove] = 'O';
    playerTurn = true;
    aiThinking = false;
    _checkWinner();
    notifyListeners();
  }

  int _findBestMove() {
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        if (_isWinning('O')) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }

    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'X';
        if (_isWinning('X')) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }

    if (board[4] == '') return 4;

    List<int> corners = [0, 2, 6, 8]..shuffle();
    for (int corner in corners) {
      if (board[corner] == '') return corner;
    }

    List<int> edges = [1, 3, 5, 7]..shuffle();
    for (int edge in edges) {
      if (board[edge] == '') return edge;
    }

    return board.indexWhere((e) => e == '');
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
      if (board[pattern[0]] == symbol &&
          board[pattern[1]] == symbol &&
          board[pattern[2]] == symbol) {
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
      if (board[a] != '' && board[a] == board[b] && board[b] == board[c]) {
        matchColor = pattern;
        gameOver = true;
        showWinDialog = true;

        if (board[a] == 'X') {
          playerScore++;
          resultMessage = "$playerName Wins!";
        } else {
          aiScore++;
          resultMessage = "Computer Wins!";
        }
        return;
      }
    }

    if (!board.contains('')) {
      resultMessage = "It's a Draw!";
      gameOver = true;
      showWinDialog = true;
    }
  }

  void resetGame() {
    board = List.filled(9, '');
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