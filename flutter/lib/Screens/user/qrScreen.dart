import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartcanteen/Screens/user/homescreen.dart';
import 'package:smartcanteen/data%20models/commomLists/lists.dart';

class QrScreen extends StatelessWidget {
  final Uint8List qrbytes;
  const QrScreen({super.key, required this.qrbytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(userType: userTypes!),));
        }, icon: Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [ Center(child: Image.memory(qrbytes)),    
      SizedBox(height: 20,),
      Text("Show this qr code in canteen")
      ]),
    );
  }
}
