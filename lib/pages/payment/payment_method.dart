import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_app/controllers/popular_product_controller.dart';
import 'package:my_app/controllers/recommended_product_controller.dart';
import 'package:my_app/routes/routes_helper.dart';
import 'package:my_app/utils/dimensions.dart';
import 'package:my_app/widgets/big_text.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> with TickerProviderStateMixin {
  
  // late Animation<double> animation;
  // late AnimationController controller;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
           Center
          (child: Image.asset("assets/image/success.png",

          width: Dimensions.splashImg),
        
          ),
          Center(child:  Text("Đặt hàng thành công!")),
          
  GestureDetector(
    onTap: (){
      Get.toNamed(RouteHelper.getInitial()); 
    },
    child: Container(
                  margin:  EdgeInsets.only(top:Dimensions.height30 ),
                  padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height10,left: Dimensions.width10,right: Dimensions.width10),
              
              
                    child: BigText(text: "Quay Lại Trang Chủ", color: const Color.fromARGB(255, 235, 235, 235),),
                  
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20/2),
                    color: Color.fromARGB(255, 3, 217, 160),
              
                  ),
                ),
  )
        ],
      ),
    );
  }
}