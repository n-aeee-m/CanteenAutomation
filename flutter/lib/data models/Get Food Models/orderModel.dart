class OrderModel {
  final String date;
  final String orderId;
  final int userId;
  final String canteenId;
  final double totalPrice;
  final String paymentstatus;
  final List<Map<String, dynamic>> orderedItem;

  OrderModel({
    required this.date,
    required this.orderId,
    required this.userId,
    required this.canteenId,
    required this.totalPrice,
    required this.paymentstatus,
    required this.orderedItem,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'order_id': orderId,
      'user_id': userId,
      'canteen_id': canteenId,
      'total_price': totalPrice,
      'payment_status': paymentstatus,
      'ordered_item': orderedItem.map((item) => _mapToJsonObject(item)).toList(),
    };
  }

  Map<String, dynamic> _mapToJsonObject(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, value));
  }
}
