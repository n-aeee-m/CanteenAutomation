import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/canteen/canteenMonthFilterModel.dart';
import 'package:smartcanteen/data%20models/canteen/orderDetailsModel.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';

Future<MonthFilteredModel?> getMonthlyInvoice(String month) async {
  print('filter here');
  try {
    print('filter here try');
    final url = Uri.parse('$baseUrl/orderspermonthperday/2024/$month/$userId');
    final response = await http.get(url);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode >= 200 || response.statusCode <300) {
      print('filter here success');
      final resp = jsonDecode(response.body);
      final status = MonthFilteredModel.fromJson(resp);
      return status;
    } else {
      print('filter here else');
      print(response.statusCode);
      return null;
    }
  } catch (e) {
    print("Catch : ${e.toString()}");
    return null;
  }
}
