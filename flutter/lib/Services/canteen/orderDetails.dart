import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartcanteen/Screens/canteen/scanQrcodeScreen.dart';
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/getAllMenu.dart';
import 'package:smartcanteen/data%20models/canteen/orderDetailsModel.dart';

Future<List<OrderDetailsModel>?> getOrderdetailsApi() async {
  try {
    final url = Uri.parse('$baseUrl/orderid/$qrScannedOrderId');
    final response = await http.get(url);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> resp = jsonDecode(response.body);
      final status = resp.map((e) => OrderDetailsModel.fromJson(e)).toList();
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
