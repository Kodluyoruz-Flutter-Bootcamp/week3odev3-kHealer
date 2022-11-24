import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odev_baslangic_shared_pref_start/login_page.dart';
import 'package:lottie/lottie.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Lottie.asset("assets/education.json"),
          // Image.asset("assets/logo_icon2.png"),
          // const Text(
          //   "Grade app",
          //   style: TextStyle(
          //     fontSize: 40,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // )
        ],
      ),
      backgroundColor: Colors.red,
      nextScreen: const LoginPage(),
      splashIconSize: 250,
      duration: 3200,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(seconds: 4),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
    );
  }
}
