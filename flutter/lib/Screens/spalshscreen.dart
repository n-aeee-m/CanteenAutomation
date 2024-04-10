import 'package:flutter/material.dart';
import 'package:smartcanteen/Screens/canteen/canteenHome.dart';
import 'package:smartcanteen/Screens/user/homescreen.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';
import 'package:smartcanteen/Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
     
    loginCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color.fromARGB(255, 2, 51, 62),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo image here
            Image.asset(
              'assets/logo.png', 
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            // Add your text here
            Text(
              'Smart Canteen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginCheck() async {
  //   print("start");
  //   final shared_pref = await SharedPreferences.getInstance();
  // shared_pref.clear();
  print("start");
    try {
      final shared_pref = await SharedPreferences.getInstance();
      final log = shared_pref.getString("loginData");
      print("Value of log: $log");
      await Future.delayed(Duration(seconds: 5)); // Wait for 20 seconds
      if (!mounted) return; // Check if the widget is still mounted
      if (log == "student") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(userType: log!,)));
      }
      else if(log == "staff"){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(userType: log!,)));
      }
       else if (log == "canteen") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => canteenHomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } catch (e) {
      print("Error in loginCheck: $e");
      // Handle error, e.g., show a dialog or navigate to a default screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
}
