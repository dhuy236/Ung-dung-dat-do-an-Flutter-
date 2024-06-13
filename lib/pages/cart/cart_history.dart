// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:my_app/base/no_data_page.dart';
// import 'package:my_app/controllers/cart_controller.dart';
// import 'package:my_app/controllers/order_controller.dart';
// import 'package:my_app/models/cart_model.dart';
// import 'package:my_app/models/place_order_model.dart';
// import 'package:my_app/routes/routes_helper.dart';
// import 'package:my_app/utils/app_constants.dart';
// import 'package:my_app/utils/dimensions.dart';
// import 'package:my_app/widgets/app_icon.dart';
// import 'package:my_app/widgets/big_text.dart';
// import 'package:my_app/widgets/small_text.dart';
// import 'package:http/http.dart' as http;

// class CartHistory extends StatelessWidget {
//   const CartHistory({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final OrderController orderController = Get.find<OrderController>();
//     Get.find<OrderController>().getOrderData();
//     var getCartHistoryList =
//         Get.find<OrderController>().orderList;
//     Map<String, int> cartItemsPerOrder = Map();

//     // for (int i = 0; i < getCartHistoryList.length; i++) {
//     //   if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
//     //     cartItemsPerOrder.update(
//     //         getCartHistoryList[i].time!, (value) => ++value);
//     //   } else {
//     //     cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
//     //   }
//     // }
//     List<int> cartItemsPerOrderToList() {
//       return cartItemsPerOrder.entries.map((e) => e.value).toList();
//     }

//     List<String> cartOrderTimeToList() {
//       return cartItemsPerOrder.entries.map((e) => e.key).toList();
//     }

//     List<int> itemsPerOrder = cartItemsPerOrderToList();

//     var listCounter = 0;
//     Widget timeWidget(int index) {
//       var outputDate = DateTime.now().toString();
//       if (index < getCartHistoryList.length) {
//         DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
//             .parse(getCartHistoryList[listCounter].time!);
//         var inputDate = DateTime.parse(parseDate.toString());
//         var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
//         outputDate = outputFormat.format(inputDate);
//       }
//       return BigText(text: outputDate);
//     }

//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             height: Dimensions.height10 * 10,
//             color: Color.fromARGB(255, 26, 202, 176),
//             width: double.maxFinite,
//             padding: EdgeInsets.only(top: Dimensions.height45),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 BigText(
//                   text: "Lịch sử đặt hàng",
//                   color: Colors.white,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Get.toNamed(RouteHelper.getCartPage());
//                   },
//                   child: AppIcon(
//                     icon: Icons.shopping_cart_outlined,
//                     iconColor: Color.fromARGB(255, 26, 202, 176),
//                     backgroundColor: Color.fromARGB(255, 244, 243, 239),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           GetBuilder<OrderController>(builder: (orderController) {
//             final orderData = orderController.orderList;

//             print("orderData: ${orderData.length}");

