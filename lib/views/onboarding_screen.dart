import 'package:electricity_calculator/views/create_electricity_meter_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/legal_disclaimer_dialog.dart';
import '../utils/responsive.dart';
import 'mainPage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = const [
    OnboardingItem(
      icon: Icons.electrical_services,
      titleKey: 'onboardingTitle1',
      descriptionKey: 'onboardingDesc1',
      color: Color(0xFF2E7D32),
    ),
    OnboardingItem(
      icon: Icons.add_circle_outline,
      titleKey: 'onboardingTitle2',
      descriptionKey: 'onboardingDesc2',
      color: Color(0xFF4CAF50),
    ),
    OnboardingItem(
      icon: Icons.analytics,
      titleKey: 'onboardingTitle3',
      descriptionKey: 'onboardingDesc3',
      color: Color(0xFF1B5E20),
    ),
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const LegalDisclaimerDialog(),
    );
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const CreateElectricityMeterPage(isFirst: true,),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) => _buildPage(_pages[index], t),
          ),
          Positioned(
            bottom: r.h(0.06),
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: r.symH(0.015),
                      height: r.h(0.015),
                      width: _currentPage == index ? r.w(0.075) : r.w(0.025),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.green.shade700
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(r.w(0.0125)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: r.h(0.04)),
                Padding(
                  padding: r.symH(0.06),
                  child: SizedBox(
                    width: double.infinity,
                    height: r.h(0.07),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_currentPage == _pages.length - 1) {
                          await _finishOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(r.w(0.075)),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? t.getStarted ?? 'Get Started'
                            : t.next ?? 'Next',
                        style: TextStyle(fontSize: r.fs(0.045), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                if (_currentPage < _pages.length - 1)
                  Padding(
                    padding: EdgeInsets.only(top: r.h(0.02)),
                    child: TextButton(
                      onPressed: _finishOnboarding,
                      child: Text(
                        t.skip ?? 'Skip',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: r.fs(0.035),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem page, AppLocalizations t) {
    final r = context;
    final title = _getLocalizedText(page.titleKey, t);
    final description = _getLocalizedText(page.descriptionKey, t);

    return Padding(
      padding: r.all(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: r.all(0.075),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [page.color, page.color.withOpacity(0.7)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.color.withOpacity(0.3),
                  blurRadius: r.w(0.075),
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(page.icon, size: r.w(0.2), color: Colors.white),
          ),
          SizedBox(height: r.h(0.06)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: r.fs(0.07), fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: r.h(0.02)),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: r.fs(0.04), color: Colors.grey.shade600, height: 1.5),
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(String key, AppLocalizations t) {
    switch (key) {
      case 'onboardingTitle1':
        return t.onboardingTitle1 ?? 'Track Your Usage';
      case 'onboardingDesc1':
        return t.onboardingDesc1 ??
            'Easily track your electricity consumption with meter readings and get clear cost breakdowns.';
      case 'onboardingTitle2':
        return t.onboardingTitle2 ?? 'Add Readings Quickly';
      case 'onboardingDesc2':
        return t.onboardingDesc2 ??
            'Add new meter readings in seconds with our simple form. Your data is stored securely on your device.';
      case 'onboardingTitle3':
        return t.onboardingTitle3 ?? 'View Your History';
      case 'onboardingDesc3':
        return t.onboardingDesc3 ??
            'Review past periods, see your consumption trends, and calculate costs with tiered pricing.';
      default:
        return key;
    }
  }
}

class OnboardingItem {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;
  final Color color;
  const OnboardingItem({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
    required this.color,
  });
}