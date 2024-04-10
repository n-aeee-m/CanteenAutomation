import 'package:flutter/material.dart';
import 'package:smartcanteen/constants/constants.dart';
import 'package:smartcanteen/Screens/spalshscreen.dart';

class IpScreen extends StatelessWidget {
  IpScreen({super.key});

  final ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: ipController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: "Enter IP Address",
                labelText: "IP Address"
              ),
            ),
        
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () async
            {
              ipAddress = await ipController.text;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SplashScreen(),));
              }, 
              child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}