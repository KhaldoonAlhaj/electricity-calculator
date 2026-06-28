import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class MeterReadItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MeterReadItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    return Padding(
      padding: EdgeInsets.only(bottom: r.h(0.025), left: r.w(0.03), right: r.w(0.03)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(r.w(0.04)),
          border: Border.all(color: Colors.grey.shade300, width: r.w(0.0025)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: r.w(0.01),
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(Icons.electric_meter_rounded, size: r.w(0.07), color: Colors.black87),
          title: Text(title, style: TextStyle(fontSize: r.fs(0.045), fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle, style: TextStyle(fontSize: r.fs(0.035), color: Colors.grey)),
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: r.w(0.06)),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.blue, size: r.w(0.045)),
                    SizedBox(width: r.w(0.02)),
                    Text(t.editReading, style: TextStyle(fontSize: r.fs(0.035))),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: r.w(0.045)),
                    SizedBox(width: r.w(0.02)),
                    Text(t.deleteReading, style: TextStyle(fontSize: r.fs(0.035))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}