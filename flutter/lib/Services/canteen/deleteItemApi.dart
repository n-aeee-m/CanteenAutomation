import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartcanteen/Screens/canteen/scanQrcodeScreen.dart';
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/getAllMenu.dart';
import 'package:smartcanteen/data%20models/canteen/orderDetailsModel.dart';

Future<String> deleteItemApi(String id) async {
  try {
    final url = Uri.parse('$baseUrl/canteenmenuitembyitemid/$id');
    final response = await http.delete(url,);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode >= 200 && response.statusCode < 300) {
 
      return 'success';
    } else {
      print("else");
      print(response.statusCode);
      return "failed";
    }
  } catch (e) {
    print("Catch : ${e.toString()}");
    return "failed";
  }
}
