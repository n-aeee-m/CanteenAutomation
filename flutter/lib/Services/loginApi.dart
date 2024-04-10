import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';
import 'package:smartcanteen/data%20models/loginModel.dart';

Future<LoginModel?> loginApi(String? name, String? password) async {
  try {
    if (name == null || password == null) {
      print('Username or password is null');
      return null;
    }

    final url = Uri.parse('$baseUrl/api_login/');
    final response = await http.post(
      url,
      body: {
        'username': name,
        'password': password,
      },
    );
    print(response.body);

    if (response.statusCode < 300 && response.statusCode>=200) {
      final _body = jsonDecode(response.body);
      final resp = LoginModel.fromJson(_body);
      print(_body);
      print(response.statusCode);
      return resp;
    } else {
      print("else");
      print(response.statusCode);
      return null;
    }
  } catch (e) {
    print("Catch : ${e.toString()}");
    return null;
  }
}
