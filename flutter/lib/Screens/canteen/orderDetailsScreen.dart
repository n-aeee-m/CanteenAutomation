import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smartcanteen/Screens/canteen/canteenHome.dart';
import 'package:smartcanteen/Services/canteen/deliveredApi.dart';
import 'package:smartcanteen/data%20models/canteen/orderDetailsModel.dart';

class OrderDetails extends StatelessWidget {
  final List<OrderDetailsModel> order;
  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: 
      Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title:
       // order[0].orderStatus == "undelivered"?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Order Id: ${order[0].orderId}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,),),
            Text('${order[0].orderDate.toString()}'),
          ],
        ) ,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('Payment Mode: ${"Payed"}'),
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order[0].orderitems.map((items) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child:
                   ListTile(
                    tileColor: Color.fromARGB(255, 244, 240, 229),
                    leading: CircleAvatar(backgroundImage: NetworkImage(items.itemImage),radius: 40,),
                    title: Text(items.itemname, style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 3,),
                        Text('Quantity: ${items.itemcount}', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                        SizedBox(height: 5,),
                        Text("Total Price: \$${items.itemprice}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600))

                       
                      ],
                    ),
                  ),
                );
              }).toList(),),
              SizedBox(height: 5,),
            Text('Delivery status: ${order[0].orderStatus}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            SizedBox(height: 5,),
            Text('Grand Total: ₹${order[0].totalPrice}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),), 
            SizedBox(height: 15,),
            Center(
              child: Container(
               // color: Colors.green,
                height: 55,
                width: 350,
                child: ElevatedButton(onPressed: () async{
                  await deliveredApiCall(context, order[0].orderId);
                }, child: Text("Delivered"))),
            )
          ],
        ),
      ),
    )
    );
  }
  deliveredApiCall(BuildContext context,String id) async {
    final status = await deliveredApi(id);
    if (status == "success") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Order delivered successfully"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => canteenHomeScreen(),));
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