import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/base/no_data_page.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/controllers/cart_controller.dart';
import 'package:my_app/controllers/location_controller.dart';
import 'package:my_app/controllers/popular_product_controller.dart';
import 'package:my_app/controllers/recommended_product_controller.dart';
import 'package:my_app/pages/home/main_food_page.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/app_constants.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/app_icon.dart';
import 'package:my_app/widgets/big_text.dart';
import 'package:my_app/widgets/small_text.dart';
import 'package:http/http.dart' as http;



class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: Dimensions.height20*3,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              GestureDetector(
                onTap: (){
                  Get.toNamed(RouteHelper.getInitial());
                },
                child: AppIcon(icon: Icons.arrow_back_ios,
                iconColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 22, 222, 206),
                  iconSize: Dimensions.iconSize24,
                ),
              ),
                SizedBox(width: Dimensions.width20*5,),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: AppIcon(icon: Icons.home_outlined,
                  iconColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 22, 222, 206),
                    iconSize: Dimensions.iconSize24,
                  ),
                ),
                AppIcon(icon: Icons.shopping_cart,
                iconColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 22, 222, 206),
                  iconSize: Dimensions.iconSize24,
                ),
              ],
          )),
        GetBuilder<CartController>(builder: (_cartController){
          return _cartController.getItems.length>0?        Positioned(
            top: Dimensions.height20*5,
            left: Dimensions.width20,
            right: Dimensions.width20,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(top: Dimensions.height15),
             // color: Colors.red,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GetBuilder<CartController>(builder: (cartController){
                  var _cartList = cartController.getItems;
                  return ListView.builder(
                  itemCount: _cartList.length,
                  itemBuilder: (_, index){
                    return Container(
                      width: double.maxFinite,
                      height: Dimensions.height20*5,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              var popularIndex = Get.find<PopularProductController>()
                              .popularProductList
                              .indexOf(_cartList[index].product!);
                              if(popularIndex>=0){
                                Get.toNamed(RouteHelper.getPopularFood(popularIndex,"cartpage"));
                              }else{
                              var recommendedIndex = Get.find<RecommendedProductController>()
                              .recommendedProductList
                              .indexOf(_cartList[index].product!);
                              if(recommendedIndex<0){
                                Get.snackbar("Lịch sử sản phẩm", "Mô tả sản phẩm không có sẵn cho lịch sử giỏ hàng!!!",
                                backgroundColor: Color.fromARGB(255, 45, 229, 236),
                                colorText: Colors.white,
                                );
                              }else{
                                Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "cartpage"));
                              }
                              }
                            },
                            child: Container(
                              width: Dimensions.height20*5,
                              height: Dimensions.height20*5,
                              margin: EdgeInsets.only(bottom: Dimensions.height10),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    
                                    AppConstants.BASE_URL+AppConstants.UPLOAD_URL+cartController.getItems[index].img!
                                  )
                                  ),
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.width10,),
                          Expanded(child: Container(
                            height: Dimensions.height20*5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                BigText(text: cartController.getItems[index].name!, color: Colors.black54,),
                                SmallText(text: "Giá sản phẩm"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BigText(text: cartController.getItems[index].price.toString() + " \VNĐ", color: Colors.redAccent,),
                                    Container(
              padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height10,left: Dimensions.width10,right: Dimensions.width10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      cartController.addItem(_cartList[index].product!, -1);
                    },
                  child: Icon(Icons.remove, color: const Color.fromARGB(255, 186, 186, 186),),),
                  SizedBox(width: Dimensions.width10/2,),
                  BigText(text: _cartList[index].quantity.toString()),
                  SizedBox(width: Dimensions.width10/2,),
                  GestureDetector(
                    onTap: (){
                     cartController.addItem(_cartList[index].product!, 1);
                    },
                  child: Icon(Icons.add, color: const Color.fromARGB(255, 186, 186, 186),),),

                ],
              ),
            ),
                                  ],
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    );
                  });
                }),
              )
          )):NoDataPage(text:"Giỏ hàng của bạn trống!!!" );
        })
        ],
      ),
        bottomNavigationBar: GetBuilder<CartController>(builder:(cartController){
        return Container(
        height: Dimensions.bottomHeightBar,
        padding: EdgeInsets.only(top:Dimensions.height30, bottom: Dimensions.height30, left: Dimensions.width20, right: Dimensions.width20),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 244, 244),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radius20*2),
            topRight: Radius.circular(Dimensions.radius20*2),
          )
        ),
        child: cartController.getItems.length>0?Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20,left: Dimensions.width20,right: Dimensions.width20),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                color: Colors.white,
              ),
              child: Row(
                children: [

                  SizedBox(width: Dimensions.width10/2,),
                  BigText(text: cartController.totalAmount.toString()+ " \VNĐ"),
                  SizedBox(width: Dimensions.width10/2,),


                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                if(Get.find<AuthController>().userLoggedIn()){
                  // cartController.addToHistory();
                  // if(Get.find<LocationController>().addressList.isEmpty){
                  //   Get.toNamed(RouteHelper.getAddressPage());
                  // }else if(Get.find<LocationController>().addressList.isNotEmpty){
                  //   Get.offNamed(RouteHelper.getOrderSuccessPage()); //chuyen sang order thanh cong
                  // }
                  Get.toNamed(RouteHelper.getSaveAddress());
                }else{
                 Get.toNamed(RouteHelper.getSignInPage()); 
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20,left: Dimensions.width20,right: Dimensions.width20),
            
            
                  child: BigText(text: "Đặt Hàng", color: const Color.fromARGB(255, 235, 235, 235),),
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Color.fromARGB(255, 3, 217, 160),
            
                ),
              ),
            )
          ],
        ):Container(),
      );
      })
    );
  }
}