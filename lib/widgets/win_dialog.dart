import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WinDialog extends StatelessWidget {
  final String resultDeclaration;
  final String playerFirst;
  final String playerSecond;
  final int oScore;
  final int xScore;
  final Color oColor;
  final Color xColor;
  final VoidCallback onContinue;

  const WinDialog({
    super.key,
    required this.resultDeclaration,
    required this.playerFirst,
    required this.playerSecond,
    required this.oScore,
    required this.xScore,
    required this.oColor,
    required this.xColor,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isDraw = !resultDeclaration.contains("Wins");
    final isPlayerFirstWinner = resultDeclaration.contains(playerFirst);
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            /// Background celebration effect
            if (!isDraw)
              Positioned(
                child: Lottie.asset(
                  "assets/lottie/win.json",
                  height: size.height * 0.5,
                  fit: BoxFit.cover,
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    isDraw ? "It's a Draw!" : "Congratulations!",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDraw ? Colors.amber : _getWinnerColor(),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Winner highlight
                  if (!isDraw) _buildWinnerBadge(),
                  if (isDraw) _buildDrawIndicator(),
                  const SizedBox(height: 30),

                  /// Scores section
                  Text(
                    "Final Scores",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPlayerScore(
                        name: playerFirst,
                        symbol: "X",
                        score: xScore,
                        isWinner: isPlayerFirstWinner && !isDraw,
                        color: xColor,
                      ),
                      _buildPlayerScore(
                        name: playerSecond,
                        symbol: "O",
                        score: oScore,
                        isWinner: !isPlayerFirstWinner && !isDraw,
                        color: oColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: onContinue,
                      child: Text(
                        "Continue",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore({
    required String name,
    required String symbol,
    required int score,
    required bool isWinner,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isWinner ? color.withOpacity(0.15) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isWinner ? color : Colors.grey.shade300,
              width: isWinner ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
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
              const SizedBox(height: 8),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
            color: color,
          ),
        ),
        isWinner
            ? const Icon(Icons.emoji_events, color: Colors.amber, size: 30)
            : const Icon(Icons.thumb_down, color: Colors.grey, size: 30),
      ],
    );
  }

  Widget _buildWinnerBadge() {
    final isPlayerFirstWinner = resultDeclaration.contains(playerFirst);
    final winnerName = isPlayerFirstWinner ? playerFirst : playerSecond;
    final color = isPlayerFirstWinner ? xColor : oColor;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 30),
              const SizedBox(width: 10),
              Text(
                "Winner: $winnerName",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDrawIndicator() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.handshake, color: Colors.amber, size: 30),
              const SizedBox(width: 10),
              Text(
                "Equal Match!",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getWinnerColor() {
    if (resultDeclaration.contains(playerFirst)) return xColor;
    if (resultDeclaration.contains(playerSecond)) return oColor;
    return Colors.amber;
  }
}
