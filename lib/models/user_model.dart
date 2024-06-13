class UserModel{
  int id;
  String name;
  String email;
  String phone;
  int orderCount;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.orderCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      id:json['id'] ??0, 
      name:json ['f_name']??0, 
      email:json ['email']??0, 
      phone:json ['phone']??0, 
      orderCount:json ['ordercount']??0
      );
  }
}