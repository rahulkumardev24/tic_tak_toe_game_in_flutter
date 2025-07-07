import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';

class HomeScreen extends StatefulWidget {
  final String playerFirst;
  final String playerSecond;

  const HomeScreen(this.playerFirst, this.playerSecond, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool oTurn = true;
  bool gameOver = false;
  List<String> displayOX = List.filled(9, '');
  String resultDeclaration = "";
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  List<int> matchColor = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  final Color oColor = Colors.greenAccent;
  final Color xColor = Colors.orangeAccent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: spColorTTT,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildAppTitle(),
            const SizedBox(height: 10),
            _buildScoreBoard(),
            const SizedBox(height: 10),
            _buildGameGrid(),
            _buildControlBar(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Text(
      'Tic Tac Toe',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
        fontFamily: 'Poppins',
        shadows: [
          Shadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(2.0, 2.0),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlayerCard(widget.playerFirst, "O", oScore, oTurn),
          _buildVSIndicator(),
          _buildPlayerCard(widget.playerSecond, "X", xScore, !oTurn),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(String name, String symbol, int score, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.blue.shade300 : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: symbol == "O" ? oColor : xColor,
            ),
            child: Center(
              child: Text(
                symbol,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVSIndicator() {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'VS',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => _tapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: matchColor.contains(index)
                        ? Colors.yellow.withOpacity(0.3)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: matchColor.contains(index)
                        ? [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                        : null,
                  ),
                  child: Center(
                    child: displayOX[index] == ""
                        ? null
                        : ScaleTransition(
                      scale: Tween(begin: 0.5, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.elasticOut,
                        ),
                      ),
                      child: Image.asset(
                        displayOX[index] == "X"
                            ? 'assets/images/xicon.webp'
                            : 'assets/images/0icon.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              resultDeclaration.isEmpty ? "Your Turn: ${oTurn ? widget.playerFirst : widget.playerSecond}" : resultDeclaration,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: resultDeclaration.contains("Wins")
                    ? Colors.green.shade800
                    : Colors.blue.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.refresh,
                label: "Restart",
                color: Colors.orange,
                onPressed: _reStart,
              ),
              const SizedBox(width: 20),
              _buildActionButton(
                icon: Icons.cleaning_services,
                label: "Clear",
                color: Colors.blue,
                onPressed: _clearBoard,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: IconButton(
              icon: Icon(icon, color: Colors.white),
              onPressed: onPressed,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  /// ------------------ GAME LOGIC (unchanged) -------------------- ///
  void _tapped(int index) {
    if (displayOX[index] == "" && !gameOver) {
      setState(() {
        displayOX[index] = oTurn ? "O" : "X";
        filledBoxes++;
        oTurn = !oTurn;
        _checkWinner();
      });
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
        setState(() {
          matchColor = combo;
          resultDeclaration = "${a == "O" ? widget.playerFirst : widget.playerSecond} Wins!";
          _updateScore(a);
          gameOver = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _clearBoard();
          });
        });
        return;
      }
    }

    if (!gameOver && filledBoxes == 9) {
      setState(() {
        resultDeclaration = "It's a Draw!";
        gameOver = true;
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
    displayOX = List.filled(9, '');
    matchColor = [];
    filledBoxes = 0;
    gameOver = false;
    resultDeclaration = "";
    oTurn = true;
    setState(() {});
  }

  void _reStart() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _clearBoard();
    });
  }
}