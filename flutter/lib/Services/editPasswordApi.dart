import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';


Future<String> editPasswordApi(String password) async {

  try {
    final url = Uri.parse('$baseUrl/update-user/$userId/');
    final response = await http.put(
      url,
      body: {'password': password },
    );
    print("Status ${response.statusCode}");
    if (response.statusCode == 200) {
      return "success";
    } else {
      print("else");
      print(response.statusCode);
      print(response.body);
      return "failed";
    }
  } catch (e) {
    print("Catch : ${e.toString()}");
    return "failed";
  }
}
