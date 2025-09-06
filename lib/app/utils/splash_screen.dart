import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: screenWidth * 0.75,
            height: screenWidth * 0.75,
            child: Lottie.asset('assets/lottie/hello.json'),
          ),
        ),
      ),
    );
  }
}
