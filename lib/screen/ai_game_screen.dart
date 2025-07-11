import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIGameScreen extends StatefulWidget {
  final String playerName;

  const AIGameScreen({super.key, required this.playerName});

  @override
  State<AIGameScreen> createState() => _AIGameScreenState();
}

class _AIGameScreenState extends State<AIGameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<String> board = List.filled(9, '');
  bool playerTurn = true;
  bool gameOver = false;
  String resultMessage = '';
  bool aiThinking = false;
  int playerScore = 0;
  int aiScore = 0;
  List<int> matchColor = [];
  List<int>? winningLine;
  bool _showWinDialog = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
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
          'AI Challenge',
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPlayerScore(widget.playerName, "X", playerScore, playerTurn),
          _buildVSIndicator(),
          _buildPlayerScore("Computer", "O", aiScore, !playerTurn),
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
    return symbol == "X" ? const Color(0xFF4CAF50) : const Color(0xFF2196F3);
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
                    onTap: () => _makeMove(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: matchColor.contains(index)
                            ? _getPlayerColor(board[index]).withOpacity(0.2)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: matchColor.contains(index)
                              ? _getPlayerColor(board[index])
                              : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: board[index] == ""
                            ? null
                            : _buildPlayerSymbol(board[index]),
                      ),
                    ),
                  ),
                ),
                if (winningLine != null)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WinningLinePainter(
                        winningLine: winningLine!,
                        color: playerTurn ? const Color(0xFF2196F3) : const Color(0xFF4CAF50),
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
      child: Text(
        symbol,
        style: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: _getPlayerColor(symbol),
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
              resultMessage.isEmpty
                  ? playerTurn
                  ? "${widget.playerName}'s Turn"
                  : "AI's Turn"
                  : resultMessage,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(),
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
                onPressed: _resetGame,
              ),
              const SizedBox(width: 20),
              _buildControlButton(
                icon: Icons.cleaning_services,
                label: "New Game",
                color: Colors.blue,
                onPressed: _newGame,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (resultMessage.contains("Wins")) {
      return resultMessage.contains(widget.playerName)
          ? const Color(0xFF4CAF50)
          : const Color(0xFF2196F3);
    }
    return Colors.blue.shade800;
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
                    resultMessage.contains("Wins") ? "Victory!" : "Game Over!",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildWinnerBadge(
                        resultMessage.contains(widget.playerName)
                            ? widget.playerName
                            : "Computer",
                        resultMessage.contains(widget.playerName) ? "X" : "O",
                        resultMessage.contains(widget.playerName)
                            ? playerScore
                            : aiScore,
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
                      _buildScoreBadge(widget.playerName, playerScore, const Color(0xFF4CAF50)),
                      const SizedBox(width: 16),
                      _buildScoreBadge("Computer", aiScore, const Color(0xFF2196F3)),
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
                        _resetGame();
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

  void _makeMove(int index) {
    if (board[index] == "" && !gameOver && !_showWinDialog && playerTurn) {
      setState(() {
        board[index] = 'X';
        playerTurn = false;
        _checkWinner();

        if (!gameOver) {
          aiThinking = true;
          _aiMove();
        }
      });
    }
  }

  void _aiMove() async {
    // Simulate AI thinking time
    await Future.delayed(const Duration(milliseconds: 800));

    if (gameOver) return;

    // Simple AI logic (replace with your actual AI algorithm)
    int bestMove = _findBestMove();

    setState(() {
      board[bestMove] = 'O';
      playerTurn = true;
      aiThinking = false;
      _checkWinner();
    });
  }

  int _findBestMove() {
    // Try to win first
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        if (_checkForWinner('O')) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }

    // Block player from winning
    for (int i = 0; i < 9; i++) {
      if (board[i] == '') {
        board[i] = 'X';
        if (_checkForWinner('X')) {
          board[i] = '';
          return i;
        }
        board[i] = '';
      }
    }

    // Try center first
    if (board[4] == '') return 4;

    // Try corners
    List<int> corners = [0, 2, 6, 8];
    corners.shuffle();
    for (int corner in corners) {
      if (board[corner] == '') return corner;
    }

    // Try edges
    List<int> edges = [1, 3, 5, 7];
    edges.shuffle();
    for (int edge in edges) {
      if (board[edge] == '') return edge;
    }

    return 0; // fallback
  }

  bool _checkForWinner(String player) {
    const List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6],             // diagonals
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == player &&
          board[pattern[1]] == player &&
          board[pattern[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void _checkWinner() {
    const List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6],             // diagonals
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] != '' &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        setState(() {
          matchColor = pattern;
          winningLine = [pattern[0], pattern[2]];
          resultMessage = "${board[pattern[0]] == 'X' ? widget.playerName : 'AI'} Wins!";
          if (board[pattern[0]] == 'X') {
            playerScore++;
          } else {
            aiScore++;
          }
          gameOver = true;
          _showWinDialog = true;
        });
        return;
      }
    }

    if (!board.contains('')) {
      setState(() {
        winningLine = null;
        resultMessage = "It's a Draw!";
        gameOver = true;
        _showWinDialog = true;
      });
    }
  }

  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      gameOver = false;
      resultMessage = '';
      playerTurn = true;
      aiThinking = false;
      matchColor = [];
      winningLine = null;
      _showWinDialog = false;
    });
  }

  void _newGame() {
    setState(() {
      board = List.filled(9, '');
      gameOver = false;
      resultMessage = '';
      playerTurn = true;
      aiThinking = false;
      playerScore = 0;
      aiScore = 0;
      matchColor = [];
      winningLine = null;
      _showWinDialog = false;
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

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 24
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}