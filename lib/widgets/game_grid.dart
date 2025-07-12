import 'package:flutter/material.dart';
import 'package:tic_tak_toe/widgets/player_symbol.dart';

class GameGrid extends StatelessWidget {
  final List<String> displayOX;
  final List<int> matchColor;
  final Color oColor;
  final Color xColor;
  final void Function(int index) onTap;

  const GameGrid({
    super.key,
    required this.displayOX,
    required this.matchColor,
    required this.oColor,
    required this.xColor,
    required this.onTap,
  });

  Color _getWinningCellColor(String symbol) {
    if (symbol == "O") return oColor;
    if (symbol == "X") return xColor;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
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
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: matchColor.contains(index)
                        ? _getWinningCellColor(displayOX[index]).withOpacity(0.2)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: matchColor.contains(index)
                          ? _getWinningCellColor(displayOX[index])
                          : Colors.grey.shade200,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: displayOX[index] == ""
                        ? null
                        : PlayerSymbol(symbol: displayOX[index]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}