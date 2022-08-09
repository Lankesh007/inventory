class ItemMasterModel {
  final String itemName;
  final String companyName;
  final String imageLink;
  final String unitName;

  ItemMasterModel({
    required this.companyName,
    required this.itemName,
    required this.unitName,
    required this.imageLink,
  });

  Map<String, dynamic> toJson() => {
        'item_name': itemName,
        'company_name': companyName,
        'image_link': imageLink,
        'unit_name': unitName,
      };

  static ItemMasterModel fromJson(Map<String, dynamic> json) => ItemMasterModel(
        companyName: json['company_name']??"",
        itemName: json['item_name']??"",
        unitName: json['unit_name']??"",
        imageLink: json['image_link']??"",
      );
}
