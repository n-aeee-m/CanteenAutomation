// To parse this JSON data, do
//
//     final MonthFilteredModel = MonthFilteredModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MonthFilteredModel MonthFilteredModelFromJson(String str) => MonthFilteredModel.fromJson(json.decode(str));

String MonthFilteredModelToJson(MonthFilteredModel data) => json.encode(data.toJson());

class MonthFilteredModel {
    double totalexpenditure;
    List<Item> items;

    MonthFilteredModel({
        required this.totalexpenditure,
        required this.items,
    });

    factory MonthFilteredModel.fromJson(Map<String, dynamic> json) => MonthFilteredModel(
        totalexpenditure: json["totalexpenditure"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalexpenditure": totalexpenditure,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
    };
}

class Item {
    String orderId;
    DateTime orderDate;
    String orderStatus;
    double totalPrice;
    List<Orderitem> orderitems;

    Item({
        required this.orderId,
        required this.orderDate,
        required this.orderStatus,
        required this.totalPrice,
        required this.orderitems,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        orderId: json["order_id"],
        orderDate: DateTime.parse(json["order_date"]),
        orderStatus: json["order_status"],
        totalPrice: json["total_price"],
        orderitems: List<Orderitem>.from(json["orderitems"].map((x) => Orderitem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_date": "${orderDate.year.toString().padLeft(4, '0')}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')}",
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
