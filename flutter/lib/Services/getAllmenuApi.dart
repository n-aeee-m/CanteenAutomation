import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/getAllMenu.dart';

Future<List<GetMenuModel>?> getAllMenuApi() async {
  try {
    final url = Uri.parse('$baseUrl/menu/');
    final response = await http.get(url);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> resp = jsonDecode(response.body);
      final status = resp.map((e) => GetMenuModel.fromJson(e)).toList();
      return status;
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
