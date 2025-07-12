import 'package:flutter/material.dart';
import 'package:tic_tak_toe/utils/custom_text_style.dart';
import 'package:tic_tak_toe/widgets/vs_indicator.dart';

@immutable
class ScoreBoardCard extends StatelessWidget {
  final String playerFirst;
  final String playerSecond;
  final String firstSymbol;
  final String secondSymbol;
  final int firstScore;
  final int secondScore;
  final bool isFirstTurn;
  final Color firstColor;
  final Color secondColor;

  const ScoreBoardCard({
    super.key,
    required this.playerFirst,
    required this.playerSecond,
    required this.firstSymbol,
    required this.secondSymbol,
    required this.firstScore,
    required this.secondScore,
    required this.isFirstTurn,
    required this.firstColor,
    required this.secondColor,
  });

  @override
  Widget build(BuildContext context) {
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
          _playerScore(
            name: playerFirst,
            symbol: firstSymbol,
            score: firstScore,
            isActive: isFirstTurn,
            playerColor: firstColor,
          ),
          const VsIndicator(),
          _playerScore(
            name: playerSecond,
            symbol: secondSymbol,
            score: secondScore,
            isActive: !isFirstTurn,
            playerColor: secondColor,
          ),
        ],
      ),
    );
  }

  Widget _playerScore({
    required String name,
    required String symbol,
    required int score,
    required bool isActive,
    required Color playerColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? playerColor.withOpacity(0.15) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: playerColor,
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
                style: myTextStyle(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: myTextStyle(fontColor: playerColor),
        ),
      ],
    );
  }
}