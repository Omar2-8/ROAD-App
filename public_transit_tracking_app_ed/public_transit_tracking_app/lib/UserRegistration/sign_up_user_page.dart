import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../get_started_page.dart';
import '../main.dart';
import 'home_page_user.dart';
import 'log_in_user_page.dart';

class SignUpUserPage extends StatefulWidget {
  @override
  _SignUpUserPageState createState() => _SignUpUserPageState();
}
class _SignUpUserPageState extends State<SignUpUserPage> {

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController = TextEditingController();
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
        //onPressed: () => Navigator.pushNamed(context, 'GetStartedPage'),
        //onPressed: () => Navigator.of(context).pop(),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedPage()))
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 3, left: 30.00, right: 30.0, bottom: 30.00),
                child: Form(
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
                        'Create Your Account',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
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
                        constraints:
                            BoxConstraints.tightFor(width: 400, height: 50),
                        child: ElevatedButton(
                          child: Text(
                            'Sign Up'.toUpperCase(),
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
                            if (userNameTextEditingController.text.length < 3) {
                              displayToastMessage(
                                  "Name must be at least 3 Characters.",
                                  context);
                            } else if (phoneNumberTextEditingController
                                    .text.length <
                                10) {
                              displayToastMessage(
                                  "Phone Number must be at least 10 numbers.",
                                  context);
                            } else if (phoneNumberTextEditingController
                                .text.isEmpty) {
                              displayToastMessage(
                                  "Phone Number is Mandatory.", context);
                            } else if (!emailTextEditingController.text
                                .contains("@")) {
                              displayToastMessage(
                                  "Email address is not Valid.", context);
                            } else if (passwordTextEditingController
                                    .text.length <
                                6) {
                              displayToastMessage(
                                  "Password must be at least 6 Characters",
                                  context);
                            } else {
                              registerNewUser(context);
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
                              ..onTap = () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginUserPage()))
                                  },
                            style: TextStyle(color: Colors.deepPurpleAccent),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) {
      // user created
      // save user info to database
      Map userDataMap = {
        "UserName": userNameTextEditingController.text.trim(),
        "PhoneNumber": phoneNumberTextEditingController.text.trim(),
        "Email": emailTextEditingController.text.trim(),
      };
      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage(
          "Congratulations, your account has been created.", context);
      setState(() {
        firebaseUserCurrent.value = firebaseUser;
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePageUser()), (route) => false);
    } else {
      //error occured - display error msg
      displayToastMessage("New User Account Has Not Been Created.", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
