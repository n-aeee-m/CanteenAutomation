// To parse this JSON data, do
//
//     final LoginModel = LoginModelFromJson(jsonString);

import 'dart:convert';

LoginModel LoginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String LoginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    String access;
    String refresh;
    String userType;
    String username;
    String email;
    int userId;

    LoginModel({
        required this.access,
        required this.refresh,
        required this.userType,
        required this.username,
        required this.email,
        required this.userId,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        access: json["access"],
        refresh: json["refresh"],
        userType: json["user_type"],
        username: json["username"],
        email: json["email"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "access": access,
        "refresh": refresh,
        "user_type": userType,
        "username": username,
        "email": email,
        "user_id": userId,
    };
}
