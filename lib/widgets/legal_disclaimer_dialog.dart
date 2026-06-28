import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class LegalDisclaimerDialog extends StatelessWidget {
  const LegalDisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final r = context;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.06))),
        child: Container(
          padding: r.all(0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.w(0.06)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: r.all(0.04),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(r.w(0.04)),
                  border: Border.all(color: Colors.red.shade800, width: r.w(0.003)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_rounded, size: r.w(0.06), color: Colors.red),
                        SizedBox(width: r.w(0.02)),
                        Text(
                          t.legalNotice,
                          style: TextStyle(
                            fontSize: r.fs(0.04),
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.h(0.03)),
                    Text(
                      t.legalText,
                      style: TextStyle(fontSize: r.fs(0.035), color: Colors.black87, height: 1.5),
                    ),
                    SizedBox(height: r.h(0.03)),
                    Row(
                      children: [
                        Icon(Icons.gavel, size: r.w(0.045), color: Colors.red),
                        SizedBox(width: r.w(0.02)),
                        Text(
                          t.noLiability,
                          style: TextStyle(
                            fontSize: r.fs(0.033),
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: r.h(0.035)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                    foregroundColor: Colors.white,
                    padding: r.symV(0.018),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(r.w(0.075)),
                    ),
                  ),
                  child: Text(t.iUnderstand, style: TextStyle(fontSize: r.fs(0.04))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}