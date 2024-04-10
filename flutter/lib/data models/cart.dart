List<Map<String, dynamic>> cartitemlist = [];

List<Order> orderHistory = [];

class Order {
  String paymentMode;
  DateTime paymentDateTime;
  List<OrderItem> orderItems;
  double totalAmount;

  Order({
    required this.paymentMode,
    required this.paymentDateTime,
    required this.orderItems,
    required this.totalAmount,
  });
}

class OrderItem {
  String itemName;
  int quantity;
  double totalPrice;

  OrderItem({
    required this.itemName,
    required this.quantity,
    required this.totalPrice,
  });
}