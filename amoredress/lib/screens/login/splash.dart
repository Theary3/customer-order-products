import 'dart:async';
import 'package:mobileassignment/screens/login/login_screen.dart';
import 'package:mobileassignment/screens/login/onboarding_screen.dart';
import 'package:mobileassignment/screens/login/register_screen.dart';
import 'package:flutter/material.dart';
import '../homepage/home.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF997053),
      body: Center(
        child: Image.asset(
          'assets/images/amorewhite.png', 
          width: 400,
        ),
      ),
    );
  }
}
