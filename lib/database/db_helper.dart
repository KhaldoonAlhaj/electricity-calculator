import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/electricity_period.dart';
import '../models/electricity_meter_read.dart';
import '../models/electricity_meter.dart'; // new model

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('electricity.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 2, // increment version
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  // --- Fresh install: create all tables ---
  Future<void> _createTables(Database db, int version) async {
    // Electricity Meters table
    await db.execute('''
      CREATE TABLE meters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        is_default INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Periods table (now with meter_id)
    await db.execute('''
      CREATE TABLE periods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meter_id INTEGER NOT NULL,
        periodNumber INTEGER NOT NULL,
        periodYear INTEGER NOT NULL,
        periodMonths INTEGER NOT NULL,
        paid INTEGER NOT NULL DEFAULT 0,
        electricityPrice REAL NOT NULL DEFAULT 0,
        FOREIGN KEY (meter_id) REFERENCES meters (id) ON DELETE CASCADE
      )
    ''');

    // Electricity Meter reads (unchanged)
    await db.execute('''
      CREATE TABLE meter_reads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        periodId INTEGER NOT NULL,
        readValue REAL NOT NULL,
        readDateTime TEXT NOT NULL,
        FOREIGN KEY (periodId) REFERENCES periods (id) ON DELETE CASCADE
      )
    ''');
  }

  // --- Migration from version 1 to 2 (for existing users) ---
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 1. Create meters table
      await db.execute('''
        CREATE TABLE meters (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          type TEXT NOT NULL,
          is_default INTEGER NOT NULL DEFAULT 0
        )
      ''');

      // 2. Add meter_id column to periods
      await db.execute('ALTER TABLE periods ADD COLUMN meter_id INTEGER REFERENCES meters(id) ON DELETE CASCADE');

      // 3. Insert a default meter
      final meterId = await db.insert('meters', {
        'name': 'Default Meter',
        'type': 'household',
        'is_default': 1,
      });

      // 4. Assign all existing periods to this default meter
      await db.update('periods', {'meter_id': meterId}, where: '1=1');
    }
  }

  // ==================== METER CRUD ====================
  Future<int> insertMeter(ElectricityMeter meter) async {
    final db = await database;
    return await db.insert('meters', meter.toMap());
  }

  Future<List<ElectricityMeter>> getAllMeters() async {
    final db = await database;
    final maps = await db.query('meters', orderBy: 'name ASC');
    return maps.map((map) => ElectricityMeter.fromMap(map)).toList();
  }

  Future<ElectricityMeter?> getDefaultMeter() async {
    final db = await database;
    final maps = await db.query('meters', where: 'is_default = 1', limit: 1);
    if (maps.isEmpty) return null;
    return ElectricityMeter.fromMap(maps.first);
  }

  Future<ElectricityMeter?> getMeterById(int id) async {
    final db = await database;
    final maps = await db.query('meters', where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return ElectricityMeter.fromMap(maps.first);
  }

  Future<int> updateMeter(ElectricityMeter meter) async {
    final db = await database;
    return await db.update(
      'meters',
      meter.toMap(),
      where: 'id = ?',
      whereArgs: [meter.id],
    );
  }

  Future<int> deleteMeter(int id) async {
    final db = await database;
    // Prevent deletion of the default meter
    final maps = await db.query('meters', where: 'id = ? AND is_default = 1', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return -1; // error: cannot delete default meter
    }
    return await db.delete('meters', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> setDefaultMeter(int meterId) async {
    final db = await database;
    await db.update('meters', {'is_default': 0});
    await db.update('meters', {'is_default': 1}, where: 'id = ?', whereArgs: [meterId]);
  }

  // ==================== PERIOD CRUD (now with meter_id) ====================

  Future<int> insertPeriod(ElectricityPeriod period) async {
    final db = await database;
    final id = await db.insert('periods', {
      'meter_id': period.meterId,
      'periodNumber': period.periodNumber,
      'periodYear': period.periodYear,
      'periodMonths': period.periodMonths,
      'paid': period.paid ? 1 : 0,
      'electricityPrice': period.electricityPrice,
    });
    for (var read in period.electricityMeterReads) {
      await db.insert('meter_reads', {
        'periodId': id,
        'readValue': read.read,
        'readDateTime': read.readDateTime.toIso8601String(),
      });
    }
    return id;
  }

  // Get periods for a specific meter
  Future<List<ElectricityPeriod>> getPeriodsForMeter(int meterID) async {
    final db = await database;
    final periodsMaps = await db.query(
      'periods',
      where: 'meter_id = ?',
      whereArgs: [meterID],
      orderBy: 'periodYear DESC, periodNumber DESC',
    );

    List<ElectricityPeriod> periods = [];
    for (var pMap in periodsMaps) {
      final period = ElectricityPeriod(
        periodNumber: pMap['periodNumber'] as int,
        periodYear: pMap['periodYear'] as int,
        periodMonths: pMap['periodMonths'] as int,
        meterId: pMap['meter_id'] as int,
        id: pMap['id'] as int?,
      );
      period.paid = (pMap['paid'] as int) == 1;
      period.electricityPrice = pMap['electricityPrice'] as double;

      final readsMaps = await db.query(
        'meter_reads',
        where: 'periodId = ?',
        whereArgs: [pMap['id']],
        orderBy: 'readValue ASC',
      );
      period.electricityMeterReads = readsMaps.map((rMap) {
        return ElectricityMeterRead(
          rMap['readValue'] as double,
          DateTime.parse(rMap['readDateTime'] as String),
        );
      }).toList();
      periods.add(period);
    }
    return periods;
  }

  // Get a single period by its ID (useful for editing)
  Future<ElectricityPeriod?> getPeriodById(int periodId) async {
    final db = await database;
    final maps = await db.query('periods', where: 'id = ?', whereArgs: [periodId], limit: 1);
    if (maps.isEmpty) return null;
    final pMap = maps.first;
    final period = ElectricityPeriod(
      periodNumber: pMap['periodNumber'] as int,
      periodYear: pMap['periodYear'] as int,
      periodMonths: pMap['periodMonths'] as int,
      meterId: pMap['meter_id'] as int,
      id: pMap['id'] as int?,
    );
    period.paid = (pMap['paid'] as int) == 1;
    period.electricityPrice = pMap['electricityPrice'] as double;

    final readsMaps = await db.query(
      'meter_reads',
      where: 'periodId = ?',
      whereArgs: [periodId],
      orderBy: 'readValue ASC',
    );
    period.electricityMeterReads = readsMaps.map((rMap) {
      return ElectricityMeterRead(
        rMap['readValue'] as double,
        DateTime.parse(rMap['readDateTime'] as String),
      );
    }).toList();
    return period;
  }

  // Get period ID by period number, year, and meterId
  Future<int?> getPeriodId(int periodNumber, int periodYear, int meterId) async {
    final db = await database;
    final result = await db.query(
      'periods',
      where: 'periodNumber = ? AND periodYear = ? AND meter_id = ?',
      whereArgs: [periodNumber, periodYear, meterId],
    );
    if (result.isNotEmpty) return result.first['id'] as int;
    return null;
  }

  // Update a period (replaces its data)
  Future<int> updatePeriod(ElectricityPeriod period, int periodId) async {
    final db = await database;
    return await db.update(
      'periods',
      {
        'meter_id': period.meterId,
        'periodNumber': period.periodNumber,
        'periodYear': period.periodYear,
        'periodMonths': period.periodMonths,
        'paid': period.paid ? 1 : 0,
        'electricityPrice': period.electricityPrice,
      },
      where: 'id = ?',
      whereArgs: [periodId],
    );
  }

  // Delete a period (cascade removes its reads)
  Future<int> deletePeriod(int periodId) async {
    final db = await database;
    return await db.delete('periods', where: 'id = ?', whereArgs: [periodId]);
  }

  // ==================== METER READ CRUD ====================

  Future<void> addMeterRead(int periodId, ElectricityMeterRead read) async {
    final db = await database;
    await db.insert('meter_reads', {
      'periodId': periodId,
      'readValue': read.read,
      'readDateTime': read.readDateTime.toIso8601String(),
    });
  }

  Future<int> updateMeterRead(int readId, double newReadValue, DateTime newDateTime) async {
    final db = await database;
    return await db.update(
      'meter_reads',
      {
        'readValue': newReadValue,
        'readDateTime': newDateTime.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [readId],
    );
  }

  Future<int> deleteMeterRead(int readId) async {
    final db = await database;
    return await db.delete('meter_reads', where: 'id = ?', whereArgs: [readId]);
  }

  Future<void> deleteAllMeterReadsForPeriod(int periodId) async {
    final db = await database;
    await db.delete('meter_reads', where: 'periodId = ?', whereArgs: [periodId]);
  }

  // ==================== LEGACY / BACKWARD COMPATIBILITY ====================
  // This method returns ALL periods from ALL meters. Use only when you really need it.
  Future<List<ElectricityPeriod>> getAllPeriods() async {
    final db = await database;
    final periodsMaps = await db.query('periods', orderBy: 'periodYear DESC, periodNumber DESC');
    List<ElectricityPeriod> periods = [];
    for (var pMap in periodsMaps) {
      final period = ElectricityPeriod(
        periodNumber: pMap['periodNumber'] as int,
        periodYear: pMap['periodYear'] as int,
        periodMonths: pMap['periodMonths'] as int,
        meterId: pMap['meter_id'] as int,
        id: pMap['id'] as int?,
      );
      period.paid = (pMap['paid'] as int) == 1;
      period.electricityPrice = pMap['electricityPrice'] as double;
      final readsMaps = await db.query(
        'meter_reads',
        where: 'periodId = ?',
        whereArgs: [pMap['id']],
        orderBy: 'readValue ASC',
      );
      period.electricityMeterReads = readsMaps.map((rMap) {
        return ElectricityMeterRead(
          rMap['readValue'] as double,
          DateTime.parse(rMap['readDateTime'] as String),
        );
      }).toList();
      periods.add(period);
    }
    return periods;
  }
}