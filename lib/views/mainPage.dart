import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../database/db_helper.dart';
import '../models/electricity_period.dart';
import '../models/electricity_meter_read.dart';
import '../models/electricity_meter.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/add_new_meter_read_button.dart';
import '../widgets/add_read_dialog.dart';
import '../widgets/meter_read_item_tile.dart';
import '../widgets/edit_read_dialog.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';
import 'package:fl_chart/fl_chart.dart';

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

class MainPage extends StatefulWidget {
  final List<ElectricityPeriod>? initialPeriods;
  const MainPage({super.key, this.initialPeriods});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<ElectricityPeriod> _periods = [];
  ElectricityPeriod? _currentPeriod;
  ElectricityMeter? _currentMeter;
  bool _isLoading = true;

  String _formatPriceOld(double price) => NumberFormat('#,###').format(price * 100);
  String _formatPriceNew(double price) => NumberFormat('#,###').format(price);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final meter = await DatabaseHelper.instance.getDefaultMeter();
      if (!mounted) return;
      if (meter == null) {
        setState(() {
          _periods = [];
          _currentPeriod = null;
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
        _currentPeriod = periods.isNotEmpty ? periods.first : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      print('Error loading data: $e');
    }
  }

  double _getTotalConsumption() {
    if (_currentPeriod == null || _currentPeriod!.electricityMeterReads.length < 2) return 0;
    return _currentPeriod!.electricityMeterReads.last.read - _currentPeriod!.electricityMeterReads.first.read;
  }

  double _getRemainingFirstTier() {
    if (_currentMeter?.type != 'household') return 0;
    final used = _getTotalConsumption();
    return used > 300 ? 0 : 300 - used;
  }

  Map<String, double> _getTierCosts() {
    final used = _getTotalConsumption();
    if (_currentMeter?.type != 'household') {
      return {
        'firstKwh': 0.0,
        'firstCost': 0.0,
        'secondKwh': used,
        'secondCost': used * 14,
        'totalCost': used * 14,
      };
    }
    final first = used > 300 ? 300.0 : used;
    final second = used > 300 ? used - 300 : 0.0;
    return {
      'firstKwh': first,
      'firstCost': first * 6,
      'secondKwh': second,
      'secondCost': second * 14,
      'totalCost': (first * 6) + (second * 14),
    };
  }

  List<ElectricityMeterRead> _getRecentReads({int limit = 5}) {
    if (_currentPeriod == null) return [];
    final reads = List<ElectricityMeterRead>.from(_currentPeriod!.electricityMeterReads);
    reads.sort((a, b) => b.readDateTime.compareTo(a.readDateTime));
    return reads.take(limit).toList();
  }

  double _getAverageDailyUsage() {
    if (_currentPeriod == null || _currentPeriod!.electricityMeterReads.length < 2) return 0;
    final reads = List<ElectricityMeterRead>.from(_currentPeriod!.electricityMeterReads);
    reads.sort((a, b) => a.readDateTime.compareTo(b.readDateTime));
    final totalKwh = reads.last.read - reads.first.read;
    final days = reads.last.readDateTime.difference(reads.first.readDateTime).inDays;
    return days > 0 ? totalKwh / days : 0;
  }

  // ---------- CRUD operations ----------
  Future<void> _addReading() async {
    if (!mounted) return;
    if (_currentMeter == null) {
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.noMeterFound)),
      );
      return;
    }
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AddReadDialog(meterId: _currentMeter!.id!),
    );
    if (result == null) return;

    final kiloWatts = result['kiloWatts'] as double;
    final selectedYear = result['year'] as int;
    final selectedPeriodNumber = result['period'] as int;
    final now = result['dateTime'] as DateTime? ?? DateTime.now();

    final existingPeriodId = await DatabaseHelper.instance.getPeriodId(
      selectedPeriodNumber,
      selectedYear,
      _currentMeter!.id!,
    );
    if (!mounted) return;

    if (existingPeriodId != null) {
      final newRead = ElectricityMeterRead(kiloWatts, now);
      await DatabaseHelper.instance.addMeterRead(existingPeriodId, newRead);
      final allPeriods = await DatabaseHelper.instance.getPeriodsForMeter(_currentMeter!.id!);
      if (!mounted) return;
      final existingPeriod = allPeriods.firstWhere(
            (p) => p.periodNumber == selectedPeriodNumber && p.periodYear == selectedYear,
      );
      existingPeriod.electricityMeterReads.add(newRead);
      existingPeriod.sortReads();
      existingPeriod.calculateElectricityPrice(meterType: _currentMeter!.type);
      await DatabaseHelper.instance.updatePeriod(existingPeriod, existingPeriodId);
    } else {
      final newPeriod = ElectricityPeriod(
        meterId: _currentMeter!.id!,
        periodNumber: selectedPeriodNumber,
        periodYear: selectedYear,
        periodMonths: 2,
      );
      newPeriod.setMeterRead(kiloWatts, now);
      newPeriod.calculateElectricityPrice(meterType: _currentMeter!.type);
      await DatabaseHelper.instance.insertPeriod(newPeriod);
    }

    await _loadData();
    if (mounted) {
      final t = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.readingSaved)),
      );
    }
  }

  Future<void> _editReading(ElectricityMeterRead oldRead, int indexInFullList) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => EditReadDialog(
        currentValue: oldRead.read,
        currentDateTime: oldRead.readDateTime,
      ),
    );
    if (result != null) {
      final newValue = result['value'] as double;
      final newDateTime = result['dateTime'] as DateTime;

      final updatedRead = ElectricityMeterRead(newValue, newDateTime);
      if (!mounted) return;
      _currentPeriod!.electricityMeterReads[indexInFullList] = updatedRead;
      _currentPeriod!.sortReads();
      _currentPeriod!.calculateElectricityPrice(meterType: _currentMeter!.type);

      final periodId = _currentPeriod!.id!;
      await DatabaseHelper.instance.deleteAllMeterReadsForPeriod(periodId);
      for (var r in _currentPeriod!.electricityMeterReads) {
        await DatabaseHelper.instance.addMeterRead(periodId, r);
      }
      await DatabaseHelper.instance.updatePeriod(_currentPeriod!, periodId);
      await _loadData();
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.readingUpdated)),
        );
      }
    }
  }

  Future<void> _deleteReading(int indexInFullList) async {
    final confirmed = await showDeleteConfirmationDialog(context);
    if (confirmed == true) {
      if (!mounted) return;
      _currentPeriod!.electricityMeterReads.removeAt(indexInFullList);
      _currentPeriod!.sortReads();
      _currentPeriod!.calculateElectricityPrice(meterType: _currentMeter!.type);

      final periodId = _currentPeriod!.id!;
      await DatabaseHelper.instance.deleteAllMeterReadsForPeriod(periodId);
      for (var r in _currentPeriod!.electricityMeterReads) {
        await DatabaseHelper.instance.addMeterRead(periodId, r);
      }
      await DatabaseHelper.instance.updatePeriod(_currentPeriod!, periodId);
      await _loadData();
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.readingDeleted)),
        );
      }
    }
  }

  double _getPeriodConsumption(ElectricityPeriod period) {
    if (period.electricityMeterReads.length < 2) return 0;
    final sortedReads = List.from(period.electricityMeterReads)
      ..sort((a, b) => a.read.compareTo(b.read));
    return sortedReads.last.read - sortedReads.first.read;
  }

  Widget _buildChart(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final periods = _periods.take(6).toList().reversed.toList();
    if (periods.length < 2) {
      return Center(
        child: Text(
          t.addAtLeastTwoPeriods,
          style: TextStyle(color: Colors.grey, fontSize: context.fs(0.035)),
        ),
      );
    }

    final consumptionValues = periods.map((p) => _getPeriodConsumption(p)).toList();
    final maxConsumption = consumptionValues.reduce((a, b) => a > b ? a : b);
    final rawMax = maxConsumption;
    final maxY = (rawMax / 500).ceilToDouble() * 500;

    return SizedBox(
      height: context.h(0.18),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= periods.length) return const Text('');
                  final p = periods[index];
                  return Text(
                    '${p.periodNumber}/${p.periodYear.toString().substring(2)}',
                    style: const TextStyle(fontSize: 9),
                  );
                },
              ),
            ),
            leftTitles: isRtl
                ? const AxisTitles(sideTitles: SideTitles(showTitles: false))
                : AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${NumberFormat('#,###').format(value)} ${t.kWh}',
                    style: const TextStyle(fontSize: 8),
                  );
                },
              ),
            ),
            rightTitles: isRtl
                ? AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${NumberFormat('#,###').format(value)} ${t.kWh}',
                    style: const TextStyle(fontSize: 8),
                  );
                },
              ),
            )
                : const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: periods.asMap().entries.map((entry) {
            final index = entry.key;
            final period = entry.value;
            final consumption = _getPeriodConsumption(period);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: consumption,
                  color: Colors.green.shade700,
                  width: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    final r = context;
    final isHousehold = _currentMeter?.type == 'household';

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.grey[100],
      floatingActionButton: AddNewMeterReadButton(onPressed: _addReading),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: r.h(0.23),
              pinned: true,
              backgroundColor: Colors.green.shade800,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.green.shade900, Colors.green.shade600],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: r.symH(0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                _currentMeter!.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: r.fs(0.055),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: r.sym(0.02, 0.01),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(r.w(0.03)),
                                ),
                                child: Text(
                                  switch (_currentMeter!.type) {
                                    "household" => t.household.toUpperCase(),
                                    "commercial" => t.commercial.toUpperCase(),
                                    "industrial" => t.industrial.toUpperCase(),
                                    _ => _currentMeter!.type.toUpperCase(), // fallback
                                  },
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: r.fs(0.035),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: r.h(0.005)),
                          Text(
                            t.currentPeriod.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: r.fs(0.03),
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: r.h(0.005)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentPeriod != null
                                          ? '${t.period} ${_currentPeriod!.periodNumber}'
                                          : '—',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: r.fs(0.07),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _currentPeriod != null
                                          ? '${_currentPeriod!.periodYear}'
                                          : t.noPeriod,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: r.fs(0.04),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: r.w(0.04)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.bolt, color: Colors.white, size: r.w(0.045)),
                                      SizedBox(width: r.w(0.015)),
                                      Text(
                                        _currentPeriod != null
                                            ? '${_getTotalConsumption().toStringAsFixed(1)} ${t.kWh}'
                                            : '0 ${t.kWh}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: r.fs(0.045),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: r.h(0.01)),
                                  Row(
                                    children: [
                                      Icon(Icons.trending_up, color: Colors.white70, size: r.w(0.035)),
                                      SizedBox(width: r.w(0.015)),
                                      Text(
                                        '${t.avg} ${_getAverageDailyUsage().toStringAsFixed(1)} ${t.perDay}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: r.fs(0.03),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh, size: r.w(0.06)),
                  onPressed: _loadData,
                  tooltip: t.refresh,
                ),
              ],
            ),
            SliverPadding(
              padding: r.all(0.04),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.06))),
                    child: Padding(
                      padding: r.all(0.05),
                      child: isHousehold
                          ? Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: r.w(0.25),
                                width: r.w(0.25),
                                child: CircularProgressIndicator(
                                  value: (_getTotalConsumption() / 300).clamp(0.0, 1.0),
                                  strokeWidth: r.w(0.025),
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getTotalConsumption() > 300 ? Colors.red : Colors.green,
                                  ),
                                ),
                              ),
                              Text(
                                _getTotalConsumption().toStringAsFixed(1),
                                style: TextStyle(fontSize: r.fs(0.05), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: r.w(0.05)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.remainingBeforeTier2, style: TextStyle(color: Colors.grey, fontSize: r.fs(0.035))),
                                SizedBox(height: r.h(0.01)),
                                Text(
                                  '${_getRemainingFirstTier().toStringAsFixed(1)} ${t.kWh}',
                                  style: TextStyle(fontSize: r.fs(0.06), fontWeight: FontWeight.bold),
                                ),
                                if (_getRemainingFirstTier() <= 0)
                                  Text(t.youExceeded300, style: TextStyle(color: Colors.red, fontSize: r.fs(0.03))),
                              ],
                            ),
                          ),
                        ],
                      )
                          : Padding(
                        padding: r.all(0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.consumption,
                              style: TextStyle(fontSize: r.fs(0.04), color: Colors.grey),
                            ),
                            Text(
                              '${_getTotalConsumption().toStringAsFixed(1)} ${t.kWh}',
                              style: TextStyle(fontSize: r.fs(0.05), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: r.h(0.015)),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.06))),
                    child: Padding(
                      padding: r.all(0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.costBreakdown, style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w600)),
                          SizedBox(height: r.h(0.015)),
                          if (isHousehold)
                            Row(
                              children: [
                                _costItem(
                                  t.tier1,
                                  t.tier1Range,
                                  t.rate6,
                                  _getTierCosts()['firstKwh']!,
                                  _getTierCosts()['firstCost']!,
                                  _getTierCosts()['firstCost']!,
                                ),
                                const VerticalDivider(),
                                _costItem(
                                  t.tier2,
                                  t.tier2Range,
                                  t.rate14,
                                  _getTierCosts()['secondKwh']!,
                                  _getTierCosts()['secondCost']!,
                                  _getTierCosts()['secondCost']!,
                                ),
                              ],
                            )
                          else
                            Padding(
                              padding: r.symV(0.02),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${t.used}:',
                                        style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${_getTotalConsumption().toStringAsFixed(1)} ${t.kWh}',
                                        style: TextStyle(
                                          fontSize: r.fs(0.04),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        t.rateLabel,
                                        style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        t.rate14,
                                        style: TextStyle(
                                          fontSize: r.fs(0.04),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(t.totalCost, style: TextStyle(fontSize: r.fs(0.04))),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${_formatPriceOld(_currentPeriod?.electricityPrice ?? 0)} ${t.oldSyp}',
                                    style: TextStyle(fontSize: r.fs(0.04)),
                                  ),
                                  Text(
                                    '${_formatPriceNew(_currentPeriod?.electricityPrice ?? 0)} ${t.newSyp}',
                                    style: TextStyle(fontSize: r.fs(0.05), fontWeight: FontWeight.bold, color: Colors.green),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: r.h(0.015)),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.06))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: r.all(0.04),
                          child: Text(t.recentReadings, style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w600)),
                        ),
                        if (_getRecentReads().isEmpty)
                          Padding(
                            padding: r.all(0.08),
                            child: Center(child: Text(t.noReadingsYet, style: TextStyle(fontSize: r.fs(0.035)))),
                          )
                        else
                          ..._getRecentReads().map((read) {
                            final fullIndex = _currentPeriod!.electricityMeterReads.indexOf(read);
                            return MeterReadItemTile(
                              title: '${read.read.toStringAsFixed(1)} ${t.kWh}',
                              subtitle: DateFormat('d/M/yyyy, h:mm a').format(read.readDateTime),
                              onEdit: () => _editReading(read, fullIndex),
                              onDelete: () => _deleteReading(fullIndex),
                            );
                          }),
                      ],
                    ),
                  ),
                  SizedBox(height: r.h(0.015)),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.w(0.06))),
                    child: Padding(
                      padding: r.all(0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.consumptionChart,
                            style: TextStyle(fontSize: r.fs(0.04), fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: r.h(0.02)),
                          SizedBox(
                            height: r.h(0.25),
                            child: _buildChart(context),
                          ),
                        ],
                      ),
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

  Widget _costItem(String title, String range, String rate, double kwh, double costOld, double costNew) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    return Expanded(
      child: Column(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs(0.035))),
          Text(range, style: TextStyle(fontSize: r.fs(0.03), color: Colors.grey)),
          Text(rate, style: TextStyle(fontSize: r.fs(0.03), color: Colors.grey)),
          SizedBox(height: r.h(0.01)),
          Text('${kwh.toStringAsFixed(1)} ${t.kWh}', style: TextStyle(fontSize: r.fs(0.035))),
          Text('${_formatPriceNew(costNew)} ${t.newSyp}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs(0.035))),
          Text('${_formatPriceOld(costOld)} ${t.oldSyp}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: r.fs(0.035), color: Colors.black54)),
        ],
      ),
    );
  }
}