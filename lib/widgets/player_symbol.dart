import 'package:flutter/material.dart';

class PlayerSymbol extends StatelessWidget {
  final String symbol;

  const PlayerSymbol({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
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
}
