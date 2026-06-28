import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';
import 'mainPage.dart';

class LanguageSplashScreen extends StatelessWidget {
  const LanguageSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    Timer(const Duration(milliseconds: 800), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainPage(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
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
              Container(
                padding: r.all(0.02),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: r.w(0.005)),
                ),
                child: CircleAvatar(
                  radius: r.w(0.1),
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.electrical_services,
                    size: r.w(0.12),
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
              SizedBox(height: r.h(0.04)),
              Text(
                t.appTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: r.fs(0.06),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: r.h(0.025)),
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