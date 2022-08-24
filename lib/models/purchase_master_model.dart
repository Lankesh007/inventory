class PurchaseMasterModel {
  String barCode = "";
  String discount = "";
  String itemName = "";
  String expiryDate = "";
  String price = "";
  String quantity='';
  String supplierName='';
  String tax="";
  String taxablePrice="";
  String totalAmount='';

  PurchaseMasterModel({
    required this.barCode,
    required this.discount,
    required this.itemName,
    required this.expiryDate,
    required this.price,
    required this.quantity,
    required this.supplierName,
    required this.tax,
    required this.taxablePrice,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() => {
        'barcode': barCode,
        'discount': discount,
        'expiry_date': expiryDate,
        'itemName': itemName,
        'price': price,
        'quantity':quantity,
        'supplierName':supplierName,
        'tax':tax,
        'taxable_price':taxablePrice,
        'total_amount':totalAmount,
      };

  static PurchaseMasterModel fromJson(Map<String, dynamic> json) =>
      PurchaseMasterModel(
        barCode: json['barcode']??"",
        discount: json['discount']??"",
        expiryDate: json['expiry_date']??"",
        itemName: json['itemName']??"",
        price: json['price']??"",
        quantity: json['quantity']??"",
        supplierName: json['supplierName']??"",
        tax: json['tax']??"",
        totalAmount: json['total_amount']??"",
        taxablePrice: json['taxable_amount']??"",

      );
}
