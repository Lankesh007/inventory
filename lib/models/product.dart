class Product {
  late final String id;

  // late final String _id;
  // String get id => _id;
  // set id(String value) {
  //   _id = value;
  // }
  final String categoryName;
  final String imageLink;
  final String itemName;
  final String itemTax;
  final String unitName;

  Product({
    required this.categoryName,
    required this.imageLink,
    required this.itemName,
    required this.itemTax,
    required this.unitName,
  });

  factory Product.fromJson(Map<String, dynamic> jsonObject) {
    return Product(
      categoryName: jsonObject['category_name'] as String,
      imageLink: jsonObject['image_link'] as String,
      itemName: jsonObject['item_name'] as String,
      itemTax: jsonObject['item_tax'] as String,
      unitName: jsonObject['unit_name'] as String,


    );
  }
}