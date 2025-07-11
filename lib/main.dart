import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tic_tak_toe/provider/them_provider.dart';
import 'package:tic_tak_toe/screen/ai_game_screen.dart';
import 'package:tic_tak_toe/screen/game_mode_selection_screen.dart';
import 'package:tic_tak_toe/screen/home_screen.dart';
import 'package:tic_tak_toe/screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// always show Portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Splash screen show in full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> ThemProvider())
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemProvider>().isDark ;
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        title: 'TicTacToe',
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: SplashScreen());
  }
}

