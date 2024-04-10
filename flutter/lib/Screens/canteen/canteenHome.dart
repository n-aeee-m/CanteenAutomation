import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartcanteen/Screens/canteen/addMenu.dart';
import 'package:smartcanteen/Screens/canteen/canteenOrderhistory.dart';
import 'package:smartcanteen/Screens/canteen/menuItemDetails.dart';
import 'package:smartcanteen/Screens/canteen/scanQrcodeScreen.dart';
import 'package:smartcanteen/Screens/user/profileEdit.dart';
import 'package:smartcanteen/Services/getAllmenuApi.dart';
import 'package:smartcanteen/Services/signoutApi.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';
import 'package:smartcanteen/Screens/login.dart';


class canteenHomeScreen extends StatefulWidget {
  @override
  State<canteenHomeScreen> createState() => _canteenHomeScreenState();
}

class _canteenHomeScreenState extends State<canteenHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<bool> isFound = ValueNotifier(true);
  //late List<MenuItemModel> menuItems = [];

  @override
  void initState() {
    super.initState();
    getId();
    getUserType();
    getToken();
    getUserName();
    getEmail();
    getMenu();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getMenu(); // Refresh the menu items when the screen becomes visible again
  }

  Future<void> getId() async {
    final shared_pref = await SharedPreferences.getInstance();
    userId = shared_pref.getInt("userId");
    print(userId);
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

  Future<void> getMenu() async {
    final response = await getAllMenuApi();
    print("FI");
    print(response);
    if (response != null) {
      isLoading.value = false;
      
      if (response.length>0) {
        isFound.value = true;
        menuItems = response;
      }
      else{
        isFound.value = false;
      }
    }
    else{
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
         return ValueListenableBuilder(
    valueListenable: isLoading,
    builder: (context, isLoadingValue, child) {
      if (isLoadingValue) {
        // Show loading indicator if data is still loading
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        // Data is loaded, proceed with displaying the UI
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
                  child: Center(child: Text(userName!.substring(0, 1), style:  TextStyle(fontSize: 60, fontWeight: FontWeight.w800 )))
                  //backgroundImage: AssetImage('assets/profile_image.jpg'),
                ),
                SizedBox(height: 8),
                Text(
                  userName ?? '', // replace with user name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  userMail ?? '', // replace with user details
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Scan QR'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanCodePage()),
              );
            },
          ),
          ListTile(
            title: Text('Reset Password'),
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
              //await getorderHistory();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CanteenOrderHistoryScreen()),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
          ),
        ]),
      ),
          appBar: AppBar(
            title: Text("Menu"),
          ),
          body: ValueListenableBuilder(
            valueListenable: isFound,
            builder: (context, isFoundValue, child) {
              return isFoundValue
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final item = menuItems[index];
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: CircleAvatar(
                                backgroundImage: item.mimage != null
                                    ? NetworkImage(item.mimage!)
                                    : NetworkImage(
                                        'https://example.com/default_image.jpg'),
                              ),
                              title: Text(
                                  '${item.mitemName} - \$${item.mprice}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailsScreens(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : Center(child: Text("No Items"));
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMenuScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      }
    },
  );
  }
}




// return
//       ValueListenableBuilder(
//         valueListenable: isLoading, builder: (context, value, child) {  
//         isLoading.value?
//           Center(child: CircularProgressIndicator(),) :
//           Scaffold(
//       key: _scaffoldKey,
      // drawer: Drawer(
      //   width: 250,
      //   child: ListView(padding: EdgeInsets.zero, children: [
      //     DrawerHeader(
      //       decoration: BoxDecoration(
      //         color: Colors.blue,
      //       ),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           CircleAvatar(
      //             radius: 40,
      //             child: Center(child: Text(userName!.substring(0, 1), style:  TextStyle(fontSize: 60, fontWeight: FontWeight.w800 )))
      //             //backgroundImage: AssetImage('assets/profile_image.jpg'),
      //           ),
      //           SizedBox(height: 8),
      //           Text(
      //             userName ?? '', // replace with user name
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 18,
      //             ),
      //           ),
      //           Text(
      //             userMail ?? '', // replace with user details
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 14,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //     ListTile(
      //       title: Text('Scan QR'),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => ScanCodePage()),
      //         );
      //       },
      //     ),
      //     ListTile(
      //       title: Text('Edit Profile'),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => ProfileEditScreen()),
      //         );
      //       },
      //     ),
      //     ListTile(
      //       title: Text('View Order History'),
      //       onTap: () async {
      //         //await getorderHistory();
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => CanteenOrderHistoryScreen()),
      //         );
      //       },
      //     ),
      //     Divider(),
      //     ListTile(
      //       leading: Icon(Icons.logout),
      //       title: Text('Logout'),
      //       onTap: () async {
      //         final status = await signoutApi();
      //         if (status == "success") {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => LoginScreen()),
      //           );
      //         }
      //       },
      //     ),
      //   ]),
      // ),
//       appBar: AppBar(
//         title: Text("Menu"),
//       ),
//       body: 
//           ValueListenableBuilder(valueListenable: isFound, builder: (context, value, child) {
//             return
//             isFound.value ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListView.builder(
//                     itemCount: menuItems.length,
//                     itemBuilder: (context, index) {
//                       final item = menuItems[index];
//                       return Card(
//                         elevation: 3,
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         child: ListTile(
//                           contentPadding: EdgeInsets.all(10),
//                           leading: CircleAvatar(
//                             backgroundImage: item.mimage != null
//                                 ? NetworkImage(item.mimage!)
//                                 : NetworkImage(
//                                     'https://example.com/default_image.jpg'),
//                           ),
//                           title: Text('${item.mitemName} - \$${item.mprice}'),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ItemDetailsScreens(item: item),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//               )
//               : Center(child: Text("No Items"));
//           },),
//                 floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the screen where you can add a new item
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddMenuScreen(),
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//     //return Container();
//       },
//       );
