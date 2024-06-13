// import 'package:my_app/models/products_model.dart';

// class PaymentMethodModel {
//   String? method;

// PaymentMethodModel(
//   {this.method,
//   });

//   PaymentMethodModel.fromJson (Map<String, dynamic> json) {
//   id = json['id'];
//   name = json['name'];
//   price = json['price'];
//   img = json['img'];
//   quantity = json['quantity'];
//   isExist = json['isExist'];
//   time = json['time'];
//   product = ProductModel.fromJson(json['product']);
//   }

//   Map<String, dynamic> toJson(){
//     return{
//       "id":this.id,
//       "name":this.name,
//       "price":this.price,
//       "img":this.img,
//       "quantity":this.quantity,
//       "isExist":this.isExist,
//       "time":this.time,
//       "product":this.product!.toJson()
//     };
//   }

//   }