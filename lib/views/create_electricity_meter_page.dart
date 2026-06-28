import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/db_helper.dart';
import '../models/electricity_meter.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';
import 'mainPage.dart';

class CreateElectricityMeterPage extends StatefulWidget {
  final bool isFirst;
  const CreateElectricityMeterPage({super.key, this.isFirst = false});

  @override
  State<CreateElectricityMeterPage> createState() => _CreateElectricityMeterPageState();
}

class _CreateElectricityMeterPageState extends State<CreateElectricityMeterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedType = 'household';
  final List<String> _types = ['household', 'industrial', 'commercial'];
  bool _isLoading = false;

  Future<void> _createMeter() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final existingMeters = await DatabaseHelper.instance.getAllMeters();
      final isFirst = existingMeters.isEmpty;
      final newMeter = ElectricityMeter(
        name: _nameController.text.trim(),
        type: _selectedType!,
        isDefault: isFirst,
      );
      await DatabaseHelper.instance.insertMeter(newMeter);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (widget.isFirst) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      } else {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;

    // Localized type labels
    final Map<String, String> typeLabels = {
      'household': t.household,
      'industrial': t.industrial,
      'commercial': t.commercial,
    };

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.green.shade900,
          statusBarIconBrightness: Brightness.light,
        ),
        child: CustomScrollView(
          slivers: [
            // Header – exactly like the main page
            SliverAppBar(
              expandedHeight: r.h(0.25),
              pinned: true,
              backgroundColor: Colors.transparent,
              // Back button automatically handled by leading
              leading: widget.isFirst
                  ? null
                  : IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: r.w(0.07),
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green.shade900, Colors.green.shade600],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: r.symH(0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: r.all(0.02),
                            child: Icon(
                              Icons.electric_meter_rounded,
                              size: r.w(0.25),
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(width: r.w(0.03)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.isFirst ? t.welcome : t.addElectricityMeter,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: r.fs(0.055),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.isFirst
                                          ? t.setUpFirstMeter
                                          : t.addNewMeter,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: r.fs(0.03),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.h(0.015)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // No actions
            ),
            // Form content
            SliverPadding(
              padding: r.all(0.04),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.meterName,
                          style: TextStyle(
                            fontSize: r.fs(0.04),
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: r.h(0.01)),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: t.homeOfficeShop,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.w(0.04)),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.w(0.04)),
                              borderSide: BorderSide(color: Colors.green.shade700),
                            ),
                            contentPadding: r.sym(0.04, 0.025),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return t.pleaseEnterName;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: r.h(0.03)),
                        Text(
                          t.consumptionType,
                          style: TextStyle(
                            fontSize: r.fs(0.04),
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: r.h(0.01)),
                        DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.w(0.04)),
                              borderSide: BorderSide(color: Colors.grey.shade400),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.w(0.04)),
                              borderSide: BorderSide(color: Colors.green.shade700),
                            ),
                            contentPadding: r.sym(0.04, 0.025),
                          ),
                          items: _types.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(typeLabels[type]!),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _selectedType = value),
                        ),
                        SizedBox(height: r.h(0.05)),
                        _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                          width: double.infinity,
                          height: r.h(0.07),
                          child: ElevatedButton(
                            onPressed: _createMeter,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(r.w(0.075)),
                              ),
                              elevation: 4,
                              shadowColor: Colors.green.shade300,
                            ),
                            child: Text(
                              widget.isFirst ? t.startTracking : t.addMeter,
                              style: TextStyle(
                                fontSize: r.fs(0.045),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}