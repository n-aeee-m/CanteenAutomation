import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartcanteen/Screens/user/cartscreen.dart';
import 'package:smartcanteen/Services/getItemDetaisById.dart';
import 'package:smartcanteen/data%20models/Get%20Food%20Models/itemByIdModel.dart';
import 'package:smartcanteen/data%20models/cart.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';

class ItemDetailsScreen extends StatefulWidget {
  //final String usertype;
  final int id;
  final price;

  ItemDetailsScreen({required this.id, required this.price });

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}
  bool isFound = false;
class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  int quantity = 1;
  
  double tprice = 0; // Initialize to 0, it will be calculated later
  GetItemByIdModel? currentItem;
  void addToCartList() {
    setState(() {
      cartitemlist.add({
        'image': currentItem!.mimage,
        'name': currentItem!.mitemName,
        'itemid': currentItem!.mitemId,
        'itemcount': quantity,
        'itemprice':  widget.price,
        'subtotal': tprice,
        'canteenId': currentItem!.mcanteenId
      });
    });
  }
// gyCXwGE7nmIV
  @override
  void initState() {
    super.initState();

   getDetais();
  // addToCartList();
    // Initialize total price based on quantity and price
    // tprice = currentItem['price'] * quantity;
  }

  getDetais() async{
    final responce = await getItembyId(widget.id);
    if (responce != null) {
      isFound = true;
      currentItem = responce[0];
      tprice = widget.price * quantity;
    }
    setState(() {
      
    });
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      tprice = widget.price*quantity;
    });
    print(tprice);
  }

  void decrementQuantity() {
    print(userTypes);
    if (quantity > 1) {
      setState(() {
        quantity--;
        tprice = widget.price*quantity;
      });
    }
    print(tprice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body:
      currentItem == null // Check if currentItem is null
          ? Center(child: CircularProgressIndicator()):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Image.network(
              currentItem!.mimage,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),

            // Name
            Text(
              currentItem!.mitemName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Description
            Text(
              currentItem!.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),

            // Availability
Text(
  currentItem!.availabilityStatus ? '${currentItem!.quantity} Available' : 'Sorry! Item not available',
  style: TextStyle(
    fontSize: 16,
    color: currentItem!.availabilityStatus ? Colors.green : Colors.red, // Optional: Use different colors for availability status
    fontWeight: FontWeight.bold,
  ),
),
SizedBox(height: 8),
            // Price
            Text(
              'Price: ₹$tprice',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            // Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Quantity: $quantity',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: decrementQuantity,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: incrementQuantity,
                ),
              ],
            ),
            SizedBox(height: 8),

            // Order Button
           ElevatedButton(
  onPressed: currentItem!.availabilityStatus ? () {
    if (quantity > currentItem!.quantity) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Sorry! This much item currently not available."),
            backgroundColor: Color.fromARGB(255, 198, 204, 198),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
    }
    else{
      addToCartList();
    print(cartitemlist);

      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => cartscreen()),
            );
    }
    
  } : null,
  child: Text('Order Now'),
)

          ],
        ),
      ),
    );
  }
}
