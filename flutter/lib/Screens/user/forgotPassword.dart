import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartcanteen/Services/forgotpasswordApi.dart';
import 'package:smartcanteen/Services/sendOtpMail.dart';
import 'package:smartcanteen/Screens/login.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  ValueNotifier<bool> isOtpsendSuccessfully = ValueNotifier(false);
  ValueNotifier<bool> IsLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),

            TextField(
              controller: emailController,
              //obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Registered Email address',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              onPressed: () async {
                await sendOtp(context);
              },
              child: Text("Send OTP"),
            ),
            SizedBox(
              height: 25,
            ),
            ValueListenableBuilder(valueListenable: IsLoading, builder: (context, value, child) {return IsLoading.value? Container(height: 200,width: 200,child: Center(child: CircularProgressIndicator(),)): Container();}),
            ValueListenableBuilder(
              valueListenable: isOtpsendSuccessfully,
              builder: (context, value, child) {
                return isOtpsendSuccessfully.value?
                Column(
                  children: [
                    TextField(
                      controller: otpController,
                     // obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Otp',
                        prefixIcon: Icon(Icons.password_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: newPasswordController,
                     // obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.password),
                      ),
                    ),
                    SizedBox(
                      height: 19,
                    ),
                    ElevatedButton(
                        onPressed: () async{
                          await sendForgot(context);
                          //Navigator.of(context).pop();
                        },
                        child: Text("Submit"))
                  ],
                ): Container();
              },
            )
          ],
        ),
      ),
    );
  }

  sendOtp(BuildContext context) async{
    IsLoading.value = true;
    final resp = await sendOtpApi(emailController.text);
    if(resp == "success"){
      IsLoading.value = false;
      isOtpsendSuccessfully.value = true;
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("A otp has been sent to your mail successfully."),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
    }
    else{
      IsLoading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong please try again!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
    }
  }

  sendForgot(BuildContext context) async{
    final resp = await forgotPassworddApi(emailController.text, newPasswordController.text, otpController.text);
    print(resp);
    if (resp == "success") {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Paswword changed successfully"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(),));
    }
    else{
      print("error pass");
      print(resp);
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong please try again!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 8)));
    }
  }
}
