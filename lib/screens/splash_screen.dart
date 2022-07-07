// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, depend_on_referenced_packages

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:cardgame/screens/auth/login_screen.dart';
import 'package:cardgame/resources/app_colors.dart';
//import 'package:cardgame/screens/mapsCard.dart';
//import 'package:cardgame/screens/room.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'cardgame',
        home: AnimatedSplashScreen(
            duration: 1000,
            splash: Container(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/images/splash.png',
              ),
            ),
            splashIconSize: double.infinity,
            nextScreen: LoginScreen(),
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: AppColors.PRIMARY_COLOR));
  }
}
