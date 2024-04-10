import 'package:flutter/material.dart';
import 'package:smartcanteen/Screens/user/homescreen.dart';
import 'package:smartcanteen/data%20models/cart.dart';
import 'package:smartcanteen/Screens/user/paymentscreen.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';


class cartscreen extends StatefulWidget {
  @override
  _cartscreenState createState() => _cartscreenState();
}

class _cartscreenState extends State<cartscreen> {
  double totalAmount = cartlist.calculateTotalAmount();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: cartlist(onItemRemoved: updateTotalAmount),
      bottomNavigationBar: BottomAppBar(
        //elevation: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount: ₹$totalAmount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
             // SizedBox(height: 5,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>PaymentScreen(totalPrice: totalAmount,canteenId: cartitemlist[0]['canteenId'].toString(),),),
                            );
                        },
                        child: Text('Proceed to Pay'),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen(userType: userTypes!,)),
                          );
                        },
                        child: Text('Shop More'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateTotalAmount() {
    setState(() {
      totalAmount = cartlist.calculateTotalAmount();
    });
  }
}

class cartlist extends StatefulWidget {
  final Function onItemRemoved;

  cartlist({required this.onItemRemoved});

  @override
  _cartlistState createState() => _cartlistState();
  
  static double calculateTotalAmount() {
    double totalAmount = 0;
    for (var order in cartitemlist) {   
      totalAmount += order['subtotal'];
    }
    return totalAmount;
  }
}


class _cartlistState extends State<cartlist> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartitemlist.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            cartitemlist[index]['image'],
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
          title: Text(cartitemlist[index]['name']),
          subtitle: Text('Quantity: ${cartitemlist[index]['itemcount']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total: ₹${cartitemlist[index]['subtotal']}'),
              SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  // Handle cancel button press
                  removeItem(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  // Helper function to remove an item from the order list
  void removeItem(int index) {
    // Ensure that the index is within the valid range
    if (index >= 0 && index < cartitemlist.length) {
      // Remove the item at the specified index
      setState(() {
        cartitemlist.removeAt(index);
      });
      

      // Callback to notify the parent widget about the removal
      widget.onItemRemoved();
    }

    
  }
}
