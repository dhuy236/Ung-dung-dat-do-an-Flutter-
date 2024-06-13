import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/controllers/cart_controller.dart';
import 'package:my_app/controllers/location_controller.dart';
import 'package:my_app/controllers/order_controller.dart';
import 'package:my_app/controllers/user_controller.dart';
import 'package:my_app/models/address_model.dart';
import 'package:my_app/models/cart_model.dart';
import 'package:my_app/models/place_order_model.dart';
import 'package:my_app/models/response_model.dart';
import 'package:my_app/models/user_model.dart';
import 'package:my_app/pages/address/pick_address_map.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/app_constants.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/app_icon.dart';
import 'package:my_app/widgets/app_text_field.dart';
import 'package:my_app/widgets/big_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAddressPage extends StatefulWidget {
  const SaveAddressPage({super.key});

  @override
  State<SaveAddressPage> createState() => _SaveAddressPageState();
}

class _SaveAddressPageState extends State<SaveAddressPage> {
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  final TextEditingController _noteOrder = TextEditingController();
  final CartController cartController = Get.find<CartController>();
  // final OrderController orderController = Get.find<OrderController>();
  final LocationController locationController = Get.find<LocationController>();

  double amountOrder = Get.find<CartController>().totalAmount;
  late bool _isLogged;
  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(45.51563, -122.677433), zoom: 17);
  late LatLng _initalPosition = LatLng(45.51563, -122.677433);

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    if (_isLogged && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() ==
          "") {
        Get.find<LocationController>()
            .saveUserAddress(Get.find<LocationController>().addressList.last);
      }
      Get.find<LocationController>().getUserAddress();
      _cameraPosition = CameraPosition(
          target: LatLng(
              double.parse(
                  Get.find<LocationController>().getAddress["latitude"]),
              double.parse(
                  Get.find<LocationController>().getAddress["longitude"])));
      _initalPosition = LatLng(
          double.parse(Get.find<LocationController>().getAddress["latitude"]),
          double.parse(Get.find<LocationController>().getAddress["longitude"]));
    }
  }

  int _check = 0;
  @override
  Widget build(BuildContext context) {
    List<CartModel> cartData = cartController.getCartData();

    List<Map<String, dynamic>> cartDataOrder = cartData.map((element) {
      return {
        "id": element.id,
        "quantity": element.quantity,
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin đơn hàng"),
        backgroundColor: Color.fromARGB(255, 28, 177, 128),
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        if (userController.userModel != null &&
            _contactPersonName.text.isEmpty) {
          _contactPersonName.text = '${userController.userModel?.name}';
          _contactPersonNumber.text = '${userController.userModel?.phone}';
          if (Get.find<LocationController>().addressList.isNotEmpty) {
            _addressController.text =
                Get.find<LocationController>().getUserAddress().address;
          }
        }

        return GetBuilder<LocationController>(builder: (locationController) {
          _addressController.text = '${locationController.placemark.name ?? ''}'
              '${locationController.placemark.locality ?? ''}'
              '${locationController.placemark.postalCode ?? ''}'
              '${locationController.placemark.country ?? ''}';
          // print("address in my view is" + _addressController.text);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 2, color: Color.fromARGB(255, 28, 177, 128))),
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition:
                            CameraPosition(target: _initalPosition, zoom: 17),
                        onTap: (LatLng) {
                          Get.toNamed(RouteHelper.getPickAddressPage(),
                              arguments: PickAddressMap(
                                fromSignup: false,
                                fromAddress: true,
                                googleMapController:
                                    locationController.mapController,
                              ));
                        },
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        myLocationEnabled: true,
                        onCameraIdle: () {
                          locationController.updatePosition(
                              _cameraPosition, true);
                        },
                        onCameraMove: ((position) =>
                            _cameraPosition = position),
                        onMapCreated: (GoogleMapController controller) {
                          locationController.setMapController(controller);
                          if (Get.find<LocationController>()
                              .addressList
                              .isEmpty) {
                            // locationController.getCurrentLocation(true, mapController: controller);
                          }
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.width20, top: Dimensions.height20),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: locationController.addressTypeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              locationController.setAddressTypeIndex(index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width20,
                                  vertical: Dimensions.height10),
                              margin:
                                  EdgeInsets.only(right: Dimensions.width10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20 / 4),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200]!,
                                        spreadRadius: 1,
                                        blurRadius: 5)
                                  ]),
                              child: Icon(
                                  index == 0
                                      ? Icons.home_filled
                                      : index == 1
                                          ? Icons.work
                                          : Icons.location_on,
                                  color: locationController.addressTypeIndex ==
                                          index
                                      ? Color.fromARGB(255, 28, 177, 128)
                                      : Theme.of(context).disabledColor),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Địa chỉ giao hàng"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                AppTextField(
                  textController: _addressController,
                  hintText: "Địa chỉ của bạn",
                  icon: Icons.map,
                  enabled: true,
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Thông tin liên hệ"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                AppTextField(
                  textController: _contactPersonName,
                  hintText: "Họ và Tên của bạn",
                  icon: Icons.person,
                  enabled: true,
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Số điện thoại của bạn"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                AppTextField(
                  textController: _contactPersonNumber,
                  hintText: "Số điện thoại của bạn",
                  icon: Icons.phone,
                  enabled: true,
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Ghi chú"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                AppTextField(
                  textController: _noteOrder,
                  hintText: "Ghi chú",
                  icon: Icons.note_add,
                  enabled: true,
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: BigText(text: "Phương thức thanh toán"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                RadioListTile(
                  title: Text('Thanh toán khi nhận hàng'),
                  secondary: Icon(Icons.money),
                  value: 0,
                  groupValue: _check,
                  onChanged: (value) {
                    setState(() {
                      _check = int.parse(value.toString());
                    });
                  },
                  activeColor: Color.fromARGB(255, 31, 196, 149),
                ),
                RadioListTile(
                  title: Text('Thanh toán bằng MoMo'),
                  subtitle: Text('  Giảm 10% khi thanh toán'),
                  secondary: Icon(Icons.food_bank),
                  value: 1,
                  groupValue: _check,
                  onChanged: (value) {
                    setState(() {
                      _check = int.parse(value.toString());
                    });
                  },
                  activeColor: Color.fromARGB(255, 31, 196, 149),
                ),
              ],
            ),
          );
        });
      }),
      bottomNavigationBar:
          GetBuilder<OrderController>(builder: (orderController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Dimensions.height20 * 8,
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  bottom: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 245, 244, 244),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20 * 2),
                    topRight: Radius.circular(Dimensions.radius20 * 2),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // print("cart-data: ${cartDataOrder}");
                      // print("amount: ${amountOrder}");
                      // print("Remark: ${_noteOrder.text}");
                      AddressModel _addressModel = AddressModel(
                        addressType: locationController.addressTypeList[
                            locationController.addressTypeIndex],
                        contactPersonName: _contactPersonName.text,
                        contactPersonNumber: _contactPersonNumber.text,
                        address: _addressController.text,
                        latitude:
                            locationController.position.latitude.toString(),
                        longitude:
                            locationController.position.longitude.toString(),
                      );

                      OrderModel _orderModel = OrderModel(
                        orderAmount: amountOrder,
                        deliveryAddress: _addressModel,
                        orderNote: _noteOrder.text,
                        cart: cartDataOrder ?? [],
                      );
                      // print("order-data: ${_orderModel}");
                      locationController
                          .addAddress(_addressModel)
                          .then((response) {
                        if (response.isSuccess) {
                          if (_check == 0) {
                            orderController
                                .addOrder(_orderModel)
                                .then((response) {
                              if (response.isSuccess) {
                                cartController.addToHistory();
                                Get.toNamed(RouteHelper.getOrderSuccessPage());
                                print("thêm đơn hàng thành công?????");
                              } else {
                                print("lỗi rồi!!!");
                              }
                            });
                            // print({
                            //   "order_amount": amountOrder,
                            //   "order_type": "delivery",
                            //   "contact_person_name":
                            //       _addressModel.contactPersonName,
                            //   "contact_person_number":
                            //       _addressModel.contactPersonNumber,
                            //   "address": _addressModel.address,
                            //   "longitude": _addressModel.longitude,
                            //   "latitude": _addressModel.latitude,
                            //   "order_note": _noteOrder.text,
                            //   "cart": cartDataOrder,
                            // });
                            // print("dữ liệu giỏ hàng $_cartsModel");
                            // Get.toNamed(RouteHelper.getOrderSuccessPage());
                          }
                          if (_check == 1) {
                            print("thanh toán momo");
                          }
                          //  print("res: ${_addressModel.paymentMethod}");
                          // print("check: ${_check}");
                          // Get.toNamed(RouteHelper.getOrderSuccessPage());
                          // Get.snackbar("Address", "Thêm Địa Chỉ Thành Công!!!");
                        } else {
                          Get.snackbar("Address", "Vui Lòng Chọn Địa Chỉ");
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: Dimensions.height20,
                          bottom: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      child: BigText(
                        text: "Đặt Hàng",
                        color: Colors.white,
                        size: 22,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        color: Color.fromARGB(255, 3, 217, 160),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
