import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/electricity_period.dart';
import '../models/electricity_meter_read.dart';
import '../models/electricity_meter.dart';
import '../l10n/app_localizations.dart';
import '../widgets/custom_drawer.dart';
import '../utils/responsive.dart';
import 'mainPage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ElectricityPeriod> _periods = [];
  ElectricityMeter? _currentMeter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPeriods();
  }

  Future<void> _loadPeriods() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final meter = await DatabaseHelper.instance.getDefaultMeter();
      if (!mounted) return;
      if (meter == null) {
        setState(() {
          _periods = [];
          _currentMeter = null;
          _isLoading = false;
        });
        return;
      }
      _currentMeter = meter;
      final periods = await DatabaseHelper.instance.getPeriodsForMeter(meter.id!);
      if (!mounted) return;
      periods.sort((a, b) {
        if (a.periodYear != b.periodYear) return b.periodYear.compareTo(a.periodYear);
        return b.periodNumber.compareTo(a.periodNumber);
      });
      setState(() {
        _periods = periods;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      print('Error loading history: $e');
    }
  }

  String _formatKwh(double value) => value.toStringAsFixed(1);
  String _formatPriceOld(double price) => NumberFormat('#,###').format(price * 100);
  String _formatPriceNew(double price) => NumberFormat('#,###').format(price);

  Map<String, double> _calculateTiers(ElectricityPeriod period, String meterType) {
    double totalKwh = 0;
    if (period.electricityMeterReads.length >= 2) {
      totalKwh = period.electricityMeterReads.last.read - period.electricityMeterReads.first.read;
    }
    if (meterType != 'household') {
      return {
        'totalKwh': totalKwh,
        'tier1Kwh': 0.0,
        'tier2Kwh': totalKwh,
        'tier1Cost': 0.0,
        'tier2Cost': totalKwh * 14, // using new rate
      };
    }
    final tier1Kwh = totalKwh > 300 ? 300.0 : totalKwh;
    final tier2Kwh = totalKwh > 300 ? totalKwh - 300 : 0.0;
    return {
      'totalKwh': totalKwh,
      'tier1Kwh': tier1Kwh,
      'tier2Kwh': tier2Kwh,
      'tier1Cost': tier1Kwh * 6,
      'tier2Cost': tier2Kwh * 14,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: r.w(0.06)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.drawerHistory,
              style: TextStyle(fontSize: r.fs(0.05), color: Colors.white),
            ),
            if (_currentMeter != null)
              Text(
                '${_currentMeter!.name} (${switch (_currentMeter!.type) {
                  "household" => t.household.toUpperCase(),
                  "commercial" => t.commercial.toUpperCase(),
                  "industrial" => t.industrial.toUpperCase(),
                  _ => _currentMeter!.type.toUpperCase(), // fallback
                }})',
                style: TextStyle(fontSize: r.fs(0.025), color: Colors.white70),
              ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: r.w(0.06)),
            onPressed: _loadPeriods,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentMeter == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.device_unknown, size: r.w(0.16), color: Colors.grey),
            SizedBox(height: r.h(0.04)),
            Text(
              t.noMeterFoundTitle,
              style: TextStyle(fontSize: r.fs(0.045)),
            ),
            Text(
              t.noMeterFoundSubtitle,
              style: TextStyle(fontSize: r.fs(0.035), color: Colors.grey),
            ),
          ],
        ),
      )
          : _periods.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: r.w(0.16), color: Colors.grey),
            SizedBox(height: r.h(0.04)),
            Text(t.noPeriodsFound, style: TextStyle(fontSize: r.fs(0.045))),
            Text(t.addFirstReading, style: TextStyle(fontSize: r.fs(0.035))),
          ],
        ),
      )
          : ListView.builder(
        padding: r.all(0.03),
        itemCount: _periods.length,
        itemBuilder: (context, index) {
          final period = _periods[index];
          final tiers = _calculateTiers(period, _currentMeter!.type);
          return _buildExpandablePeriodCard(period, tiers, t);
        },
      ),
    );
  }

  Widget _buildExpandablePeriodCard(
      ElectricityPeriod period,
      Map<String, double> tiers,
      AppLocalizations t,
      ) {
    final r = context;
    final reads = List<ElectricityMeterRead>.from(period.electricityMeterReads);
    reads.sort((a, b) => a.readDateTime.compareTo(b.readDateTime));

    final readingsCount = period.electricityMeterReads.length;
    final readingsLabel = readingsCount == 1 ? t.reading : t.readings;
    final isHousehold = _currentMeter?.type == 'household';

    return Card(
      margin: EdgeInsets.only(bottom: r.h(0.02)),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.05))),
      child: ExpansionTile(
        tilePadding: r.symH(0.04),
        childrenPadding: EdgeInsets.fromLTRB(r.w(0.04), 0, r.w(0.04), r.h(0.02)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.05))),
        title: Row(
          children: [
            Container(
              width: r.w(0.1),
              height: r.w(0.1),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(r.w(0.03)),
              ),
              child: Center(
                child: Text(
                  '${period.periodNumber}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r.fs(0.045),
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ),
            SizedBox(width: r.w(0.03)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${t.period} ${period.periodNumber} • ${period.periodYear}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs(0.04)),
                  ),
                  SizedBox(height: r.h(0.005)),
                  Text(
                    '$readingsCount $readingsLabel',
                    style: TextStyle(fontSize: r.fs(0.03), color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${_formatPriceNew(period.electricityPrice)} ${t.newSyp}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: r.fs(0.035),
                    color: Colors.green,
                  ),
                ),
                Text(
                  '${_formatPriceOld(period.electricityPrice)} ${t.oldSyp}',
                  style: TextStyle(fontSize: r.fs(0.025), color: Colors.grey),
                ),
                if (period.paid)
                  Container(
                    margin: EdgeInsets.only(top: r.h(0.005)),
                    padding: r.symH(0.02),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(r.w(0.03)),
                    ),
                    child: Text(
                      t.paid,
                      style: TextStyle(fontSize: r.fs(0.025), fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ],
        ),
        children: [
          // Total consumption
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.totalConsumption, style: TextStyle(fontWeight: FontWeight.w500, fontSize: r.fs(0.035))),
              Text(
                '${_formatKwh(tiers['totalKwh']!)} ${t.kWh}',
                style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(),
          if (isHousehold) ...[
            Text(t.tierDetails, style: TextStyle(fontWeight: FontWeight.w600, fontSize: r.fs(0.035))),
            SizedBox(height: r.h(0.01)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.tier1, style: TextStyle(fontSize: r.fs(0.03), color: Colors.grey)),
                      Text('${_formatKwh(tiers['tier1Kwh']!)} ${t.kWh}',
                          style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w500)),
                      Text('@ ${t.rate6}', style: TextStyle(fontSize: r.fs(0.03), color: Colors.grey)),
                      Text('${_formatPriceOld(tiers['tier1Cost']!)} ${t.oldSyp}',
                          style: TextStyle(fontSize: r.fs(0.03))),
                      Text('${_formatPriceNew(tiers['tier1Cost']!)} ${t.newSyp}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs(0.03), color: Colors.green)),
                    ],
                  ),
                ),
                SizedBox(width: r.w(0.04)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.tier2, style: TextStyle(fontSize: r.fs(0.03), color: Colors.grey)),
                      Text('${_formatKwh(tiers['tier2Kwh']!)} ${t.kWh}',
                          style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w500)),
                      Text('@ ${t.rate14}', style: TextStyle(fontSize: r.fs(0.03), color: Colors.grey)),
                      Text('${_formatPriceOld(tiers['tier2Cost']!)} ${t.oldSyp}',
                          style: TextStyle(fontSize: r.fs(0.03))),
                      Text('${_formatPriceNew(tiers['tier2Cost']!)} ${t.newSyp}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs(0.03), color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            // Flat rate summary for non‑household
            Padding(
              padding: r.symV(0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.totalUsage,
                    style: TextStyle(fontSize: r.fs(0.035), fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${_formatKwh(tiers['totalKwh']!)} ${t.kWh}',
                    style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.rateLabel,
                  style: TextStyle(fontSize: r.fs(0.035), fontWeight: FontWeight.w500),
                ),
                Text(
                  t.rate14,
                  style: TextStyle(fontSize: r.fs(0.035), color: Colors.grey),
                ),
              ],
            ),
          ],
          const Divider(),
          // Total cost with both old and new
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.totalCost, style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w600)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatPriceOld(period.electricityPrice)} ${t.oldSyp}',
                    style: TextStyle(fontSize: r.fs(0.035)),
                  ),
                  Text(
                    '${_formatPriceNew(period.electricityPrice)} ${t.newSyp}',
                    style: TextStyle(fontSize: r.fs(0.045), fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Text(
            t.allReadings,
            style: TextStyle(fontSize: r.fs(0.035), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: r.h(0.01)),
          if (reads.isEmpty)
            Padding(
              padding: r.all(0.02),
              child: Text(t.noReadingsYet, style: TextStyle(color: Colors.grey, fontSize: r.fs(0.03))),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reads.length,
              itemBuilder: (ctx, i) {
                final read = reads[i];
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.electric_bolt, size: r.w(0.04), color: Colors.amber),
                  title: Text('${_formatKwh(read.read)} ${t.kWh}', style: TextStyle(fontSize: r.fs(0.035))),
                  subtitle: Text(DateFormat('d/M/yyyy, h:mm a').format(read.readDateTime),
                      style: TextStyle(fontSize: r.fs(0.03))),
                );
              },
            ),
        ],
      ),
    );
  }
}