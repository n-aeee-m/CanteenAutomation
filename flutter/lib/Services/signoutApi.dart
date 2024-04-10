import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';
import 'package:smartcanteen/data%20models/loginModel.dart';

String? token; 

// Modify getToken function to return the token value
Future<String?> getToken() async {
  final shared_pref = await SharedPreferences.getInstance();
  return shared_pref.getString("token");
}

Future<String> signoutApi() async {
  // final shared_pref = await SharedPreferences.getInstance();
  // shared_pref.clear();
  // Call getToken and assign the value to the global token variable
  token = await getToken();
  try {
    print("token : $token");
    final url = Uri.parse('$baseUrl/api_logout/');
    final response = await http.post(
      url,
      body: {'token': token},
    );
    print("Status ${response.statusCode}");
    if (response.statusCode == 200) {
  final shared_pref = await SharedPreferences.getInstance();
  shared_pref.clear();
      return "success";
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
