import 'electricity_meter_read.dart';

class ElectricityPeriod {
  int? id;
  int meterId;
  int periodNumber;
  int periodYear;
  int periodMonths;
  List<ElectricityMeterRead> electricityMeterReads;
  double electricityPrice;
  bool paid;

  ElectricityPeriod({
    this.id,
    required this.meterId,
    required this.periodNumber,
    required this.periodYear,
    required this.periodMonths,
    List<ElectricityMeterRead>? electricityMeterReads,
    this.electricityPrice = 0.0,
    this.paid = false,
  }) : electricityMeterReads = electricityMeterReads ?? [];

  // ---- Existing methods ----

  int getPeriodNumber() => periodNumber;
  int getPeriodYear() => periodYear;
  int getPeriodMonths() => periodMonths;
  List<ElectricityMeterRead> getMeterReads() => electricityMeterReads;
  double getElectricityPrice() => electricityPrice;
  ElectricityMeterRead getMeterRead(int index) => electricityMeterReads[index];
  bool getPaid() => paid;

  void setMeterRead(double newRead, DateTime readDateTime) {
    electricityMeterReads.add(ElectricityMeterRead(newRead, readDateTime));
    sortReads();
  }

  void sortReads() {
    electricityMeterReads.sort((a, b) => a.read.compareTo(b.read));
  }

  // ✅ Updated: accepts meterType to apply correct pricing
  void calculateElectricityPrice({String meterType = 'household'}) {
    sortReads();
    if (electricityMeterReads.length < 2) {
      electricityPrice = 0.0;
      return;
    }
    double usedKiloWats = electricityMeterReads.last.read - electricityMeterReads.first.read;

    if (meterType == 'household') {
      // Tiered pricing: first 300 kWh at 6 SYP, rest at 14 SYP
      if (usedKiloWats <= 300) {
        electricityPrice = usedKiloWats * 6;
      } else {
        electricityPrice = 300 * 6 + (usedKiloWats - 300) * 14;
      }
    } else {
      // Industrial / Commercial: flat rate 14 SYP per kWh
      electricityPrice = usedKiloWats * 14;
    }
  }

  double getAverageElectricityUsage() {
    if (electricityMeterReads.isEmpty) return 0.0;
    double sum = 0;
    for (var read in electricityMeterReads) {
      sum += read.read;
    }
    return sum / electricityMeterReads.length;
  }
}