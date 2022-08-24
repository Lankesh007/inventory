class SaleMasterModel {
  String customer = "";
  String discount = "";
  String selectedItem = "";
  String price = "";
  String quantity = '';
  String totalAmount = '';

  SaleMasterModel({
    required this.customer,
    required this.discount,
    required this.selectedItem,
    required this.price,
    required this.quantity,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() => {
        'selected_customer': customer,
        'discount': discount,
        'selected_item': selectedItem,
        'price': price,
        'quantity': quantity,
        'total_amount': totalAmount,
      };

  static SaleMasterModel fromJson(Map<String, dynamic> json) => SaleMasterModel(
        customer: json['selected_customer'] ?? "",
        discount: json['discount'] ?? "",
        selectedItem: json['selected_item'] ?? "",
        price: json['price'] ?? "",
        quantity: json['quantity'] ?? "",
        totalAmount: json['total_amount'] ?? "",
      );
}
