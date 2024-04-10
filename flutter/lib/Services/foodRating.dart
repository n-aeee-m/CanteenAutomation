import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';
import 'package:smartcanteen/data%20models/loginModel.dart';

Future<String> rateFoodApi(final itemId,final rating, final review) async {
  print("c_id $canteenID");
  try {
    final url = Uri.parse('$baseUrl/reviews/');
    final response = await http.post(
      url,
      body: {
    "rating": rating.toString(),
    "review":review.toString(),
    "user": userId.toString(),
    "r_id": canteenID,
    "ritem_id": itemId.toString()
},
    );
    print("Status ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
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
