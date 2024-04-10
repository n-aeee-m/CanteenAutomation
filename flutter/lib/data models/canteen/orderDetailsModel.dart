// To parse this JSON data, do
//
//     final OrderDetailsModel = OrderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel OrderDetailsModelFromJson(String str) => OrderDetailsModel.fromJson(json.decode(str));

String OrderDetailsModelToJson(OrderDetailsModel data) => json.encode(data.toJson());

class OrderDetailsModel {
    String orderId;
    String orderDate;
    String orderStatus;
    double totalPrice;
    List<Orderitem> orderitems;

    OrderDetailsModel({
        required this.orderId,
        required this.orderDate,
        required this.orderStatus,
        required this.totalPrice,
        required this.orderitems,
    });

    factory OrderDetailsModel.fromJson(Map<String, dynamic> json) => OrderDetailsModel(
        orderId: json["order_id"],
        orderDate: json["order_date"],
        orderStatus: json["order_status"],
        totalPrice: json["total_price"],
        orderitems: List<Orderitem>.from(json["orderitems"].map((x) => Orderitem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_date": orderDate,
        "order_status": orderStatus,
        "total_price": totalPrice,
        "orderitems": List<dynamic>.from(orderitems.map((x) => x.toJson())),
    };
}

class Orderitem {
    String itemid;
    String itemname;
    int itemcount;
    double itemprice;
    String itemImage;

    Orderitem({
        required this.itemid,
        required this.itemname,
        required this.itemcount,
        required this.itemprice,
        required this.itemImage,
    });

    factory Orderitem.fromJson(Map<String, dynamic> json) => Orderitem(
        itemid: json["itemid"],
        itemname: json["itemname"],
        itemcount: json["itemcount"],
        itemprice: json["itemprice"],
        itemImage: json["itemImage"],
    );

    Map<String, dynamic> toJson() => {
        "itemid": itemid,
        "itemname": itemname,
        "itemcount": itemcount,
        "itemprice": itemprice,
        "itemImage": itemImage,
    };
}
