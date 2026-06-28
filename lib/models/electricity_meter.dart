class ElectricityMeter {
  int? id;
  String name;
  String type; // 'household', 'industrial', 'commercial'
  bool isDefault;

  ElectricityMeter({
    this.id,
    required this.name,
    required this.type,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory ElectricityMeter.fromMap(Map<String, dynamic> map) {
    return ElectricityMeter(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
      isDefault: (map['is_default'] as int) == 1,
    );
  }
}