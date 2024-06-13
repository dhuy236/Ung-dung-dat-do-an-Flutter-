// class OrderModel {
//   int id;
//   double order_amount;
//   String order_type;
//   String contact_person_name;
//   String contact_person_number;
//   String address;
//   double longitude;
//   double latitude;
//   String order_note;
//   List cart;

//   OrderModel({
//     required this.id,
//     required this.order_amount,
//     required this.order_type,
//     required this.contact_person_name,
//     required this.contact_person_number,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.order_note,
//     required this.cart,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       id: json['id'] ?? 0,
//       order_amount: json['order_amount'] ?? 0.0,
//       order_type: json['order_type'] ?? "",
//       contact_person_name: json['contact_person_name'] ?? "",
//       contact_person_number: json['contact_person_number'] ?? "",
//       address: json['address'] ?? "",
//       latitude: json['latitude'] ?? 0.0,
//       longitude: json['longitude'] ?? 0.0,
//       order_note: json['order_note'] ?? "",
//       cart: json['cart'] ?? [],
//     );
//   }
// }
