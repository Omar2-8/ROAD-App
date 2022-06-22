import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transit_tracking_app/UserRegistration/reset_user_password.dart';
import 'package:public_transit_tracking_app/UserRegistration/sign_up_user_page.dart';
import 'package:public_transit_tracking_app/main.dart';
import 'package:public_transit_tracking_app/model/bus_user.dart';
import 'package:public_transit_tracking_app/model/taxi_user.dart';
import 'package:public_transit_tracking_app/model/user_app.dart';

import '../main.dart';
import 'home_page_user.dart';

class LoginUserPage extends StatefulWidget {
  @override
  _LoginUserPageState createState() => _LoginUserPageState();
}

ValueNotifier<UserApp> currentUser = ValueNotifier(null);
ValueNotifier<BusUser> currentBusUser = ValueNotifier(null);
ValueNotifier<TaxiUser> currentTaxiUser = ValueNotifier(null);
ValueNotifier<User> firebaseUserCurrent = ValueNotifier(null);

class _LoginUserPageState extends State<LoginUserPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedPage(),),
        //onPressed: () => Navigator.pushNamed(context, 'GetStartedPage'),
        onPressed: () => Navigator.of(context).pop(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 3, left: 30.00, right: 30.0, bottom: 30.00),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bus tracking .png',
                      package: 'public_transit_tracking_app',
                      width: 500.69,
                      height: 332.22,
                      fit: BoxFit.fitWidth,
                    ),
                    Text(
                      'Welcome Back!',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 35,
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
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'FOREGET PASSWORD ?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: 'RESET YOUR PASSWORD',
                          recognizer: new TapGestureRecognizer()
                            ..onTap =() => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ResetUserPassword()
                                  ))},
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 400, height: 50),
                      child: ElevatedButton(
                          child: Text(
                            'Log In'.toUpperCase(),
                            style: TextStyle(fontSize: 14),
                          ),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.deepPurpleAccent),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(
                                          color: Colors.deepPurpleAccent,
                                        ))),
                          ),
                          onPressed: () async {
                            if (!emailTextEditingController.text
                                .contains("@")) {
                              displayToastMessage(
                                  "Email address is not Valid.", context);
                            } else if (passwordTextEditingController
                                .text.isEmpty) {
                              displayToastMessage(
                                  "Password is mandatory.", context);
                            } else if (passwordTextEditingController
                                    .text.length <
                                6) {
                              displayToastMessage(
                                  "Password must be at least 6 Characters.",
                                  context);
                            } else {
                              logInAndAuthenticateUser(context);
                            }
                          }),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'NEW USER ?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: 'SIGN UP NOW',
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignUpUserPage()))
                                },
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        )
                      ]),
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

  final _firebaseAuth = FirebaseAuth.instance;

  void logInAndAuthenticateUser(BuildContext context) async {
    final firebaseUser = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text)
        .catchError((errMsg) {
          print(errMsg);
      displayToastMessage("Error: " + errMsg.toString(), context);
    });

    if (firebaseUser != null) {
      usersRef.child(firebaseUser.user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          print(snap.value);
          setState(() {
            firebaseUserCurrent.value = firebaseUser.user;
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePageUser()), (route) => false);
          displayToastMessage("You are logged_In Now.", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "No record exists for this user. Please create new account.",
              context);
        }
      });
    } else {
      //error occured - display error msg
      displayToastMessage("Error Occured, can not be Signed-in.", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
