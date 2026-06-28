import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class EditReadDialog extends StatefulWidget {
  final double currentValue;
  final DateTime currentDateTime;

  const EditReadDialog({
    super.key,
    required this.currentValue,
    required this.currentDateTime,
  });

  @override
  State<EditReadDialog> createState() => _EditReadDialogState();
}

class _EditReadDialogState extends State<EditReadDialog> {
  late TextEditingController _controller;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue.toString());
    _selectedDateTime = widget.currentDateTime;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = _selectedDateTime;
    final currentYear = DateTime.now().year;
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(currentYear, 1, 1),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year, date.month, date.day,
            time.hour, time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final r = context;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.07))),
        elevation: 8,
        child: Container(
          width: r.w(0.9),
          padding: r.all(0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(r.w(0.07)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: r.all(0.02),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(r.w(0.03)),
                    ),
                    child: Icon(Icons.edit, color: Colors.green.shade700, size: r.w(0.07)),
                  ),
                  SizedBox(width: r.w(0.03)),
                  Expanded(
                    child: Text(
                      t.editReading,
                      style: TextStyle(fontSize: r.fs(0.05), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.h(0.04)),
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,7}(\.\d{0,1})?')),
                ],
                decoration: InputDecoration(
                  labelText: t.kilowattReading,
                  prefixIcon: Icon(Icons.electric_bolt, color: Colors.green.shade600, size: r.w(0.05)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(r.w(0.04))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(r.w(0.04)),
                    borderSide: BorderSide(color: Colors.green.shade600),
                  ),
                ),
              ),
              SizedBox(height: r.h(0.03)),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(r.w(0.04)),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.access_time, size: r.w(0.05)),
                  title: Text(t.dateAndTime, style: TextStyle(fontSize: r.fs(0.035))),
                  subtitle: Text(
                    DateFormat('d/M/yyyy, h:mm a').format(_selectedDateTime),
                    style: TextStyle(fontSize: r.fs(0.03)),
                  ),
                  trailing: Icon(Icons.chevron_right, size: r.w(0.04)),
                  onTap: _pickDateTime,
                ),
              ),
              SizedBox(height: r.h(0.04)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(t.cancel, style: TextStyle(fontSize: r.fs(0.04))),
                  ),
                  SizedBox(width: r.w(0.03)),
                  ElevatedButton(
                    onPressed: () {
                      final newValue = double.tryParse(_controller.text);
                      if (newValue != null) {
                        Navigator.pop(context, {'value': newValue, 'dateTime': _selectedDateTime});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.invalidNumber)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.075))),
                      padding: r.symH(0.06),
                    ),
                    child: Text(t.save, style: TextStyle(fontSize: r.fs(0.04))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}