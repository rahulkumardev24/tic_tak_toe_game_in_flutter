import 'package:flutter/material.dart';
import 'package:tic_tak_toe/colors.dart';
import 'package:tic_tak_toe/screen/home_screen.dart';
import 'package:tic_tak_toe/utils/custom_text_style.dart';
import 'package:tic_tak_toe/widgets/my_text_button.dart';
import 'package:velocity_x/velocity_x.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final player1Controller = TextEditingController();
  final player2Controller = TextEditingController();
  late Size size;

  @override
  void dispose() {
    player1Controller.dispose();
    player2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      /// --- Body --- ///
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight.withAlpha(100),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),

                  /// Game Title with animated decoration
                  Text(
                    "Tic Tac Toe",
                    style: myTextStyle(
                      fontFamily: "secondary",
                      fontSize: size.width * 0.1,
                    ),
                  ),
                  Text("Enter player names to begin",
                      style: myTextStyle(
                          fontSize: size.width * 0.05,
                          fontColor: AppColors.textSecondary)),
                  const SizedBox(height: 40),

                  Image.asset(
                    "assets/images/tic-tac-toe.png",
                    height: size.width * 0.5,
                    width: size.width * 0.5,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 40),

                  Expanded(
                    flex: 1,
                    child: VxArc(
                      height: size.height * 0.03,
                      arcType: VxArcType.convex,
                      edge: VxEdge.top,
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            color:
                                AppColors.textPrimary.withValues(alpha: 0.9)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),

                              /// Player Input Section
                              _buildPlayerInput(
                                controller: player1Controller,
                                labelColor: AppColors.oColor,
                                label: "Player 1 (O)",
                                hint: "Enter name for Player 1",
                                icon: Icons.person,
                                iconColor: AppColors.cardLight,
                              ),
                              const SizedBox(height: 20),
                              _buildPlayerInput(
                                controller: player2Controller,
                                labelColor: AppColors.xColor,
                                label: "Player 2 (X)",
                                hint: "Enter name for Player 2",
                                icon: Icons.person,
                                iconColor: AppColors.cardLight,
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              MyTextButton(
                                onTap: () {
                                  final player1 = player1Controller.text.isEmpty
                                      ? "Player 1"
                                      : player1Controller.text;
                                  final player2 = player2Controller.text.isEmpty
                                      ? "Player 2"
                                      : player2Controller.text;
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>
                                      HomeScreen(player1 , player2)));
                                },
                                backgroundColor: AppColors.card,
                                btnText: "Game Start",
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        ),
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

  Widget _buildPlayerInput({
    required TextEditingController controller,
    required String label,
    required Color labelColor,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: myTextStyle(fontFamily: "secondary", fontColor: labelColor),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: myTextStyle(
                  fontSize: size.width * 0.04, fontColor: Colors.white54),
              prefixIcon: Icon(icon, color: iconColor),
              filled: true,
              fillColor: Colors.white24,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            style:myTextStyle(fontColor: Colors.white),
          ),
        ),
      ],
    );
  }
}