//             return orderData.length > 0
//                 ? Expanded(
//                     child: Container(
//                         margin: EdgeInsets.only(
//                           top: Dimensions.height20,
//                           left: Dimensions.width20,
//                           right: Dimensions.width20,
//                         ),
//                         child: MediaQuery.removePadding(
//                           removeTop: true,
//                           context: context,
//                           child: ListView(
//                             children: [
//                               for (int i = 0; i < orderData.length; i++)
//                                 Container(
//                                   height: Dimensions.height30 * 4,
//                                   margin: EdgeInsets.only(
//                                       bottom: Dimensions.height20),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       timeWidget(listCounter),
//                                       SizedBox(
//                                         height: Dimensions.height10,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Wrap(
//                                               direction: Axis.horizontal,
//                                               children: List.generate(
//                                                   itemsPerOrder[i], (index) {
//                                                 if (listCounter <
//                                                     getCartHistoryList.length) {
//                                                   listCounter++;
//                                                 }
//                                                 return index <= 2
//                                                     ? Container(
//                                                         height: Dimensions
//                                                                 .height20 *
//                                                             4,
//                                                         width: Dimensions
//                                                                 .height20 *
//                                                             4,
//                                                         margin: EdgeInsets.only(
//                                                             right: Dimensions
//                                                                     .width10 /
//                                                                 1),
//                                                         decoration: BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius.circular(
//                                                                     Dimensions
//                                                                             .radius15 /
//                                                                         2),
//                                                             image: DecorationImage(
//                                                                 fit: BoxFit
//                                                                     .cover,
//                                                                 image: NetworkImage(AppConstants
//                                                                         .BASE_URL +
//                                                                     AppConstants
//                                                                         .UPLOAD_URL +
//                                                                     getCartHistoryList[
//                                                                             listCounter -
//                                                                                 1]
//                                                                         .img!))),
//                                                       )
//                                                     : Container();
//                                               })),
//                                           Container(
//                                             height: Dimensions.height20 * 4,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.end,
//                                               children: [
//                                                 SmallText(
//                                                   text: "Total",
//                                                   color: const Color.fromARGB(
//                                                       255, 156, 152, 152),
//                                                 ),
//                                                 BigText(
//                                                   text: itemsPerOrder[i]
//                                                           .toString() +
//                                                       " Items",
//                                                   color: const Color.fromARGB(
//                                                       255, 156, 152, 152),
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     var orderTime =
//                                                         cartOrderTimeToList();
//                                                     //print("order time"+orderTime[i].toString());
//                                                     Map<int, CartModel>
//                                                         moreOrder = {};
//                                                     for (int j = 0;
//                                                         j <
//                                                             getCartHistoryList
//                                                                 .length;
//                                                         j++) {
//                                                       if (getCartHistoryList[j]
//                                                               .time ==
//                                                           orderTime[i]) {
//                                                         moreOrder.putIfAbsent(
//                                                             getCartHistoryList[j]
//                                                                 .id!,
//                                                             () => CartModel.fromJson(
//                                                                 jsonDecode(jsonEncode(
//                                                                     getCartHistoryList[
//                                                                         j]))));
//                                                       }
//                                                     }
//                                                     Get.find<CartController>()
//                                                         .setItems = moreOrder;
//                                                     Get.find<CartController>()
//                                                         .addToCartList();
//                                                     Get.toNamed(RouteHelper
//                                                         .getCartPage());
//                                                   },
//                                                   child: Container(
//                                                     padding:
//                                                         EdgeInsets.symmetric(
//                                                             horizontal:
//                                                                 Dimensions
//                                                                     .width10,
//                                                             vertical: Dimensions
//                                                                     .height10 /
//                                                                 2),
//                                                     decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius
//                                                             .circular(Dimensions
//                                                                     .radius15 /
//                                                                 3),
//                                                         border: Border.all(
//                                                             width: 1,
//                                                             color:
//                                                                 Color.fromARGB(
//                                                                     255,
//                                                                     29,
//                                                                     201,
//                                                                     181))),
//                                                     child: SmallText(
//                                                         text: "Mua lại",
//                                                         color: Color.fromARGB(
//                                                             255, 29, 201, 181)),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 )
//                             ],
//                           ),
//                         )))
//                 : SizedBox(
//                     height: MediaQuery.of(context).size.height / 1.5,
//                     child: const Center(
//                       child: NoDataPage(
//                         text: "Bạn chưa mua bất cứ gì cả!!!",
//                         // imgPath: "assets/image/emptybox.gif",
//                       ),
//                     ));
//           })
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/base/no_data_page.dart';
import 'package:my_app/controllers/cart_controller.dart';
import 'package:my_app/controllers/order_controller.dart';
import 'package:my_app/controllers/popular_product_controller.dart';
import 'package:my_app/models/cart_model.dart';
import 'package:my_app/models/place_order_model.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/app_constants.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/app_icon.dart';
import 'package:my_app/widgets/big_text.dart';
import 'package:my_app/widgets/small_text.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<OrderController>().getOrderData();
    var getCartHistoryList = Get.find<OrderController>().orderList;
    Map<String, int> cartItemsPerOrder = Map();

    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<String> cartOrderTimeToList() {
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    List<int> itemsPerOrder = cartItemsPerOrderToList();
    var listCounter = 0;

    // Widget timeWidget(int index) {
    //   var outputDate = DateTime.now().toString();
    //   if (index < getCartHistoryList.length) {
    //     DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
    //         .parse(getCartHistoryList[listCounter].time!);
    //     var inputDate = DateTime.parse(parseDate.toString());
    //     var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
    //     outputDate = outputFormat.format(inputDate);
    //   }
    //   return BigText(text: outputDate);
    // }

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: Dimensions.height10 * 10,
            color: Color.fromARGB(255, 26, 202, 176),
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BigText(
                  text: "Lịch sử đặt hàng",
                  color: Colors.white,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getCartPage());
                  },
                  child: AppIcon(
                    icon: Icons.shopping_cart_outlined,
                    iconColor: Color.fromARGB(255, 26, 202, 176),
                    backgroundColor: Color.fromARGB(255, 244, 243, 239),
                  ),
                )
              ],
            ),
          ),
          GetBuilder<OrderController>(
            builder: (orderController) {
              final orderData = orderController.orderList;

              print("orderData: ${orderData}");
              // print("orderDetail: ${orderDetail}");

              return orderData.length > 0
                  ? Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            itemCount: orderData.length,
                            itemBuilder: (context, index) {
                              var order = orderData[index];
                              print("Order: ${order}");
                              Get.find<OrderController>()
                                  .getOrderDetail(order.id);
                              final orderDetail = orderController.orderDetail;

                              print("orderDetail $index : ${orderDetail.length} ");
                              return GetBuilder<OrderController>(
                                  builder: (_orderController) {
                                var cartItem = orderDetail[1];
                                final product =
                                    Get.find<PopularProductController>()
                                        .popularProductList
                                        .firstWhereOrNull((element) {
                                  return element.id == cartItem.foodId;
                                });

                                return orderDetail.length > 0
                                    ? Container(
                                        height: Dimensions.height30 * 4,
                                        margin: EdgeInsets.only(
                                          bottom: Dimensions.height20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // timeWidget(index),
                                            SizedBox(
                                                height: Dimensions.height10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height:
                                                      Dimensions.height20 * 4,
                                                  width:
                                                      Dimensions.height20 * 4,
                                                  margin: EdgeInsets.only(
                                                    right:
                                                        Dimensions.width10 / 1,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      Dimensions.radius15 / 2,
                                                    ),
                                                    color: Colors.blue,
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          AppConstants
                                                                  .BASE_URL +
                                                              AppConstants
                                                                  .UPLOAD_URL +
                                                              (product?.img ??
                                                                  "")),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height:
                                                      Dimensions.height20 * 4,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      SmallText(
                                                        text: "Total",
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 156, 152, 152),
                                                      ),
                                                      BigText(
                                                        text: orderDetail.length
                                                                .toString() +
                                                            " Items",
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 156, 152, 152),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          // var orderTime = cartOrderTimeToList();
                                                          Map<int, CartModel>
                                                              moreOrder = {};
                                                          for (int j = 0;
                                                              j <
                                                                  orderData
                                                                      .length;
                                                              j++) {
                                                            // if (getCartHistoryList[j].time == orderTime[index]) {
                                                            //   moreOrder.putIfAbsent(
                                                            //     getCartHistoryList[j].id!,
                                                            //     () => CartModel.fromJson(
                                                            //       jsonDecode(jsonEncode(getCartHistoryList[j])),
                                                            //     ),
                                                            //   );
                                                            // }
                                                          }
                                                          // Get.find<CartController>().setItems = moreOrder;
                                                          // Get.find<CartController>().addToCartList();
                                                          // Get.toNamed(RouteHelper.getCartPage());
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                Dimensions
                                                                    .width10,
                                                            vertical: Dimensions
                                                                    .height10 /
                                                                2,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                            .radius15 /
                                                                        3),
                                                            border: Border.all(
                                                              width: 1,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      29,
                                                                      201,
                                                                      181),
                                                            ),
                                                          ),
                                                          child: SmallText(
                                                            text: "Mua lại",
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    29,
                                                                    201,
                                                                    181),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Container();
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: const Center(
                        child: NoDataPage(
                          text: "Bạn chưa mua bất cứ gì cả!!!",
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
