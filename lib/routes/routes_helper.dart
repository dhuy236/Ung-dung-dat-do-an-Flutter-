import 'package:get/get.dart';
import 'package:my_app/pages/account/account_page.dart';
import 'package:my_app/pages/address/add_address_page.dart';
import 'package:my_app/pages/address/pick_address_map.dart';
import 'package:my_app/pages/auth/sign_in_page.dart';
import 'package:my_app/pages/cart/cart_page.dart';
import 'package:my_app/pages/food/popular_food.dart';
import 'package:my_app/pages/food/recommend_food_detail.dart';
import 'package:my_app/pages/home/home_page.dart';
import 'package:my_app/pages/home/main_food_page.dart';
import 'package:my_app/pages/payment/order_success_page.dart';
import 'package:my_app/pages/payment/payment_method.dart';
import 'package:my_app/pages/payment/save_address.dart';
import 'package:my_app/pages/splash/splash_page.dart';

class RouteHelper{
  static const String splashPage="/splash-page";
  static const String initial="/";
  static const String popularFood="/popular-food";
  static const String recommendedFood="/recommended-food";
  static const String cartPage = "/cart-page";
  static const String signIn = "/sign-in";

  static const String pickAddressMap = "/pick-address";
  static const String addAddress="/add-address";
  static const String orderSuccess= '/order-successful';
  static const String paymentMethod= '/payment-method';
  static const String account= '/account';
  static const String saveAddress= '/save-address';
  

  static String getSplashPage()=>'$splashPage';
  static String getInitial()=>'$initial';
  static String getPopularFood(int pageId, String page)=>'$popularFood?pageId=$pageId&page=$page';
  static String getRecommendedFood(int pageId, String page)=>'$recommendedFood?pageId=$pageId&page=$page';
  static String getCartPage()=>'$cartPage';
  static String getSignInPage()=>'$signIn';
  static String getAddressPage()=>'$addAddress';
  static String getPickAddressPage()=>'$pickAddressMap';
  static String getOrderSuccessPage() => '$orderSuccess';
  static String getPaymentMethodPage() => '$paymentMethod';
  static String getAccountPage() => '$account';
  static String getSaveAddress() => '$saveAddress';
  

  static List<GetPage> routes=[
    GetPage(name:pickAddressMap, page:(){
      PickAddressMap _pickAddres = Get.arguments;
      return _pickAddres;
    }),
    GetPage(name: splashPage, page: ()=>SplashScreen()),
    GetPage(name: initial, page: (){
      return HomePage();
    }, transition:Transition.fade ),
    GetPage(name: signIn, page: (){
      return SignInPage();
    }, transition: Transition.fade),

    GetPage(name: popularFood, page: (){
      var pageId=Get.parameters['pageId'];
      var page = Get.parameters['page'];
      return PopularFoodDetail(pageId: int.parse(pageId!), page:page!);
    },
      transition: Transition.fadeIn
    
    ),
    GetPage(name: recommendedFood, page: (){
      var pageId=Get.parameters['pageId'];
      var page = Get.parameters['page'];
      return RecommendedFoodDetail(pageId: int.parse(pageId!), page:page!);
    },
      transition: Transition.fadeIn
    
    ),
    GetPage(name: cartPage, page: (){
      return CartPage();
    },
    transition: Transition.fadeIn
    ),
    GetPage(name: addAddress, page: (){
      return AddAddressPage();
    }),
    GetPage(name: orderSuccess, page: ()=> OrderSuccessPage()),
    GetPage(name: paymentMethod, page: ()=> PaymentMethodPage()),
    GetPage(name: saveAddress, page: ()=> SaveAddressPage()),
    GetPage(name: account, page: ()=> AccountPage()),
  ];
}
