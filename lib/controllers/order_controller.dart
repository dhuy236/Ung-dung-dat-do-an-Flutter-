import 'package:get/get.dart';
import 'package:my_app/data/repository/order_repo.dart';
import 'package:my_app/models/place_order_model.dart';
import 'package:my_app/models/response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({
    required this.orderRepo,
  });
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Map<int, OrderModel> _items = {};
  List<OrderModel> _orderList = [];
  List<OrderModel> _orderDetail = [];

  void getOrderData() async {
    _isLoading = true;
    update();

    try {
      // Thực hiện các thao tác lấy dữ liệu đơn hàng ở đây
      // Ví dụ sử dụng OrderRepo để lấy dữ liệu từ API hoặc database
      List<OrderModel> orderData = await orderRepo.getOrderList();

      // Cập nhật danh sách đơn hàng và tắt trạng thái loading
      _orderList = orderData;
      _isLoading = false;

      // Thông báo UI cập nhật
      update();

      print("chạy vào orderController: $orderData");

      // Trả về danh sách đơn hàng
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error fetching order data: $e');

      // Tắt trạng thái loading và thông báo UI cập nhật
      _isLoading = false;
      update();

      // Ném lại lỗi để bên gọi có thể xử lý
      throw e;
    }
  }

   Future<void> getOrderDetail(int? orderId) async {
    print("chạy vào ordercontroller!!!!!");
    _isLoading = true;
    // update();

    try {
      // Thực hiện lấy dữ liệu chi tiết đơn hàng
      print("123456789");
      Response response = await orderRepo.getOrderDetail(orderId);

      // Xử lý dữ liệu response, ví dụ parse JSON
      Map<dynamic, dynamic> orderDetailData = response.body;
      // OrderModel orderDetail = OrderModel.fromJson(orderDetailData);
      // print("OrderDetail: ${orderDetailData['details']}");
      // Cập nhật danh sách đơn hàng với chi tiết đơn hàng
      // _orderList.add(orderDetail);
        final list =orderDetailData['details'];
        print("in trước forr");
        for(var item in list ){
          OrderModel orderDetail = OrderModel.fromJson(item);
          _orderDetail.add(orderDetail);
        }

      print("orderDetailController: ${orderDetailData['details']}");

      // Tắt trạng thái loading và thông báo UI cập nhật
      _isLoading = false;
      update();
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error fetching order detail: $e');

      // Tắt trạng thái loading và thông báo UI cập nhật
      _isLoading = false;
      update();
 
      // Ném lại lỗi để bên gọi có thể xử lý
      // throw e;
    }
  }

  List<OrderModel> get orderList => _orderList;
  List<OrderModel> get orderDetail => _orderDetail;

  Future<ResponseModel> addOrder(OrderModel orderModel) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.addOrder(orderModel);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.statusText!);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

 
}
