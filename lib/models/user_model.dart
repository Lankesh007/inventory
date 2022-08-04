class UserModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;

  UserModel({
    required this.email,
    required this.fullName,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        email: json['email']??"",
        fullName: json['full_name']??"",
        password: json['password']??"",
        phoneNumber: json['phone_number']??"",
      );
}
