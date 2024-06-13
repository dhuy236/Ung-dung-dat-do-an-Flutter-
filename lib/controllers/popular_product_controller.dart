import 'package:flutter/material.dart';
import 'package:my_app/controllers/cart_controller.dart';
import 'package:my_app/data/repository/popular_product_repo.dart';
import 'package:get/get.dart';
import 'package:my_app/models/cart_model.dart';
import 'package:my_app/models/products_model.dart';
import 'package:http/http.dart' as http;

class PopularProductController extends GetxController{
  final PopularProductRepo popularProductRepo;
  PopularProductController({required this.popularProductRepo});
  List<ProductModel> _popularProductList=[];
  List<ProductModel> get popularProductList => _popularProductList;
  late CartController _cart;

  bool _isLoaded = false;
  bool get isLoaded=>_isLoaded;

  int _quantity=0;
  int get quantity=>_quantity;
  int _inCartItems=0;
  int get inCartItems=>_inCartItems+_quantity;

  Future<void> getPopularProductList()async{
   Response response = await popularProductRepo.getPopularProductList();
   if(response.statusCode==200){
    print("got products");
    _popularProductList=[];
    _popularProductList.addAll(Product.fromJson(response.body).Products);
    //print(_popularProductList);
    _isLoaded=true;
    update();
   }else{

   }
  }

  void setQuantity(bool isIncrement){
    if(isIncrement){
      
      _quantity=checkQuantity(_quantity+1);
    }else{
      _quantity=checkQuantity(_quantity-1);
    }
    update();
  }
  int checkQuantity(int quantity){
    if((_inCartItems+quantity)<0){
      Get.snackbar("Số Lượng Sản Phẩm", "Bạn không thể giảm xuống nữa!!!",
        backgroundColor: Color.fromARGB(255, 45, 229, 236),
        colorText: Colors.white,
      );
      if(_inCartItems>0){
        _quantity = -_inCartItems;
        return _quantity;
      }
      return 0;
    }else if((_inCartItems+quantity)>20){
      Get.snackbar("Số Lượng Sản Phẩm", "Bạn không thể tăng thêm nữa!!!",
        backgroundColor: Color.fromARGB(255, 70, 219, 224),
        colorText: Colors.white,
      );
      return 20;
    }else{
      return quantity;
    }
  }

  void initProduct(ProductModel product ,CartController cart){
    _quantity=0;
    _inCartItems=0;
    _cart=cart;
    var exist=false;
    exist = _cart.existInCart(product);
    print("exist of not"+exist.toString());
    if(exist){
      _inCartItems=_cart.getQuantity(product);
    }
    print("the quantity in the cart is"+_inCartItems.toString());
  }

  void addItem(ProductModel product ){
      _cart.addItem(product, _quantity);

      _quantity=0;
      _inCartItems=_cart.getQuantity(product);

      _cart.items.forEach((key, value) {
        print("The id is "+value.toString()+" The quantity is "+value.quantity.toString());
       });
    update();
  }

  int get totalItems{
    return _cart.totalItems;
  }
  List<CartModel> get GetItems{
    return _cart.getItems;
  }
}