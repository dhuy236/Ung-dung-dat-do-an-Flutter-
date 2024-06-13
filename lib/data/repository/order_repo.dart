import 'dart:convert';

import 'package:get/get.dart';
import 'package:my_app/data/api/api_client.dart';
import 'package:my_app/models/place_order_model.dart';
import 'package:my_app/models/signup_body_model.dart';
import 'package:my_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> addOrder(OrderModel orderModel) async {
    //print("vào hàm đăng ký ở authrepo");
    //print(signUpBody.toJson());
    return await apiClient.postData(
        AppConstants.PLACE_ORDER_URI, orderModel.toJson());
  }

  Future<List<OrderModel>> getOrderList() async {
    final response = await apiClient.getData(AppConstants.GET_ORDER_URI);

    print("chạy vào orderRepo: ${response.body}");
    if (response.statusCode == 200) {
     final List<dynamic> data = response.body;
    return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

   Future<Response> getOrderDetail(int? orderId) async {
    final response =
        await apiClient.getData(AppConstants.GET_ORDER_DETAIL(orderId));
    print("chạy vào detailrepo");
    print("orderId: ${orderId}");

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load order details');
    }
  }
}
