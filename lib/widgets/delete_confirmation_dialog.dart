import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
  final t = AppLocalizations.of(context)!;
  final r = context;
  return showDialog<bool>(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.07))),
      child: Container(
        padding: r.all(0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, size: r.w(0.12), color: Colors.red),
            SizedBox(height: r.h(0.03)),
            Text(t.deleteReading, style: TextStyle(fontSize: r.fs(0.05), fontWeight: FontWeight.bold)),
            SizedBox(height: r.h(0.02)),
            Text(t.deleteConfirm, style: TextStyle(fontSize: r.fs(0.035))),
            SizedBox(height: r.h(0.04)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(t.cancel, style: TextStyle(fontSize: r.fs(0.04))),
                ),
                SizedBox(width: r.w(0.03)),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(t.delete, style: TextStyle(fontSize: r.fs(0.04))),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}