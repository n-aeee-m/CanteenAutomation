import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/oredrHistoryModel.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';


Future<List<OrderHistoryModel>?> getcanteenorderHistory() async {
  try {
    final url = Uri.parse('$baseUrl/canteenorders/$userId');
    final response = await http.get(url);

    print("Response Body: ${response.body}");
    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("success fully done");
      final resp = jsonDecode(response.body);
      final status = (resp as List).map((e) => OrderHistoryModel.fromJson(e)).toList();
      return status;
    } else {
      print("else");
      print("Response Status Code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Catch : ${e.toString()}");
    return null;
  }
}
