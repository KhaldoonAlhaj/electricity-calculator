import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/electricity_meter.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';
import 'create_electricity_meter_page.dart';
import 'mainPage.dart';

class ElectricityMeterListPage extends StatefulWidget {
  const ElectricityMeterListPage({super.key});

  @override
  State<ElectricityMeterListPage> createState() => _ElectricityMeterListPageState();
}

class _ElectricityMeterListPageState extends State<ElectricityMeterListPage> {
  List<ElectricityMeter> _meters = [];
  bool _loading = true; // renamed to break cache

  @override
  void initState() {
    super.initState();
    _loadMeters();
  }

  Future<void> _loadMeters() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final meters = await DatabaseHelper.instance.getAllMeters();
    if (!mounted) return;
    setState(() {
      _meters = meters;
      _loading = false;
    });
  }

  Future<void> _setDefaultAndNavigate(int meterId) async {
    await DatabaseHelper.instance.setDefaultMeter(meterId);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }

  Future<void> _deleteMeter(ElectricityMeter meter) async {
    final t = AppLocalizations.of(context)!;
    if (meter.isDefault) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.cannotDeleteDefault)),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.deleteMeterTitle),
        content: Text(t.deleteMeterContent(meter.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              t.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final result = await DatabaseHelper.instance.deleteMeter(meter.id!);
      if (result == -1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.cannotDeleteDefault)),
        );
        return;
      }
      await _loadMeters();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.meterDeleted)),
        );
      }
    }
  }

  Future<void> _renameMeter(ElectricityMeter meter) async {
    final controller = TextEditingController(text: meter.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Rename Meter'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'New name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newName != null && newName.isNotEmpty) {
      meter.name = newName;
      await DatabaseHelper.instance.updateMeter(meter);
      await _loadMeters();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meter renamed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final r = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.metersTitle),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateElectricityMeterPage(isFirst: false)),
              ).then((_) => _loadMeters());
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _meters.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.device_unknown, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(t.noMetersYet),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateElectricityMeterPage(isFirst: false)),
                ).then((_) => _loadMeters());
              },
              child: Text(t.addFirstMeter),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: r.all(0.03),
        itemCount: _meters.length,
        itemBuilder: (ctx, index) {
          final meter = _meters[index];
          return Card(
            margin: EdgeInsets.only(bottom: r.h(0.02)),
            child: ListTile(
              title: Text(meter.name),
              subtitle: Text(switch (meter.type) {
                "household" => t.household.toUpperCase(),
                "commercial" => t.commercial.toUpperCase(),
                "industrial" => t.industrial.toUpperCase(),
                _ => meter.type.toUpperCase(), // fallback
              },),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'rename') {
                    _renameMeter(meter);
                  } else if (value == 'delete') {
                    _deleteMeter(meter);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'rename', child: Row(
                    children: [Icon(Icons.edit, color: Colors.blue), SizedBox(width: 8), Text('Rename')],
                  )),
                  const PopupMenuItem(value: 'delete', child: Row(
                    children: [Icon(Icons.delete, color: Colors.red), SizedBox(width: 8), Text('Delete')],
                  )),
                ],
              ),
              onTap: () => _setDefaultAndNavigate(meter.id!),
            ),
          );
        },
      ),
    );
  }
}