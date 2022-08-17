class TaxMasterModel {
  String taxName = '';
  String taxPercentage = "";

  TaxMasterModel({
    required this.taxName,
    required this.taxPercentage,
  });

  Map<String, dynamic> toJson() => {
        'taxName': taxName,
        'taxPercentage': taxPercentage,
      };

  static TaxMasterModel fromJson(Map<String, dynamic> json) => TaxMasterModel(
        taxName: json['taxName'],
        taxPercentage: json['taxPercentage'],
      );
}
