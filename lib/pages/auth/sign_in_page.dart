import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/base/custom_loader.dart';
import 'package:my_app/base/show_custom_snackbar.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/pages/auth/sign_up_page.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/app_text_field.dart';
import 'package:my_app/widgets/big_text.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key});

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var passwordController = TextEditingController();

    void _login(AuthController authController) {
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if (phone.isEmpty) {
        showCustomSnackBar("Nhập SDT của bạn", title: "Phone");
      } else if (password.isEmpty) {
        showCustomSnackBar("Nhập mật khẩu của bạn", title: "password");
      } else if (password.length < 6) {
        showCustomSnackBar("Mật khẩu không được nhỏ hơn 6 ký tự", title: "password");
      } else {
        authController.login(phone, password).then((status) {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getAccountPage());
            Get.snackbar("Account", "Chào mừng bạn đến với CM FastFood!");
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Size Adjustment
          Transform.scale(
            scale: 1, // Adjust the scale factor as needed
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/image/screensignin17.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Overlay with Opacity for Background
          Container(
            color: Color.fromARGB(255, 211, 211, 211).withOpacity(0.4), // Adjust opacity here
          ),
          // Main Content
          Scaffold(
            backgroundColor: Colors.transparent,
            body: GetBuilder<AuthController>(builder: (authController) {
              return !authController.isLoading
                  ? SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: Dimensions.screenHeight * 0.05,),
                          Container(
                            height: Dimensions.screenHeight * 0.25,
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 80,
                                backgroundImage: AssetImage("assets/image/logo5.png"),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: Dimensions.width20),
                            width: double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello,",
                                  style: TextStyle(
                                    fontSize: Dimensions.font20 * 3 + Dimensions.font20 / 4,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DancingScript",
                                  ),
                                ),
                                Text(
                                  "                Chào bạn đến với CM FastFood",
                                  style: TextStyle(
                                    fontSize: Dimensions.font20,
                                    color: const Color.fromARGB(255, 78, 77, 77),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height20,),
                          AppTextField(
                            textController: phoneController,
                            hintText: "Phone",
                            icon: Icons.phone,
                            enabled: true,
                          ),
                          SizedBox(height: Dimensions.height20,),
                          AppTextField(
                            textController: passwordController,
                            hintText: "Password",
                            icon: Icons.password_sharp,
                            isObscure: true,
                            enabled: true,
                          ),
                          SizedBox(height: Dimensions.height20,),
                          Row(
                            children: [
                              Expanded(child: Container()),
                              RichText(
                                text: TextSpan(
                                  text: "Quên mật khẩu ?",
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 68, 68, 68),
                                    fontSize: Dimensions.font20,
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimensions.width20,),
                            ],
                          ),
                          SizedBox(height: Dimensions.screenHeight * 0.05,),
                          GestureDetector(
                            onTap: () {
                              _login(authController);
                              
                            },
                            child: Container(
                              width: Dimensions.screenWidth / 2,
                              height: Dimensions.screenHeight / 13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radius30),
                                color: Color.fromARGB(255, 1, 182, 173),
                              ),
                              child: Center(
                                child: BigText(
                                  text: "Đăng nhập",
                                  size: Dimensions.font20 + Dimensions.font20 / 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Dimensions.screenHeight * 0.05,),
                          RichText(
                            text: TextSpan(
                              text: "Bạn chưa có tài khoản?",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 120, 119, 119),
                                fontSize: Dimensions.font16,
                              ),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Get.to(() => SignUpPage(), transition: Transition.fade),
                                  text: " Tạo tài khoản",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: Dimensions.font16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : CustomLoader();
            }),
          ),
        ],
      ),
    );
  }
}
