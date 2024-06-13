import 'package:get/get.dart';
import 'package:my_app/base/show_custom_snackbar.dart';
import 'package:my_app/routes/routes_helper.dart';

class ApiChecker{
  static void checkApi(Response response){
    if(response.statusCode==401){
      Get.offNamed(RouteHelper.getSignInPage());
    }else{
      showCustomSnackBar(response.statusText!);
    }
  }
}