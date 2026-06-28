import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;

    final List<TutorialItem> items = [
      TutorialItem(
        icon: Icons.info_outline,
        title: t.tutorialOverviewTitle,
        description: t.tutorialOverviewDesc,
      ),
      TutorialItem(
        icon: Icons.numbers,
        title: t.tutorialMinReadingsTitle,
        description: t.tutorialMinReadingsDesc,
      ),
      TutorialItem(
        icon: Icons.add_circle_outline,
        title: t.tutorialAddReadingTitle,
        description: t.tutorialAddReadingDesc,
      ),
      TutorialItem(
        icon: Icons.edit,
        title: t.tutorialEditDeleteTitle,
        description: t.tutorialEditDeleteDesc,
      ),
      TutorialItem(
        icon: Icons.timeline,
        title: t.tutorialConsumptionTitle,
        description: t.tutorialConsumptionDesc,
      ),
      TutorialItem(
        icon: Icons.history,
        title: t.tutorialHistoryTitle,
        description: t.tutorialHistoryDesc,
      ),
      TutorialItem(
        icon: Icons.devices_other,
        title: t.tutorialAddMeterTitle,
        description: t.tutorialAddMeterDesc,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(t.tutorialTitle),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: r.all(0.04),
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          final item = items[index];
          return Card(
            margin: EdgeInsets.only(bottom: r.h(0.02)),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r.w(0.04)),
            ),
            child: Padding(
              padding: r.all(0.04),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: r.all(0.025),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(r.w(0.04)),
                    ),
                    child: Icon(
                      item.icon,
                      color: Colors.green.shade700,
                      size: r.w(0.08),
                    ),
                  ),
                  SizedBox(width: r.w(0.04)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: r.fs(0.045),
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: r.h(0.01)),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: r.fs(0.035),
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TutorialItem {
  final IconData icon;
  final String title;
  final String description;
  TutorialItem({required this.icon, required this.title, required this.description});
}