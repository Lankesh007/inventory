class UnitMaster {
  String unit = '';
  bool action = false;

  UnitMaster({
    required this.unit,
    required this.action,
  });

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'action': action,
      };

  static UnitMaster fromJson(Map<String, dynamic> json) => UnitMaster(
        unit: json['unit'],
        action: json['action'],
      );
}
