import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';

Future<String> forgotPassworddApi(String email, String password, String otp) async {
  try {
    final url = Uri.parse('$baseUrl/changepassword/');
    final response = await http.post(
      url,
      body: {
        'email':email,
        'otp':otp,
        'new_password': password },
    );
    print("Status ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201 ) {
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
