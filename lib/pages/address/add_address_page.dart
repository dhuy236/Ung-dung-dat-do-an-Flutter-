import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/controllers/location_controller.dart';
import 'package:my_app/controllers/user_controller.dart';
import 'package:my_app/models/address_model.dart';
import 'package:my_app/models/user_model.dart';
import 'package:my_app/pages/address/pick_address_map.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/app_icon.dart';
import 'package:my_app/widgets/app_text_field.dart';
import 'package:my_app/widgets/big_text.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();

  final String address1 =
      "141 Chiến Thắng, Tân Triều, Hà Đông, Hà Nội, Vietnam";
  // final String address2 = "1 Infinite Loop, Cupertino, CA";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin và địa chỉ của bạn"),
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
          // print("địa chỉ đầy đủ:   ${locationController.placemark}");
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
                )
              ],
            ),
          );
        });
      }),
      bottomNavigationBar:
          GetBuilder<LocationController>(builder: (locationController) {
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
                      locationController
                          .addAddress(_addressModel)
                          .then((response) {
                        if (response.isSuccess) {
                          Get.toNamed(RouteHelper.getInitial());
                          Get.snackbar("Address", "Thêm Địa Chỉ Thành Công!!!");
                          // print("test click");
                          // calculateDistance(address1, _addressController.text);
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
                        text: "Lưu thông tin",
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

// Định nghĩa một phương thức không đồng bộ để tính khoảng cách giữa hai địa chỉ
Future<double> calculateDistance(String address1, String address2) async {
  try {
    // // Sử dụng thư viện geocoding để chuyển đổi địa chỉ thành vị trí địa lý
    // List<Location> locations = await Future.wait([
    //   locationFromAddress(address1),
    //   locationFromAddress(address2),
    // ]);

    // // Trích xuất vị trí đầu tiên từ danh sáchl
    // Location location1 = locations[0];
    // Location location2 = locations[1];

    Location location1 = (await locationFromAddress(address1)).first;
    Location location2 = (await locationFromAddress(address2)).first;

    // Gọi phương thức calculateHaversineDistance để tính toán khoảng cách
    double distance = calculateHaversineDistance(
      location1.latitude,
      location1.longitude,
      location2.latitude,
      location2.longitude,
    );
    num multiplier = pow(10, 3);
    // In ra màn hình khoảng cách tính được
    print('Khoảng cách giữa hai địa chỉ: ${(distance * multiplier).round() / multiplier} km');
    return (distance * multiplier).round() / multiplier;
  } catch (e) {
    // Xử lý bất kỳ lỗi nào có thể xảy ra trong quá trình tính toán
    print('Lỗi khi tính khoảng cách: $e');
    return 0.0;
  }
}

// Định nghĩa một phương thức để tính khoảng cách Haversine giữa hai tọa độ
double calculateHaversineDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  // Định nghĩa bán kính trái đất trong kilômét
  const double earthRadius = 6371;

  // Tính sự khác biệt về vĩ độ và kinh độ
  double dLat = _degreesToRadians(lat2 - lat1);
  double dLon = _degreesToRadians(lon2 - lon1);

  // Chuyển đổi vĩ độ thành radian
  lat1 = _degreesToRadians(lat1);
  lat2 = _degreesToRadians(lat2);

  // Áp dụng công thức Haversine để tính khoảng cách
  double a = _haversin(dLat) + cos(lat1) * cos(lat2) * _haversin(dLon);
  double c = 2 * asin(sqrt(a));

  // Trả về khoảng cách tính được
  return earthRadius * c;
}

// Định nghĩa một phương thức để chuyển đổi độ sang radian
double _degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

// Định nghĩa một phương thức để tính hàm Haversine
num _haversin(double val) {
  return pow(sin(val / 2), 2);
}
