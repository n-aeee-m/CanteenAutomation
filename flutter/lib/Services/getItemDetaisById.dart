import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/itemByIdModel.dart';

Future<List<GetItemByIdModel>?> getItembyId(int id) async {
  try {
    final url = Uri.parse('$baseUrl/menuitembyitemid/$id');
    final response = await http.get(url);

    print("Response Body: ${response.body}");
    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      print("success id");
      final resp = jsonDecode(response.body);
      final status = (resp as List).map((e) => GetItemByIdModel.fromJson(e)).toList();
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
