import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcanteen/Services/getAllmenuApi.dart';
import 'package:smartcanteen/Services/signoutApi.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smartcanteen/data models/Get Food Models/getAllMenu.dart';
import 'package:smartcanteen/data models/commomLists/lists.dart';
import 'package:smartcanteen/Screens/user/itemdetails.dart';
import 'package:smartcanteen/Screens/login.dart';
import 'package:smartcanteen/Screens/user/orderhistory.dart';
import 'package:smartcanteen/Screens/user/profileEdit.dart';

List<GetMenuModel> allFoodItems = [];

class HomeScreen extends StatefulWidget {
  final String userType;
  HomeScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  bool isFounditem = false;
  
  @override
  void initState() {
    super.initState();
    getId();
    getToken();
    getUserType();
    getMenu();
    getUserName();
    getEmail();
  }

  Future<void> getId() async {
    final shared_pref = await SharedPreferences.getInstance();
    userId = shared_pref.getInt("userId");
    print(userId);
  }

  Future<void> getUserName() async {
    final shared_pref = await SharedPreferences.getInstance();
    userName = shared_pref.getString("userName");
    print(tokens);
  }

  Future<void> getEmail() async {
    final shared_pref = await SharedPreferences.getInstance();
    userMail = shared_pref.getString("userMail");
    print(tokens);
  }

  Future<void> getUserType() async {
    final shared_pref = await SharedPreferences.getInstance();
    userTypes = shared_pref.getString("userType");
    print("UU : $userTypes");
  }

  Future<void> getToken() async {
    final shared_pref = await SharedPreferences.getInstance();
    tokens = shared_pref.getString("token");
    print(tokens);
  }

  getMenu() async {
    final response = await getAllMenuApi();
    print("FI");
    print(response);
    if (response != null) {
      canteenID = response[0].mcanteenId.toString();
      isLoading.value = false;
      isFounditem = true;
      allFoodItems = response;
    }
    else{
      isLoading.value = false;
      isFounditem = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    ValueListenableBuilder(
      valueListenable: isLoading, 
      builder: (context, isLoadingValue, child) {
        if (isLoadingValue) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );
        }
        else{
          return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        width: 250,
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(userName!.substring(0, 1), style:  TextStyle(fontSize: 18, fontWeight: FontWeight.w800),)
                  //backgroundImage: AssetImage('assets/profile_image.jpg'),
                ),
                SizedBox(height: 8),
                Text(
                  userName!, // replace with user name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  userMail!, // replace with user details
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Reset password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileEditScreen()),
              );
            },
          ),
          ListTile(
            title: Text('View Order History'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              final status = await signoutApi();
              if (status == "success") {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Loged out successfully!"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(10),
                  duration: Duration(seconds: 8),
                ));
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Something went wrong please try again!"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(10),
                  duration: Duration(seconds: 8),
                ));
              }
            },
          ),
        ]),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Icon(Icons.person),
        ),
      ),
      body: isFounditem
              ? 
              DefaultTabController(
                  length: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TabBar(
                          tabs: [
                            Tab(
                              height: 80,
                              text: 'All',
                              icon: ClipOval(
                                child: Image.asset('assets/image2.jpg',
                                    width: 60, height: 50, fit: BoxFit.cover),
                              ),
                            ),
                            Tab(
                              height: 80,
                              text: 'Drinks',
                              icon: ClipOval(
                                child: Image.asset('assets/image3.jpg',
                                    width: 60, height: 50, fit: BoxFit.cover),
                              ),
                            ),
                            Tab(
                              height: 80,
                              text: 'Meals',
                              icon: ClipOval(
                                child: Image.asset('assets/image5.jpg',
                                    width: 60, height: 50, fit: BoxFit.cover),
                              ),
                            ),
                            Tab(
                              height: 80,
                              text: 'Snacks',
                              icon: ClipOval(
                                child: Image.asset('assets/image6.webp',
                                    width: 60, height: 50, fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Option 1 Content
                              buildCardList(tabIndex: 0),

                              // Option 2 Content
                              buildCardList(tabIndex: 1),

                              // Option 3 Content
                              buildCardList(tabIndex: 2),

                              // Option 4 Content
                              buildCardList(tabIndex: 3),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ): Center(child: Text("No items found"))
    );
        }
      },);
    
  }

  Widget buildCardList({required int tabIndex}) {
    // Filter the food items based on the selected category
    List<GetMenuModel> filteredItems = allFoodItems;
    if (tabIndex > 0 && tabIndex <= getCategoryCount()) {
      filteredItems = allFoodItems
          .where((item) => item.categories == getCategoryForTabIndex(tabIndex))
          .toList();
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.6),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final myItem = filteredItems[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height:60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    image: DecorationImage(
                      image: NetworkImage(myItem.mimage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 120,
                ),
                ListTile(
                  title: Text(
                    myItem.mitemName,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),
                  ),
                  subtitle: Column(
                    children: [
                      widget.userType == "staff"
                          ? Text(
                              'Price: ₹' + myItem.mdiscountprice.toString(),
                              style: TextStyle(fontSize: 15),
                            )
                          : Text(
                              'Price: ₹' + myItem.mprice.toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                      RatingBar.builder(
                        initialRating: double.parse(myItem.mrating.toString()),
                        //minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15,
                        ignoreGestures: true,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailsScreen(
                            id: myItem.mitemId,
                            price: widget.userType == "staff"? myItem.mdiscountprice: myItem.mprice
                          ),
                        ),
                      );
                    },
                    child: Text('Details'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  int getCategoryCount() {
    return 3;
  }

  String getCategoryForTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return 'drinks';
      case 2:
        return 'meals';
      case 3:
        return 'snack';
      default:
        return '';
    }
  }
}
