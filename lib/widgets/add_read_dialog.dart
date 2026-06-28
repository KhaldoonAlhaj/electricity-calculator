import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class AddReadDialog extends StatefulWidget {
  final int meterId; // new: required meter ID
  const AddReadDialog({super.key, required this.meterId});

  @override
  State<AddReadDialog> createState() => _AddReadDialogState();
}

class _AddReadDialogState extends State<AddReadDialog> {
  final _formKey = GlobalKey<FormState>();
  double? _kiloWatts;
  int _selectedPeriod = _getCurrentPeriod();
  DateTime _selectedDateTime = DateTime.now();
  final int currentYear = DateTime.now().year;
  final int currentPeriod = _getCurrentPeriod();

  List<String> get _periodNames {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic) {
      return const [
        'يناير – فبراير',
        'مارس – أبريل',
        'مايو – يونيو',
        'يوليو – أغسطس',
        'سبتمبر – أكتوبر',
        'نوفمبر – ديسمبر',
      ];
    }
    return const [
      'Jan – Feb',
      'Mar – Apr',
      'May – Jun',
      'Jul – Aug',
      'Sep – Oct',
      'Nov – Dec',
    ];
  }

  static int _getCurrentPeriod() {
    final month = DateTime.now().month;
    if (month <= 2) return 1;
    if (month <= 4) return 2;
    if (month <= 6) return 3;
    if (month <= 8) return 4;
    if (month <= 10) return 5;
    return 6;
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

  void _submit() {
    final t = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop({
        'kiloWatts': _kiloWatts,
        'year': currentYear,
        'period': _selectedPeriod,
        'dateTime': _selectedDateTime,
        // meterId is not needed in the map – the caller already knows it
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.invalidNumber)),
      );
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                        child: Icon(Icons.add_circle_outline, color: Colors.green.shade700, size: r.w(0.07)),
                      ),
                      SizedBox(width: r.w(0.03)),
                      Expanded(
                        child: Text(
                          t.newElectricityReading,
                          style: TextStyle(fontSize: r.fs(0.05), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.h(0.04)),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,7}(\.\d{0,1})?')),
                    ],
                    decoration: InputDecoration(
                      labelText: t.kilowattReading,
                      hintText: 'e.g., 1250.5',
                      prefixIcon: Icon(Icons.electric_bolt, color: Colors.green.shade600, size: r.w(0.05)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(r.w(0.04))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(r.w(0.04)),
                        borderSide: BorderSide(color: Colors.green.shade600),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return t.required;
                      if (double.tryParse(value.trim()) == null) return t.invalidNumber;
                      return null;
                    },
                    onSaved: (value) => _kiloWatts = double.parse(value!.trim()),
                  ),
                  SizedBox(height: r.h(0.03)),
                  DropdownButtonFormField<int>(
                    value: _selectedPeriod,
                    decoration: InputDecoration(
                      labelText: t.billingPeriod,
                      prefixIcon: Icon(Icons.timeline, color: Colors.green.shade600, size: r.w(0.05)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(r.w(0.04))),
                    ),
                    dropdownColor: Colors.green.shade50,
                    items: List.generate(6, (i) {
                      final period = i + 1;
                      final isDisabled = (period > currentPeriod);
                      return DropdownMenuItem(
                        value: period,
                        enabled: !isDisabled,
                        child: Row(
                          children: [
                            Container(
                              width: r.w(0.07),
                              height: r.w(0.07),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(r.w(0.02)),
                              ),
                              child: Center(child: Text('$period', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs(0.035)))),
                            ),
                            SizedBox(width: r.w(0.03)),
                            Text(_periodNames[i], style: TextStyle(fontSize: r.fs(0.035))),
                            if (isDisabled)
                              Icon(Icons.lock, size: r.w(0.04), color: Colors.grey),
                          ],
                        ),
                      );
                    }),
                    onChanged: (value) => setState(() => _selectedPeriod = value!),
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
                        onPressed: _submit,
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
        ),
      ),
    );
  }
}