import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/orderModel.dart';

Future<String> orderPlaceApi(OrderModel omodel) async {
  print(omodel.orderedItem);
  final orderedItemJson = jsonEncode(omodel.orderedItem);

  try {
    final url = Uri.parse('$baseUrl/myendpoint/');

    //final bodyJson = model.toJson(); // Convert OrderModel to JSON
    final response = await http.post(
      url,
      body: 
      {
        "order_date":omodel.date,
        "order_time":"09:34:09.23455",
        "order_id": (omodel.orderId).toString(),
        "mcanteen_id":omodel.canteenId.toString(),
        "user": omodel.userId.toString(),
        "payment":omodel.paymentstatus,
        "total_price":(omodel.totalPrice).toString(),
        "orderitem": jsonEncode(omodel.orderedItem)
      }, 
      // Encode JSON as a string
      //headers: {"Content-Type": "application/json"}, // Set content type to JSON
    );
    print('here');
    print(response.body);
    print("Status ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final res = jsonDecode(response.body);
      String qr = res['qrcode'];
      print('order success here');
      return qr;
    } 
    else {
      print("else");
      print(response.statusCode);
      return "failed";
    }
  } 
  catch (e) {
    
    print("Catch : ${e.toString()}");
    return "failed";
  }
}
