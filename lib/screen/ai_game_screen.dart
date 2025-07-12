import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tak_toe/widgets/control_button.dart';
import 'package:tic_tak_toe/widgets/win_dialog.dart';
import '../colors.dart';
import '../widgets/game_grid.dart';
import '../widgets/score_board_card.dart';
import '../provider/ai_game_provider.dart';

class AiGameScreen extends StatefulWidget {
  final String playerName;

  const AiGameScreen({super.key, required this.playerName});

  @override
  State<AiGameScreen> createState() => _AiGameScreenState();
}

class _AiGameScreenState extends State<AiGameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final Color playerColor = Colors.blueAccent;
  final Color aiColor = Colors.redAccent;

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

    // Initialize player name in provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AiGameProvider>(context, listen: false);
      provider.setPlayerName(widget.playerName);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AiGameProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildAppTitle(),
                    ScoreBoardCard(
                        playerFirst: provider.playerName,
                        playerSecond: "Computer",
                        firstSymbol: "X",
                        secondSymbol: "O",
                        firstScore: provider.aiScore,
                        secondScore: provider.playerScore,
                        isFirstTurn: provider.playerTurn,
                        firstColor: AppColors.xColor,
                        secondColor: AppColors.oColor),
                    GameGrid(
                        displayOX: provider.displayOX,
                        matchColor: provider.matchColor,
                        oColor: playerColor,
                        xColor: aiColor,
                        onTap: provider.makeMove),
                    _buildControlBar(provider),
                    const SizedBox(height: 20),
                  ],
                ),
                if (provider.showWinDialog)
                  WinDialog(
                      resultDeclaration: provider.resultMessage,
                      playerFirst: provider.playerName,
                      playerSecond: "Computer",
                      oScore: provider.aiScore,
                      xScore: provider.playerScore,
                      oColor: aiColor,
                      xColor: playerColor,
                      onContinue: provider.resetGame),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppTitle() {
    return Column(
      children: [
        Text(
          'AI Tic Tac Toe',
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
          'Challenge the AI',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildControlBar(AiGameProvider provider) {
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
              provider.resultMessage.isEmpty
                  ? provider.playerTurn
                      ? "${widget.playerName}'s Turn"
                      : "AI is Thinking..."
                  : provider.resultMessage,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: provider.resultMessage.contains("Wins")
                    ? _getWinnerColor(provider)
                    : Colors.blue.shade800,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ControlButton(
                  icon: Icons.cleaning_services,
                  label: "Restart",
                  color: Colors.orangeAccent,
                  onPressed: provider.resetGame),
              ControlButton(
                  icon: Icons.refresh,
                  label: "New Game",
                  color: Colors.blue,
                  onPressed: provider.newGame),
            ],
          ),
        ],
      ),
    );
  }

  Color _getWinnerColor(AiGameProvider provider) {
    if (provider.resultMessage.contains(widget.playerName)) return playerColor;
    if (provider.resultMessage.contains("AI")) return aiColor;
    return Colors.amber;
  }
}
