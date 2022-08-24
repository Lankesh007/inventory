class ItemMasterModel {
  final String itemName;
  final String categoryName;
  final String imageLink;
  final String unitName;
  final String itemTax;

  ItemMasterModel({
    required this.categoryName,
    required this.itemName,
    required this.unitName,
    required this.imageLink,
    required this.itemTax,
  });

  Map<String, dynamic> toJson() => {
        'item_name': itemName,
        'category_name': categoryName,
        'image_link': imageLink,
        'unit_name': unitName,
        'item_tax': itemTax
      };

  static ItemMasterModel fromJson(Map<String, dynamic> json) => ItemMasterModel(
        categoryName: json['category_name'] ?? "",
        itemName: json['item_name'] ?? "",
        unitName: json['unit_name'] ?? "",
        imageLink: json['image_link'] ?? "",
        itemTax: json['item_tax'] ?? "",
      );
}
