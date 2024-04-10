import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartcanteen/Screens/user/qrScreen.dart';
import 'package:smartcanteen/Services/canteen/canteenHistoryApi.dart';
import 'package:smartcanteen/Services/canteen/getMonthlyInvoice.dart';
import 'package:smartcanteen/Services/foodRating.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/oredrHistoryModel.dart';
import 'package:smartcanteen/data%20models/canteen/canteenMonthFilterModel.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';

class CanteenOrderHistoryScreen extends StatefulWidget {
  @override
  State<CanteenOrderHistoryScreen> createState() =>
      _CanteenOrderHistoryScreenState();
}

bool ordersStatus = false;
double? foodRating;
final reviewController = TextEditingController();
String? selectedMonth;
int? selectedMonthIndex;
ValueNotifier<bool> isFiltered = ValueNotifier(false);
MonthFilteredModel? monthlyData;
ValueNotifier<String> selectedMonthname = ValueNotifier('Select Month');

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class _CanteenOrderHistoryScreenState
    extends State<CanteenOrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  getOrders() async {
    setState(() {
      ordersStatus = false; // Set loading status
    });

    final allorders = await getcanteenorderHistory();

    if (allorders != null && allorders.isNotEmpty) {
      allorders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      setState(() {
        ordersStatus = true; // Set loaded status
        allOrderList = allorders;
      });
    } else {
      setState(() {
        ordersStatus = false; // Set loaded status
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        actions:  [

          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
            context: context,
            builder: (BuildContext context) {
              return _showFilterOptions(context);
            });
              ;
            },
          ),
        ],
      ),
      body: ordersStatus
          ? ValueListenableBuilder(valueListenable: isFiltered, builder: (context, value, child) {return 
            isFiltered.value? OrderHistoryListFiltered() : OrderHistoryList();
          },)
          : Center(child: CircularProgressIndicator()),
    );
  }

 AlertDialog _showFilterOptions(BuildContext context) {
  return AlertDialog(
    title: Text("Select Month"),
    content: Container(
      height: MediaQuery.of(context).size.height * 0.5, // Fixed height
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: selectedMonthname,
                    builder: (BuildContext context, value, Widget? child) {
                      return ListTile(
                        title: Text(selectedMonthname.value),
                      );
                    },
                  ),
                  Divider(),
                  for (var month in months)
                    ListTile(
                      title: Text(month),
                      onTap: () {
                        setState(() {
                          isFiltered.value = false;
                          selectedMonth = month;
                          selectedMonthIndex = months.indexOf(month) + 1;
                          selectedMonthname.value = month;
                        });
                      },
                    ),
                  Divider(),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    'Apply Filter',
                    style: TextStyle(
                      color: Colors.black12,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () async {
                    print(selectedMonthIndex);
                    await filterButton();
                  },
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    'Remove Filter',
                    style: TextStyle(
                      color: Colors.black12,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    isFiltered.value = false;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}



  filterButton() async{
    final data = await getMonthlyInvoice(selectedMonthIndex!.toString());
    if (data != null) {
      print("data: $data");
      monthlyData = data;
      Navigator.of(context).pop();
    }
    else{
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong please try again!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
    }

    if (selectedMonth != null) {
      isFiltered.value = true;
    }
  }
}

class OrderHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (allOrderList.isEmpty) {
      return Center(child: Text("No Data"));
    } else {
      return ListView.builder(
        itemCount: allOrderList.length,
        itemBuilder: (context, index) {
          final item = allOrderList[index];
          return OrderHistoryItem(order: item);
        },
      );
    }
  }
}

class OrderHistoryListFiltered extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
      return 
      ListView(
       // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text(selectedMonth.toString(),style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold))),
          for (int index = 0; index < monthlyData!.items.length ; index++)
            Column(
                      children: [
                         Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text('Date: ${monthlyData!.items[index].orderDate}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: monthlyData!.items[index].orderitems.map((items) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(items.itemImage),
                    ),
                    tileColor: Color.fromARGB(255, 244, 240, 229),
                    title: Text(items.itemname),
                    subtitle: Column(
                      children: [
                        Text(
                            'Quantity: ${items.itemcount}, Total Price: \$${items.itemprice}'),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            
            Text('Total Amount: ₹${monthlyData!.items[index].totalPrice}'),
          ],
        ),
      ),
    )
                      ],
                    ),

          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Text("Total Transaction : ",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black45)), Text(monthlyData!.totalexpenditure.toString(),style:TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),
          ]
      );
      
    
    // return Container(height: double.infinity,
    // width: double.infinity,
    // child: Text("Filtered"),);
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
        title: Text('Date: ${order.orderDate.toString()}'),
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
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(items.itemImage),
                    ),
                    tileColor: Color.fromARGB(255, 244, 240, 229),
                    title: Text(items.itemname),
                    subtitle: Column(
                      children: [
                        Text(
                            'Quantity: ${items.itemcount}, Total Price: \$${items.itemprice}'),
                        SizedBox(
                          height: 3,
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

  Future<dynamic> ratingpopUp(BuildContext context, final itemId) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Rate our food"),
        content: Container(
          height: 175,
          child: Column(
            children: [
              RatingBar.builder(
                //initialRating: 4,
                //minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                //ignoreGestures: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  foodRating = rating;
                  print(rating);
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "Add your review",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              )
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () async {
                final status = await rateFoodApi(itemId, foodRating,
                    reviewController.text);
                if (status == "success") {
                  Navigator.of(ctx).pop();
                }
              },
              child: Text("Submit")),
        ],
      ),
    );
  }
}
