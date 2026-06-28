import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';
import 'onboarding_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
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
          child: Padding(
            padding: r.all(0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.language, color: Colors.white, size: r.w(0.2)),
                SizedBox(height: r.h(0.04)),
                Text(
                  'Select your language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: r.fs(0.06),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: r.h(0.02)),
                Text(
                  'اختر لغتك',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: r.fs(0.04),
                  ),
                ),
                SizedBox(height: r.h(0.08)),
                _buildLanguageButton(
                  context: context,
                  languageCode: 'en',
                  label: 'English',
                  flag: '🇬🇧',
                  provider: provider,
                ),
                SizedBox(height: r.h(0.03)),
                _buildLanguageButton(
                  context: context,
                  languageCode: 'ar',
                  label: 'العربية',
                  flag: '🇸🇦',
                  provider: provider,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required BuildContext context,
    required String languageCode,
    required String label,
    required String flag,
    required LocaleProvider provider,
  }) {
    final r = context;
    return SizedBox(
      width: double.infinity,
      height: r.h(0.08),
      child: ElevatedButton.icon(
        onPressed: () {
          provider.setLocale(Locale(languageCode));
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const OnboardingScreen(),
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          );
        },
        icon: Text(flag, style: TextStyle(fontSize: r.fs(0.07))),
        label: Text(
          label,
          style: TextStyle(fontSize: r.fs(0.05), fontWeight: FontWeight.w500),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.w(0.075)),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}