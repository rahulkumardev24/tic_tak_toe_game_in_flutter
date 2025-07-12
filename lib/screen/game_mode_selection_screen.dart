import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:tic_tak_toe/provider/them_provider.dart';
import 'package:tic_tak_toe/screen/start_screen.dart';
import 'package:tic_tak_toe/utils/custom_text_style.dart';

import '../colors.dart';
import 'ai_game_screen.dart';
import 'home_screen.dart';

class GameModeSelectionScreen extends StatelessWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemProvider>().isDark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.primaryLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// setting part
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        context.read<ThemProvider>().toggleTheme();
                      },
                      icon: Icon(Icons.sunny))
                ],
              ),
              Spacer(),

              // Game Title with Animation
              _buildAnimatedTitle(size),
              const SizedBox(height: 40),

              // Game Mode Cards
              _buildGameModeCards(context),
              Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle(Size size) {
    return Column(
      children: [
        // Animated XO text with glow effect
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/xicon.webp",
              height: size.height * 0.1,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 5000.ms, color: AppColors.card),
            Image.asset(
              "assets/images/0icon.png",
              height: size.height * 0.1,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 5000.ms, color: AppColors.card),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
                  textAlign: TextAlign.center,
                  "Tic Tac Toe",
                  style: TextStyle(
                      fontSize: size.width * 0.1,
                      fontFamily: "secondary",
                      height: 0.9))
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.2),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose your game mode",
          style: myTextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildGameModeCards(BuildContext context) {
    return Column(
      children: [
        // Play with Friends Card
        _buildGameModeCard(
          context,
          title: "Play With Friends",
          subtitle: "Challenge your friends locally",
          icon: Icons.people_alt_rounded,
          color: const Color(0xFF4CAF50),
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => StartScreen()));
          },
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
        const SizedBox(height: 24),

        // Play with AI Card
        _buildGameModeCard(context,
                title: "Play With AI",
                subtitle: "Test your skills against computer",
                icon: Icons.smart_toy_rounded,
                color: const Color(0xFF2196F3),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AiGameScreen())))
            .animate()
            .fadeIn(delay: 400.ms)
            .slideX(begin: 0.2),
      ],
    );
  }

  Widget _buildGameModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        highlightColor: color.withOpacity(0.1),
        splashColor: color.withOpacity(0.2),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 20),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
