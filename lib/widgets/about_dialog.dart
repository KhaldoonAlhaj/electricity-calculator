import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final r = context;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.08))),
        elevation: 16,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: r.all(0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(r.w(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.green.shade100.withOpacity(0.6),
                blurRadius: r.w(0.04),
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row – icon + title/version
              Row(
                children: [
                  Container(
                    padding: r.all(0.025),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                      ),
                    ),
                    child: const Icon(
                      Icons.electrical_services,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: r.w(0.04)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.appTitle,
                          style: TextStyle(
                            fontSize: r.fs(0.05),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                        Text(
                          t.version,
                          style: TextStyle(
                            fontSize: r.fs(0.025),
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.h(0.03)),
              const Divider(height: 1),
              SizedBox(height: r.h(0.03)),
              // Developer section (green)
              Row(
                children: [
                  Container(
                    padding: r.all(0.02),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(r.w(0.04)),
                    ),
                    child: const Icon(Icons.person_outline, color: Color(0xFF2E7D32)),
                  ),
                  SizedBox(width: r.w(0.04)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.developer,
                          style: TextStyle(
                            fontSize: r.fs(0.025),
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          t.developerName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          t.builtWith,
                          style: TextStyle(
                            fontSize: r.fs(0.025),
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.h(0.03)),
              // Email section (Gmail colours)
              const Divider(height: 1),
              SizedBox(height: r.h(0.02)),
              Text(
                t.contact,
                style: TextStyle(
                  fontSize: r.fs(0.03),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1B5E20),
                ),
              ),
              SizedBox(height: r.h(0.015)),
              InkWell(
                onTap: () => _launchEmail(),
                borderRadius: BorderRadius.circular(r.w(0.04)),
                child: Container(
                  padding: r.sym(0.03, 0.02),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(r.w(0.04)),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.red.shade700,
                        size: r.w(0.045),
                      ),
                      SizedBox(width: r.w(0.025)),
                      Text(
                        "khaldoon.alhaj@gmail.com",
                        style: TextStyle(
                          fontSize: r.fs(0.035),
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: r.h(0.04)),
              // Close button (green)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    padding: r.symV(0.025),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.w(0.075)),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    t.close,
                    style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchEmail() async {
    final emailUri = Uri(scheme: 'mailto', path: 'khaldoon.alhaj@gmail.com');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    }
  }
}