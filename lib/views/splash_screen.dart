import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../providers/locale_provider.dart';
import '../utils/responsive.dart';
import 'create_electricity_meter_page.dart';
import 'language_selection_screen.dart';
import 'onboarding_screen.dart';
import 'mainPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    Timer(const Duration(seconds: 3), _navigateToNextScreen);
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final languageChosen = prefs.getBool('languageChosen') ?? false;
    final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

    Widget nextScreen;
    if (!languageChosen) {
      nextScreen = const LanguageSelectionScreen();
    } else if (!onboardingComplete) {
      nextScreen = const OnboardingScreen();
    } else {
      // Check for default meter
      final defaultMeter = await DatabaseHelper.instance.getDefaultMeter();
      if (defaultMeter == null) {
        nextScreen = const CreateElectricityMeterPage(isFirst: true);
      } else {
        final periods = await DatabaseHelper.instance.getPeriodsForMeter(defaultMeter.id!);
        periods.sort();
        nextScreen = MainPage(initialPeriods: periods);
      }
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => nextScreen,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = context;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade900, Colors.green.shade600],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Container(
                        padding: r.all(0.02),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: r.w(0.005)),
                        ),
                        child: CircleAvatar(
                          radius: r.w(0.12),
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.electrical_services,
                            size: r.w(0.15),
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: r.h(0.06)),
              Text(
                'Electricity Calculator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: r.fs(0.07),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: r.h(0.02)),
              Text(
                'Track your usage',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: r.fs(0.04),
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: r.h(0.08)),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}