import 'package:flutter/material.dart';
import 'package:my_app/controllers/cart_controller.dart';
import 'package:my_app/controllers/popular_product_controller.dart';
import 'package:my_app/controllers/recommended_product_controller.dart';
import 'package:my_app/pages/auth/sign_in_page.dart';
import 'package:my_app/pages/auth/sign_up_page.dart';
import 'package:my_app/pages/cart/cart_page.dart';
import 'package:my_app/pages/food/popular_food.dart';
import 'package:my_app/pages/food/recommend_food_detail.dart';
import 'package:my_app/pages/home/food_page_body.dart';
import 'package:my_app/pages/home/main_food_page.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/splash/splash_page.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'helper/dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartData();
    return GetBuilder<PopularProductController>(builder: (_){
      return GetBuilder<RecommendedProductController>(builder: (_){
        return  GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CM FastFood',
          //home: SignInPage(),
          // home: SplashScreen(),
          initialRoute: RouteHelper.getSplashPage(),
          getPages: RouteHelper.routes,
          theme: ThemeData(
            primaryColor: Color.fromARGB(255, 40, 200, 136),
            fontFamily: "Lato",
          ),
        );
      });
    });
  }
}

