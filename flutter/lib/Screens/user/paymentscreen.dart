import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartcanteen/Screens/user/homescreen.dart';
import 'package:smartcanteen/Screens/user/qrScreen.dart';
import 'package:smartcanteen/Services/orderPlaceApi.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/orderModel.dart';
import 'package:smartcanteen/data%20models/cart.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';


class PaymentScreen extends StatelessWidget {
  final double totalPrice;
  final String canteenId; // Assuming you have the total price

  PaymentScreen({required this.totalPrice, required this.canteenId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Navigate to the home screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(userType: userTypes!,),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onPaymentButtonClicked(context);
              },
              style: ElevatedButton.styleFrom(
                //primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Pay with UPI',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                onPaymentButtonClicked(context,);
              },
              style: ElevatedButton.styleFrom(
                //primary: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Bank Transfer',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void onPaymentButtonClicked(BuildContext context) async{


String getCurrentDate() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  return formattedDate;
}

    final order = OrderModel(date: getCurrentDate().toString(), orderId: DateTime.now().microsecondsSinceEpoch.toString(), userId: userId!, canteenId: canteenId, totalPrice: totalPrice, paymentstatus: "paid", orderedItem:cartitemlist );
      print(cartitemlist);
     final res = await orderPlaceApi(order);

     if (res != "failed") {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Order has been placed successfully."),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));

        Uint8List bytes = base64Decode(res);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrScreen(qrbytes: bytes),));
        cartitemlist.clear();
     }
    // Create order details based on cart items
    // List<OrderItem> orderItems = cartitemlist.map((item) {
    //   return OrderItem(
    //     itemName: item['name'],
    //     quantity: item['quantity'],
    //     totalPrice: item['totalPrice'],
    //   );
    // }).toList();

    // Create an instance of the Order class
    // Order order = Order(
    //   paymentMode: paymentMode,
    //   paymentDateTime: DateTime.now(),
    //   orderItems: orderItems,
    //   totalAmount: totalPrice,
    // );

    // Add the order to the order history
    // orderHistory.add(order);

    // Clear the cartitemlist
   

  //   Navigator.push(
  // context,
  // MaterialPageRoute(
  //   builder: (context) => QrCodeScreen())
  //   );
    
  }
}
