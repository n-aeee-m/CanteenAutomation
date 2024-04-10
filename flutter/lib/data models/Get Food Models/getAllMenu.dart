// To parse this JSON data, do
//
//     final GetMenuModel = GetMenuModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetMenuModel GetMenuModelFromJson(String str) => GetMenuModel.fromJson(json.decode(str));

String GetMenuModelToJson(GetMenuModel data) => json.encode(data.toJson());

class GetMenuModel {
    int mitemId;
    String mitemName;
    int mcanteenId;
    double mprice;
    double mdiscountprice;
    String mimage;
    String description;
    String categories;
    int quantity;
    bool availabilityStatus;
    int mrating;

    GetMenuModel({
        required this.mitemId,
        required this.mitemName,
        required this.mcanteenId,
        required this.mprice,
        required this.mdiscountprice,
        required this.mimage,
        required this.description,
        required this.categories,
        required this.quantity,
        required this.availabilityStatus,
        required this.mrating,
    });

    factory GetMenuModel.fromJson(Map<String, dynamic> json) => GetMenuModel(
        mitemId: json["mitem_id"],
        mitemName: json["mitem_name"],
        mcanteenId: json["mcanteen_id"],
        mprice: json["mprice"],
        mdiscountprice: json["mdiscountprice"],
        mimage: json["mimage"],
        description: json["description"],
        categories: json["categories"],
        quantity: json["quantity"],
        availabilityStatus: json["availability_status"],
        mrating: json["mrating"],
    );

    Map<String, dynamic> toJson() => {
        "mitem_id": mitemId,
        "mitem_name": mitemName,
        "mcanteen_id": mcanteenId,
        "mprice": mprice,
        "mdiscountprice": mdiscountprice,
        "mimage": mimage,
        "description": description,
        "categories": categories,
        "quantity": quantity,
        "availability_status": availabilityStatus,
        "mrating": mrating,
    };
}
