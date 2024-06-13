import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:my_app/base/custom_loader.dart';
import 'package:my_app/base/show_custom_snackbar.dart';
import 'package:my_app/controllers/auth_controller.dart';
import 'package:my_app/models/signup_body_model.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/app_text_field.dart';
import 'package:my_app/widgets/big_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      "t.png",
      "f.jpg",
      "g.jpg",
    ];
    bool isStrongPassword(String password) {
  // Kiểm tra mật khẩu có ít nhất một ký tự in hoa, một ký tự thường, và một ký tự đặc biệt
  final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*(),.?":{}|<>]).*$');
  return regex.hasMatch(password);
}
void _registration(AuthController authController) {
  String name = nameController.text.trim();
  String phone = phoneController.text.trim();
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  if (name.isEmpty) {
    showCustomSnackBar("Nhập tên của bạn", title: "Name");
  } else if (phone.isEmpty) {
    showCustomSnackBar("Nhập số điện thoại", title: "Phone number");
  } else if (email.isEmpty) {
    showCustomSnackBar("Nhập email của bạn", title: "Email address");
  } else if (!GetUtils.isEmail(email)) {
    showCustomSnackBar("Nhập email hợp lệ", title: "Valid email address");
  } else if (password.isEmpty) {
    showCustomSnackBar("Nhập mật khẩu của bạn", title: "Password");
  } else if (password.length < 6) {
    showCustomSnackBar("Mật khẩu không được nhỏ hơn 6 ký tự", title: "Password");
  }else if (!isStrongPassword(password)) {
  showCustomSnackBar(
    "Mật khẩu phải chứa ít nhất một ký tự in hoa, một ký tự thường và một ký tự đặc biệt",
    title: "Password",
  );
} else {
    SignUpBody signUpBody = SignUpBody(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
    authController.registration(signUpBody).then((status) {
      if (status.isSuccess) {
        print("success registration");
        Get.offNamed(RouteHelper.getSignInPage());
        Get.snackbar("Account", "Đăng kí tài khoản thành công!!!");
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }
}


 

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 243, 243), // Set the background color to transparent
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/screensignin17.jpg"), // Set the background image
            fit: BoxFit.cover,
          ),
        ),
        child: GetBuilder<AuthController>(builder: (authController) {
          return !authController.isLoading
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: Dimensions.screenHeight * 0.05),
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
                      AppTextField(
                        textController: nameController,
                        hintText: "Name",
                        icon: Icons.person,
                        enabled: true,
                      ),
                      SizedBox(height: Dimensions.height20),
                      AppTextField(
                        textController: emailController,
                        hintText: "Email",
                        icon: Icons.email,
                        enabled: true,
                      ),
                      SizedBox(height: Dimensions.height20),
                      // AppTextField(
                      //   textController: phoneController,
                      //   hintText: "Phone",
                      //   icon: Icons.phone,
                      //   enabled: true,
                      // ),
                      // SizedBox(height: Dimensions.height20),
// AppTextField(
//   textController: phoneController,
//   hintText: "Phone",
//   icon: Icons.phone,
//   enabled: true,
// ),
SizedBox(height: 3),
Container(
  padding: EdgeInsets.symmetric(horizontal: 21.0),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(Dimensions.radius15),
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 234, 232, 232).withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: InternationalPhoneNumberInput(
    onInputChanged: (PhoneNumber phoneNumber) {
      phoneController.text = phoneNumber.phoneNumber!;
    },
    onInputValidated: (bool value) {},
    selectorConfig: SelectorConfig(
      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
    ),
    ignoreBlank: false,
    autoValidateMode: AutovalidateMode.disabled,
    selectorTextStyle: TextStyle(color: Colors.black),
    textStyle: TextStyle(color: Colors.black),
    initialValue: PhoneNumber(isoCode: 'VN'),
    formatInput: false,
    inputDecoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: "Phone",
      prefixIcon: Icon(Icons.phone, color: Color.fromARGB(255, 1, 182, 146)),
      contentPadding: EdgeInsets.symmetric(vertical: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        borderSide: BorderSide.none,
      ),
    ),
  ),
),






SizedBox(height: Dimensions.height20),
                      AppTextField(
                        textController: passwordController,
                        hintText: "Password",
                        icon: Icons.password_sharp,
                        isObscure: true,
                        enabled: true,
                      ),
                      SizedBox(height: Dimensions.height20),
                      GestureDetector(
                        onTap: () {
                          _registration(authController);
                        },
                        child: Container(
                          width: Dimensions.screenWidth / 2,
                          height: Dimensions.screenHeight / 13,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius30),
                            color: Color.fromARGB(255, 1, 182, 146),
                          ),
                          child: Center(
                            child: BigText(
                              text: "Đăng kí",
                              size: Dimensions.font20 + Dimensions.font20 / 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height10),
                      RichText(
                        text: TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                          text: "Bạn đã có tài khoản rồi?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 96, 95, 95),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.015),
                      RichText(
                        text: TextSpan(
                          text: "hoặc",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 16, 16, 16), fontSize: 16),
                              
                        ),
                      ),
                      SizedBox(height: Dimensions.screenHeight * 0.015),
                      RichText(
                        text: TextSpan(
                          text: "Đăng nhập nhập bằng các phương thức sau",
                          style: TextStyle(
                            color: Color.fromARGB(255, 96, 95, 95),
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Wrap(
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: Dimensions.radius30,
                              backgroundImage: AssetImage("assets/image/" + signUpImages[index]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const CustomLoader();
        }),
      ),
    );
  }
}