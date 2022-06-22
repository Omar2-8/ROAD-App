import 'package:flutter/material.dart';

import 'DriverRegistration/sign_up_driver_page.dart';
import 'UserRegistration/log_in_user_page.dart';



class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bus tracking .png', package: 'public_transit_tracking_app',
                      width: 500.69,
                      height: 332.22,
                      fit: BoxFit.fitWidth,
                    ),
                    Text(
                      'Welcome to ',
                      style:TextStyle(
                        fontWeight:FontWeight.normal,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      'ROAD APP',
                      style:TextStyle(
                        fontWeight:FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 400,height: 50),
                      child: ElevatedButton(
                        child: Text(
                          'User',
                          style: TextStyle(fontSize: 20),
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
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginUserPage())
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 400,height: 50),
                      child: ElevatedButton(
                        child: Text(
                          'Driver',
                          style: TextStyle(fontSize: 20),
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
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpDriverPage())
                          );
                        },
                      ),
                    ),
                ],),
              ),
            )],
        ),
      ),
    );
  }
}

