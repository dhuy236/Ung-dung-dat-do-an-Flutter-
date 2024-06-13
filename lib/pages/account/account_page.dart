import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/base/custom_loader.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/controllers/cart_controller.dart';
import 'package:my_app/controllers/location_controller.dart';
import 'package:my_app/controllers/user_controller.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/account_widget.dart';
import 'package:my_app/widgets/app_icon.dart';
import 'package:my_app/widgets/big_text.dart';
import 'package:image_picker/image_picker.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Function(String)? onTap;
    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (_userLoggedIn) {
      Get.find<UserController>().getUserInfo();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 209, 188),
        title: BigText(
          text: " Trang cá nhân",
          size: 24,
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 242, 241, 241), // Thay đổi màu nền ở đây
        child: GetBuilder<UserController>(builder: (userController) {
          return _userLoggedIn
              ? (userController.isLoading
                  ? Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.only(top: Dimensions.height20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: AppIcon(
                              icon: Icons.person,
                              backgroundColor: Color.fromARGB(255, 26, 209, 188),
                              iconColor: Colors.white,
                              iconSize: Dimensions.height45 + Dimensions.height30,
                              size: Dimensions.height15 * 10,
                            ),
                          ),
                          SizedBox(height: Dimensions.height30,),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  AccountWidget(
                                    
                                    appIcon: AppIcon(
                                      icon: Icons.person,
                                      backgroundColor: Color.fromARGB(255, 26, 209, 188),
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigText: BigText(text: userController.userModel.name),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.email,
                                      backgroundColor: Colors.orange,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigText: BigText(text: userController.userModel.email),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  GetBuilder<LocationController>(builder: (locationController) {
                                    if (_userLoggedIn && locationController.addressList.isEmpty) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.offNamed(RouteHelper.getAddressPage());
                                        },
                                        child: AccountWidget(
                                          appIcon: AppIcon(
                                            icon: Icons.location_on,
                                            backgroundColor: Colors.green,
                                            iconColor: Colors.white,
                                            iconSize: Dimensions.height10 * 5 / 2,
                                            size: Dimensions.height10 * 5,
                                          ),
                                          bigText: BigText(text: "Địa chỉ của bạn"),
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.offNamed(RouteHelper.getAddressPage());
                                        },
                                        child: AccountWidget(
                                          appIcon: AppIcon(
                                            icon: Icons.location_on,
                                            backgroundColor: Color.fromARGB(255, 209, 206, 26),
                                            iconColor: Colors.white,
                                            iconSize: Dimensions.height10 * 5 / 2,
                                            size: Dimensions.height10 * 5,
                                          ),
                                          bigText: BigText(text: '${locationController.pickPlacemark.name ?? ''}'),
                                        ),
                                      );
                                    }
                                  }),
                                  SizedBox(height: Dimensions.height20,),
                                  AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.message,
                                      backgroundColor: Colors.blue,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigText: BigText(text: "Message"),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                  GestureDetector(
                                    onTap: () {
                                      if (Get.find<AuthController>().userLoggedIn()) {
                                        Get.find<AuthController>().clearSharedData();
                                        Get.find<CartController>().clear();
                                        Get.find<CartController>().clearCartHistory();
                                        Get.offNamed(RouteHelper.getSignInPage());
                                      } else {
                                        print("you logged out");
                                      }
                                    },
                                    child: AccountWidget(
                                      appIcon: AppIcon(
                                        icon: Icons.logout,
                                        backgroundColor: Colors.red,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height10 * 5 / 2,
                                        size: Dimensions.height10 * 5,
                                      ),
                                      bigText: BigText(text: "Đăng xuất"),
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height20,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : CustomLoader())
              : Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: Dimensions.height20 * 14,
                          margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/image/gifscreen1.gif"),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.height15,),
                        GestureDetector(
                          onTap: () {
                            Get.offNamed(RouteHelper.getSignInPage());
                            print("tap login");
                          },
                          child: Container(
                            width: 200,
                            height: Dimensions.height20 * 3,
                            margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 27, 184, 174),
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                            ),
                            child: Center(child: BigText(text: "Đăng nhập", color: Colors.white, size: Dimensions.font26)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
