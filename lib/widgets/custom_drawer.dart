import 'package:electricity_calculator/views/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../views/history_page.dart';
import '../views/language_splash_screen.dart';
import '../views/electricity_meter_list_page.dart';
import '../views/tutorial_page.dart';
import '../widgets/about_dialog.dart';
import '../widgets/legal_disclaimer_dialog.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';
import '../utils/navigation.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  void _exitApp() => SystemNavigator.pop();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final provider = Provider.of<LocaleProvider>(context);
    final isArabic = provider.locale.languageCode == 'ar';
    final r = context;
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: r.symV(0.04),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(r.w(0.075)),
                    bottomRight: Radius.circular(r.w(0.075)),
                  ),
                ),
                child: Column(
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
                    SizedBox(height: r.h(0.02)),
                    Text(
                      t.appTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: r.fs(0.055),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: r.h(0.005)),
                    Text(
                      t.trackUsage,
                      style: TextStyle(color: Colors.white70, fontSize: r.fs(0.035)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: r.h(0.004)),
              // Meters item (localized)
              _buildDrawerItem(
                context: context,
                icon: Icons.electric_meter_rounded,
                title: t.drawerMeters,
                subtitle: t.drawerMetersSub,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    fadeTransition(const ElectricityMeterListPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.history_rounded,
                title: t.drawerHistory,
                subtitle: t.drawerHistorySub,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    fadeTransition(const HistoryPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.help_outline,
                title: t.tutorialTitle,
                subtitle: t.tutorialSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    fadeTransition(const TutorialPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.gavel_rounded,
                title: t.drawerLegal,
                subtitle: t.drawerLegalSub,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (ctx) => const LegalDisclaimerDialog(),
                  );
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.info_rounded,
                title: t.drawerAbout,
                subtitle: t.drawerAboutSub,
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (ctx) => const AboutDialogWidget(),
                  );
                },
              ),
              _buildDrawerItem(
                context: context,
                icon: Icons.language,
                title: t.language,
                subtitle: isArabic ? "العربية -> الإنجليزية" : "English -> العربية",
                onTap: () {
                  Navigator.pop(context);
                  final newLocale = isArabic ? const Locale('en') : const Locale('ar');
                  provider.setLocale(newLocale);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      fadeTransition(const LanguageSplashScreen()),
                    );
                  });
                },
              ),
              const Spacer(),
              Padding(
                padding: r.all(0.04),
                child: Column(
                  children: [
                    const Divider(color: Colors.white30),
                    SizedBox(height: r.h(0.015)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.version,
                          style: TextStyle(color: Colors.white70, fontSize: r.fs(0.03)),
                        ),
                        IconButton(
                          icon: Icon(Icons.logout, color: Colors.white70, size: r.w(0.05)),
                          onPressed: () {
                            Navigator.pop(context);
                            _exitApp();
                          },
                          tooltip: t.drawerExit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final r = context;
    return Padding(
      padding: r.symH(0.04),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(r.w(0.05)),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            padding: r.symV(0.015),
            child: Row(
              children: [
                Container(
                  padding: r.all(0.025),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(r.w(0.04)),
                  ),
                  child: Icon(icon, color: Colors.white, size: r.w(0.06)),
                ),
                SizedBox(width: r.w(0.04)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: r.fs(0.04),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: r.h(0.005)),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: r.fs(0.03),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white70, size: r.w(0.05)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}