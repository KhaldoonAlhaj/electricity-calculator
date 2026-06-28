class ElectricityMeterRead {
  late double read;
  late DateTime readDateTime;

  ElectricityMeterRead(this.read, this.readDateTime);

  double getRead() => read;

  DateTime getReadDateTime() => readDateTime;
}