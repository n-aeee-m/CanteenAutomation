import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartcanteen/Screens/user/qrScreen.dart';
import 'package:smartcanteen/Services/foodRating.dart';
import 'package:smartcanteen/Services/orderHistory.dart';
import 'package:smartcanteen/data models/Get Food Models/oredrHistoryModel.dart';
import 'package:smartcanteen/data models/commomLists/lists.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

bool ordersStatus = false;
double? foodRating;
final reviewController = TextEditingController();

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    final allorders = await getorderHistory();
    if (allorders != null) {
      if (allorders.isNotEmpty) {
        ordersStatus = true;
        allOrderList = allorders;
        // Sort the order history based on date
        allOrderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      } else {
        ordersStatus = false;
        allOrderList = allorders;
      }
    } else {
      ordersStatus = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: OrderHistoryList(),
    );
  }
}

class OrderHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ordersStatus
        ? ListView.builder(
            itemCount: allOrderList.length,
            itemBuilder: (context, index) {
              final item = allOrderList[index];
              return OrderHistoryItem(order: item);
            },
          )
        : Center(child: Text("No Data"));
  }
}

class OrderHistoryItem extends StatelessWidget {
  final OrderHistoryModel order;

  OrderHistoryItem({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: order.orderStatus == "undelivered"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${order.orderDate.toString()}',
                    style: TextStyle(fontSize: 12, color: Colors.black26),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      Uint8List bytes = base64Decode(order.qrcode);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrScreen(qrbytes: bytes),));
                    },
                    icon: Icon(Icons.qr_code),
                    label: Text("Scan"),
                  )
                ],
              )
            : Text('Date: ${order.orderDate.toString()}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.orderitems.map((items) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    tileColor: Color.fromARGB(255, 244, 240, 229),
                    title: Text(items.itemname),
                    subtitle: Column(
                      children: [
                        Text(
                            'Quantity: ${items.itemcount}, Total Price: \$${items.itemprice}'),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RatingBar.builder(
                              initialRating: 4,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 15,
                              ignoreGestures: true,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                                
                              },
                            ),
                            TextButton(
                                onPressed: () {
                                   showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Rate food!"),
                  content: Container(
                    height: 300,
                    width:  600,
                    child: Column(
                      children: [
                        RatingBar.builder(
                                initialRating: 4,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 35,
                                //ignoreGestures: true,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  foodRating = rating;
                                print('Food rating : $foodRating');
                                },
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                controller: reviewController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText: "Enter your review",
                                  label: Text("Review"),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                              )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async{
                        await popUpButtonClicked(items.itemid, context);
                      },
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(14),
                        child: const Text("okay"),
                      ),
                    ),
                  ],
                ),
              );
                                },
                                child: Text("Rate it"))
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Text('Total Amount: ₹${order.totalPrice}'),
          ],
        ),
      ),
    );
  }
  popUpButtonClicked(String itemId,BuildContext context) async{
    final res = await rateFoodApi(itemId, foodRating, reviewController.text);
    if(res == "success"){
      Navigator.of(context).pop();
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Thanks for review, review added successfully"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
    }
    else{
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong please try again!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
    }
  }
}
