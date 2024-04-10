// To parse this JSON data, do
//
//     final GetItemByIdModel = GetItemByIdModelFromJson(jsonString);

import 'dart:convert';

GetItemByIdModel GetItemByIdModelFromJson(String str) => GetItemByIdModel.fromJson(json.decode(str));

String GetItemByIdModelToJson(GetItemByIdModel data) => json.encode(data.toJson());

class GetItemByIdModel {
    int mitemId;
    String mitemName;
    double mprice;
    double mdiscountprice;
    String mimage;
    String description;
    String categories;
    int quantity;
    bool availabilityStatus;
    int mcanteenId;

    GetItemByIdModel({
        required this.mitemId,
        required this.mitemName,
        required this.mprice,
        required this.mdiscountprice,
        required this.mimage,
        required this.description,
        required this.categories,
        required this.quantity,
        required this.availabilityStatus,
        required this.mcanteenId,
    });

    factory GetItemByIdModel.fromJson(Map<String, dynamic> json) => GetItemByIdModel(
        mitemId: json["mitem_id"],
        mitemName: json["mitem_name"],
        mprice: json["mprice"],
        mdiscountprice: json["mdiscountprice"],
        mimage: json["mimage"],
        description: json["description"],
        categories: json["categories"],
        quantity: json["quantity"],
        availabilityStatus: json["availability_status"],
        mcanteenId: json["mcanteen_id"],
    );

    Map<String, dynamic> toJson() => {
        "mitem_id": mitemId,
        "mitem_name": mitemName,
        "mprice": mprice,
        "mdiscountprice": mdiscountprice,
        "mimage": mimage,
        "description": description,
        "categories": categories,
        "quantity": quantity,
        "availability_status": availabilityStatus,
        "mcanteen_id": mcanteenId,
    };
}
