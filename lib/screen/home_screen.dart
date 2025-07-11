import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final String playerFirst;
  final String playerSecond;

  const HomeScreen(this.playerFirst, this.playerSecond, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
  List<int>? winningLine;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showWinDialog = false;

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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
            if (_showWinDialog) _buildWinDialog(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Column(
      children: [
        Text(
          'Tic Tac Toe',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        Text(
          'Classic Duel',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPlayerScore(widget.playerFirst, "O", oScore, oTurn),
          _buildVSIndicator(),
          _buildPlayerScore(widget.playerSecond, "X", xScore, !oTurn),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String name, String symbol, int score, bool isActive) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? _getPlayerColor(symbol).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getPlayerColor(symbol),
                ),
                child: Center(
                  child: Text(
                    symbol,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _getPlayerColor(symbol),
          ),
        ),
      ],
    );
  }

  Color _getPlayerColor(String symbol) {
    return symbol == "O" ? oColor : xColor;
  }

  Widget _buildVSIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'VS',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
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
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                GridView.builder(
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
                            ? _getWinningCellColor(index).withOpacity(0.2)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: matchColor.contains(index)
                              ? _getWinningCellColor(index)
                              : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: displayOX[index] == ""
                            ? null
                            : _buildPlayerSymbol(displayOX[index]),
                      ),
                    ),
                  ),
                ),
                if (winningLine != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WinningLinePainter(
                        winningLine: winningLine!,
                        color: oTurn ? xColor : oColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getWinningCellColor(int index) {
    if (displayOX[index] == "O") return oColor;
    if (displayOX[index] == "X") return xColor;
    return Colors.transparent;
  }

  Widget _buildPlayerSymbol(String symbol) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              symbol == "X"
                  ? 'assets/images/xicon.webp'
                  : 'assets/images/0icon.png',
            ),
            fit: BoxFit.contain,
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              resultDeclaration.isEmpty
                  ? "${oTurn ? widget.playerFirst : widget.playerSecond}'s Turn"
                  : resultDeclaration,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: resultDeclaration.contains("Wins")
                    ? _getWinnerColor()
                    : Colors.blue.shade800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: Icons.refresh,
                label: "Restart",
                color: Colors.orange,
                onPressed: _reStart,
              ),
              const SizedBox(width: 20),
              _buildControlButton(
                icon: Icons.cleaning_services,
                label: "New Game",
                color: Colors.blue,
                onPressed: _clearBoard,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getWinnerColor() {
    if (resultDeclaration.contains(widget.playerFirst)) return oColor;
    if (resultDeclaration.contains(widget.playerSecond)) return xColor;
    return Colors.amber;
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWinDialog() {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    resultDeclaration.contains("Wins") ? "Victory!" : "Game Over!",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getWinnerColor(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWinnerBadge(
                        resultDeclaration.contains(widget.playerFirst)
                            ? widget.playerFirst
                            : widget.playerSecond,
                        resultDeclaration.contains(widget.playerFirst) ? "O" : "X",
                        resultDeclaration.contains(widget.playerFirst) ? oScore : xScore,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Current Score",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildScoreBadge(widget.playerFirst, oScore, oColor),
                      const SizedBox(width: 16),
                      _buildScoreBadge(widget.playerSecond, xScore, xColor),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () {
                      setState(() {
                        _showWinDialog = false;
                        _clearBoard();
                      });
                    },
                    child: Text(
                      "Continue",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWinnerBadge(String name, String symbol, int score) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getPlayerColor(symbol).withOpacity(0.1),
            border: Border.all(
              color: _getPlayerColor(symbol),
              width: 2,
            ),
          ),
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _getPlayerColor(symbol),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Score: $score",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBadge(String name, int score, Color color) {
    return Column(
      children: [
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Text(
            score.toString(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void _tapped(int index) {
    if (displayOX[index] == "" && !gameOver && !_showWinDialog) {
      setState(() {
        displayOX[index] = oTurn ? "O" : "X";
        filledBoxes++;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    List<List<int>> winPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6]             // diagonals
    ];

    for (var combo in winPositions) {
      String a = displayOX[combo[0]];
      String b = displayOX[combo[1]];
      String c = displayOX[combo[2]];
      if (a != "" && a == b && a == c) {
        setState(() {
          matchColor = combo;
          winningLine = [combo[0], combo[2]];
          resultDeclaration = "${a == "O" ? widget.playerFirst : widget.playerSecond} Wins!";
          _updateScore(a);
          gameOver = true;
          _showWinDialog = true;
        });
        return;
      }
    }

    if (!gameOver && filledBoxes == 9) {
      setState(() {
        winningLine = null;
        resultDeclaration = "It's a Draw!";
        gameOver = true;
        _showWinDialog = true;
      });
    } else {
      setState(() {
        oTurn = !oTurn;
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
      displayOX = List.filled(9, '');
      matchColor = [];
      winningLine = null;
      filledBoxes = 0;
      gameOver = false;
      resultDeclaration = "";
      oTurn = true;
      _showWinDialog = false;
    });
  }

  void _reStart() {
    setState(() {
      xScore = 0;
      oScore = 0;
      _clearBoard();
    });
  }
}

class WinningLinePainter extends CustomPainter {
  final List<int> winningLine;
  final Color color;

  WinningLinePainter({required this.winningLine, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / 3;
    final halfCell = cellSize / 2;

    // Calculate start and end positions
    final startRow = winningLine[0] ~/ 3;
    final startCol = winningLine[0] % 3;
    final endRow = winningLine[1] ~/ 3;
    final endCol = winningLine[1] % 3;

    final startX = startCol * cellSize + halfCell;
    final startY = startRow * cellSize + halfCell;
    final endX = endCol * cellSize + halfCell;
    final endY = endRow * cellSize + halfCell;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Draw main line
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

    // Add glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 24
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}