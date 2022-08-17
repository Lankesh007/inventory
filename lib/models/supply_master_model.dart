class SupplyMasterModel {
  String supplyAddress = "";
  String supplierName = "";
  String mobileNumber = "";
  String emailId = "";
  String gstNumber = "";

  SupplyMasterModel({
    required this.supplyAddress,
    required this.supplierName,
    required this.mobileNumber,
    required this.emailId,
    required this.gstNumber,
  });

  Map<String, dynamic> toJson() => {
        'supplier_address': supplyAddress,
        'supplier_name': supplierName,
        'supplier_email': emailId,
        'phone_number': mobileNumber,
        'gst_number': gstNumber,
      };

  static SupplyMasterModel fromJson(Map<String, dynamic> json) =>
      SupplyMasterModel(
        supplyAddress: json['supplier_address'],
        supplierName: json['supplier_name'],
        emailId: json['supplier_email'],
        mobileNumber: json['phone_number'],
        gstNumber: json['gst_number'],
      );
}
