class CategoryMasterModel {
  String categoryDescription = "";
  String categoryImage = "";
  String categoryName = "";
  CategoryMasterModel({
    required this.categoryDescription,
    required this.categoryImage,
    required this.categoryName,
  });

  Map<String, dynamic> toJson() => {
        'category_description': categoryDescription,
        'category_name': categoryName,
        'category_image': categoryImage,
      };

  static CategoryMasterModel fromJson(Map<String, dynamic> json) =>
      CategoryMasterModel(
        categoryName: json['category_name'] ?? "",
        categoryDescription: json['category_description'] ?? "",
        categoryImage: json['category_image'] ?? "",
      );
}
