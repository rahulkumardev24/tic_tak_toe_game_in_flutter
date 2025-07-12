import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tic_tak_toe/widgets/game_grid.dart';
import 'package:tic_tak_toe/widgets/score_board_card.dart';
import '../colors.dart';
import '../provider/game_provider.dart';
import '../widgets/control_button.dart';
import '../widgets/win_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
    return Consumer<GameProvider>(
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
                    const SizedBox(height: 10),
                    ScoreBoardCard(
                        playerFirst: provider.playerFirst,
                        playerSecond: provider.playerSecond,
                        firstSymbol: "X",
                        secondSymbol: "O",
                        firstScore: provider.oScore,
                        secondScore: provider.xScore,
                        isFirstTurn: provider.oTurn,
                        firstColor: AppColors.xColor,
                        secondColor: AppColors.oColor),
                    const SizedBox(height: 10),
                    GameGrid(
                        displayOX: provider.displayOX,
                        matchColor: provider.matchColor,
                        oColor: oColor,
                        xColor: xColor,
                        onTap: provider.tapped),
                    _buildControlBar(provider),
                    const SizedBox(height: 20),
                  ],
                ),

                /// dialog show
                if (provider.showWinDialog)
                  WinDialog(
                    resultDeclaration: provider.resultDeclaration,
                    playerFirst: provider.playerFirst,
                    playerSecond: provider.playerSecond,
                    oScore: provider.oScore,
                    xScore: provider.xScore,
                    oColor: AppColors.oColor,
                    xColor: AppColors.xColor,
                    onContinue: provider.clearBoard,
                  ),
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

  Widget _buildControlBar(GameProvider provider) {
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
              provider.resultDeclaration.isEmpty
                  ? "${provider.oTurn ? provider.playerFirst : provider.playerSecond}'s Turn"
                  : provider.resultDeclaration,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: provider.resultDeclaration.contains("Wins")
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
                icon: Icons.refresh,
                label: "Restart",
                color: Colors.orange,
                onPressed: provider.reStart,
              ),
              const SizedBox(width: 20),
              ControlButton(
                icon: Icons.cleaning_services,
                label: "New Game",
                color: Colors.blue,
                onPressed: provider.clearBoard,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getWinnerColor(GameProvider provider) {
    if (provider.resultDeclaration.contains(provider.playerFirst)) return oColor;
    if (provider.resultDeclaration.contains(provider.playerSecond)) return xColor;
    return Colors.amber;
  }
}
