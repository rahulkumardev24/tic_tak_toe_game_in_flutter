import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';
import 'package:tic_tak_toe/screen/home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  final player1Controller = TextEditingController();
  final player2Controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    player1Controller.dispose();
    player2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Game Title
                  const Text(
                    "Tic Tac Toe",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      shadows: [
                      Shadow(
                      blurRadius: 4.0,
                      color: Colors.black12,
                      offset: Offset(2.0, 2.0),
                      )],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter player names to begin",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Animated Game Logo
                  ScaleTransition(
                    scale: _animation,
                    child: Image.asset(
                      "assets/images/tic-tac-toe.png",
                      height: 220,
                      width: 220,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Player 1 Input
                  _buildPlayerInput(
                    controller: player1Controller,
                    label: "Player 1 (O)",
                    icon: Icons.person_outline,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),

                  // Player 2 Input
                  _buildPlayerInput(
                    controller: player2Controller,
                    label: "Player 2 (X)",
                    icon: Icons.person_outline,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 40),

                  // Start Game Button
                  _buildStartButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blueGrey),
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color.withOpacity(0.5), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          final player1 = player1Controller.text.isEmpty
              ? "Player 1"
              : player1Controller.text;
          final player2 = player2Controller.text.isEmpty
              ? "Player 2"
              : player2Controller.text;

          Navigator.of(context).pushReplacement(
            _createRoute(HomeScreen(player1, player2)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "START GAME",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutQuart;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 600),
  );
}