import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class PeriodInformationCard extends StatelessWidget {
  const PeriodInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    return Padding(
      padding: r.sym(0.04, 0.03),
      child: ListTile(
        title: Text(
          t.electricityPrice,
          style: TextStyle(fontSize: r.fs(0.07), color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 3),
        ),
        subtitle: Text(
          t.totalKiloWatts,
          style: TextStyle(fontSize: r.fs(0.05), color: Colors.red.shade500, fontWeight: FontWeight.w700, letterSpacing: 2),
        ),
        trailing: Text(
          "1 + 2\n\n20XX",
          style: TextStyle(fontSize: r.fs(0.03), color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1),
        ),
        tileColor: Colors.green.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.04))),
        dense: true,
      ),
    );
  }
}