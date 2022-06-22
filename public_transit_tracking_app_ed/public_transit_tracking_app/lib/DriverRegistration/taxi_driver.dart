import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transit_tracking_app/DriverRegistration/home_driver_page.dart';
import 'package:public_transit_tracking_app/UserRegistration/log_in_user_page.dart';
import '../UserRegistration/home_page_user.dart';
import '../main.dart';
import 'log_in_taxi_driver_page.dart';

class TaxiDriverTab extends StatefulWidget {
  @override
  _TaxiDriverTabState createState() => _TaxiDriverTabState();
}

class _TaxiDriverTabState extends State<TaxiDriverTab> {

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController = TextEditingController();
  TextEditingController vehicleNumberTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool _isObscure = true;

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
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    child: Column(children: [
                      TextFormField(
                        controller: userNameTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Enter Username',
                          hintText: 'john_01',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: phoneNumberTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Enter Phone Number',
                          hintText: '07* **** ***',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: vehicleNumberTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Enter Vehicle Number',
                          hintText: '10.23456',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Enter E-mail',
                          hintText: 'abc@gmail.com',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        obscureText: _isObscure,
                        controller: passwordTextEditingController,
                        decoration: InputDecoration(
                          labelText: 'Enter Password',
                          hintText: '******',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: (){
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 400, height: 50),
                        child: ElevatedButton(
                          child: Text(
                            'Sign Up'.toUpperCase(),
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepPurpleAccent),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                      color: Colors.deepPurpleAccent,
                                    ))),
                          ),
                          onPressed: () async {
                            if(userNameTextEditingController.text.length < 3){
                              displayToastMessage("Name must be at least 3 Characters.", context);
                            }
                            else if(phoneNumberTextEditingController.text.length < 10){
                              displayToastMessage("Phone Number must be at least 10 numbers.", context);
                            }
                            else if(phoneNumberTextEditingController.text.isEmpty){
                              displayToastMessage("Phone Number is Mandatory.", context);
                            }
                            else if(vehicleNumberTextEditingController.text.isEmpty){
                              displayToastMessage("Vehicle Number is Mandatory.", context);
                            }
                            else if(!emailTextEditingController.text.contains("@")){
                              displayToastMessage("Email address is not Valid.", context);
                            }
                            else if(passwordTextEditingController.text.length < 6){
                              displayToastMessage("Password must be at least 6 Characters", context);
                            }
                            else{
                              registerNewTaxiDriver(context);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'ALREADY HAVE AN ACCOUNT ?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'LOG IN NOW',
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () =>
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        LoginTaxiDriverPage()
                                    ))},
                            style: TextStyle(color: Colors.deepPurpleAccent),
                          )
                        ]),
                      ),
                    ],
                    ),
                  ),
                ),
              )],
          ),
        )
    );
  }

  final _firebaseAuth = FirebaseAuth.instance;

  void registerNewTaxiDriver(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null ){  // user created
      // save user info to database
      Map userDataMap = {
        "UserName": userNameTextEditingController.text.trim(),
        "PhoneNumber": phoneNumberTextEditingController.text.trim(),
        "VehicleNumber": vehicleNumberTextEditingController.text.trim(),
        "Email": emailTextEditingController.text.trim(),
      };
      taxiDriversRef.child(firebaseUser.uid).set(userDataMap);
      setState(() {
        firebaseUserCurrent.value = firebaseUser;
        driverType.value='t';
      });
      displayToastMessage("Congratulations, your account has been created.", context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDriverPage()));
      //Navigator.pushNamed(context, 'HomePageUser');
    }
    else{
      //error occured - display error msg
      displayToastMessage("New User Account Has Not Been Created.", context);
    }
  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}