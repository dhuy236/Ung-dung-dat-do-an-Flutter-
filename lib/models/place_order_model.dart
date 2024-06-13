import 'package:my_app/models/address_model.dart';

class OrderModel {
  late int? id;
  late int? userId;
  double? orderAmount;
  String? orderStatus;
  String? paymentStatus;
  double? totalTaxAmount;
  String? orderNote;
  String? createdAt;
  String? updatedAt;
  double? deliveryCharge;
  String? scheduleAt;
  String? otp;
  String? pending;
  String? accepted;
  String? confirmed;
  String? processing;
  String? handover;
  String? pickedUp;
  String? delivered;
  String? canceled;
  String? refundRequested;
  String? refunded;
  int? scheduled;
  String? failed;
  int? detailsCount;
  int? foodId;
  late List? cart;

  AddressModel? deliveryAddress;

  OrderModel({
    this.id,
    this.userId,
    this.orderAmount,
    this.paymentStatus,
    this.orderNote,
    this.createdAt,
    this.updatedAt,
    this.deliveryCharge,
    this.scheduleAt,
    this.otp,
    this.orderStatus,
    this.pending,
    this.accepted,
    this.confirmed,
    this.processing,
    this.handover,
    this.pickedUp,
    this.delivered,
    this.canceled,
    this.scheduled,
    this.failed,
    this.detailsCount,
    this.deliveryAddress,
    this.foodId,
    this.cart,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderAmount =
        json["order_amount"] != null ? json["order_amount"]!.toDouble() : null;
    paymentStatus = json['payment_status'] ?? "pending";
    totalTaxAmount = 10.0;
    orderNote = json['order_note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderStatus = json['order_status'];
    deliveryCharge = 10.0;
    scheduleAt = json['schedule_at'] ?? "";
    otp = json['otp'];
    pending = json['pending'] ?? "";
    accepted = json['accepted'] ?? "";
    confirmed = json['confirmed'] ?? "";
    processing = json['processing'] ?? "";
    handover = json['handover'] ?? "";
    pickedUp = json['picked_up'] ?? "";
    delivered = json['delivered'] ?? "";
    canceled = json['canceled'] ?? "";
    scheduled = json['scheduled'];
    failed = json['failed'] ?? "";
    detailsCount = json['details_count'];
    foodId = json['food_id'];
    cart = json['cart'];
    deliveryAddress = (json['delivery_address'] != null
        ? new AddressModel.fromJson(json['delivery_address'])
        : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_amount'] = this.orderAmount;
    data['payment_status'] = this.paymentStatus;
    data['total_tax_amount'] = this.totalTaxAmount;
    data['order_note'] = this.orderNote ?? "";
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_charge'] = this.deliveryCharge;
    data['schedule_at'] = this.scheduleAt;
    data['otp'] = this.otp;
    data['pending'] = this.pending;
    data['accepted'] = this.accepted;
    data['confirmed'] = this.confirmed;
    data['processing'] = this.processing;
    data['handover'] = this.handover;
    data['picked_up'] = this.pickedUp;
    data['delivered'] = this.delivered;
    data['canceled'] = this.canceled;
    data['refund_requested'] = this.refundRequested;
    data['refunded'] = this.refunded;
    data['scheduled'] = this.scheduled;
    data['failed'] = this.failed;
    data['details_count'] = this.detailsCount;
    data['cart'] = this.cart;
    data['address_type'] = this.deliveryAddress?.addressType;
    data['contact_person_number'] = this.deliveryAddress?.contactPersonNumber;
    data['contact_person_name'] = this.deliveryAddress?.contactPersonName;
    data['address'] = this.deliveryAddress?.address;
    data['food_id'] = this.foodId;
    data['longitude'] = this.deliveryAddress?.longitude;
    data['latitude'] = this.deliveryAddress?.latitude;
    return data;
  }

  @override
  String toString() {
    return '{id: $id, userId: $userId, orderAmount: $orderAmount, '
        'orderStatus: $orderStatus, paymentStatus: $paymentStatus, '
        'deliveryAddress: $deliveryAddress,foodId: $foodId, cart: $cart}';
  }
}
