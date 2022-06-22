import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../get_started_page.dart';
import 'log_in_taxi_driver_page.dart';

class ResetTaxiPassword extends StatefulWidget {
  @override
  _ResetTaxiPasswordState createState() => _ResetTaxiPasswordState();
}

class _ResetTaxiPasswordState extends State<ResetTaxiPassword> {

  TextEditingController emailTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        //onPressed: () => Navigator.pushNamed(context, 'GetStartedPage'),
        //onPressed: () => Navigator.of(context).pop(),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginTaxiDriverPage()))
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top:3,left: 30.00,right :30.0,bottom: 30.00),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bus tracking .png', package: 'public_transit_tracking_app',
                      width: 500.69,
                      height: 332.22,
                      fit: BoxFit.fitWidth,
                    ),
                    Text(
                      'Reset Password!',
                      style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    TextFormField(
                      controller: emailTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Enter E-mail',
                        hintText: 'abc@gmail.com',
                        border:OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 400,height: 50),
                      child: ElevatedButton(
                        child: Text(
                          'Reset'.toUpperCase(),
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurpleAccent),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Colors.deepPurpleAccent,
                                  ))),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextEditingController.text).then((value) => {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginTaxiDriverPage())),
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
