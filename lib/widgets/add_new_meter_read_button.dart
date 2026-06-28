import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class AddNewMeterReadButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddNewMeterReadButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.add_rounded, size: r.w(0.12), color: const Color.fromARGB(255, 235, 235, 235)),
      tooltip: t.addReading,
      style: ButtonStyle(
        shadowColor: const WidgetStatePropertyAll(Colors.black),
        elevation: const WidgetStatePropertyAll(4),
        backgroundColor: WidgetStatePropertyAll(Colors.red.shade800),
      ),
    );
  }
}