class CustomerMasterModel {
  String address = "";
  String customerName = "";
  String email = "";
  String gst = '';
  String mobileNumber = "";

  CustomerMasterModel({
    required this.address,
    required this.customerName,
    required this.email,
    required this.gst,
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() => {
        'address': address,
        'customer_name': customerName,
        'email': email,
        'gst': gst,
        'mobile_number': mobileNumber,
      };

  static CustomerMasterModel fromJson(Map<String, dynamic> json) =>
      CustomerMasterModel(
        customerName: json['customer_name'] ?? "",
        address: json['address'] ?? "",
        email: json['email']??"",
        gst: json['gst']??"",
        mobileNumber: json['mobile_number']??"",
      );
}
