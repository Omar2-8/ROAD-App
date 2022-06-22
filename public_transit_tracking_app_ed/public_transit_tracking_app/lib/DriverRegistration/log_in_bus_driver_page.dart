import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transit_tracking_app/DriverRegistration/home_driver_page.dart';
import 'package:public_transit_tracking_app/DriverRegistration/reset_bus_password.dart';
import 'package:public_transit_tracking_app/DriverRegistration/sign_up_driver_page.dart';
import 'package:public_transit_tracking_app/UserRegistration/log_in_user_page.dart';

import '../get_started_page.dart';
import '../main.dart';


class LoginBusDriverPage extends StatefulWidget {
  @override
  _LoginBusDriverPageState createState() => _LoginBusDriverPageState();
}

class _LoginBusDriverPageState extends State<LoginBusDriverPage> {

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
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedPage(),),
            //onPressed: () => Navigator.pushNamed(context, 'GetStartedPage'),
            //onPressed: () => Navigator.of(context).pop(),
          )),
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
                      'Welcome Back!\nLogin as bus',
                      textAlign: TextAlign.center,
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
                    TextFormField(
                      obscureText: _isObscure,
                      controller: passwordTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        hintText: '******',
                        border:OutlineInputBorder(),
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
                                  MaterialPageRoute(builder: (context) => ResetBusPassword()
                                  ))},
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        )
                      ]),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 400,height: 50),
                      child: ElevatedButton(
                          child: Text(
                            'Log In'.toUpperCase(),
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
                            if(!emailTextEditingController.text.contains("@")){
                              displayToastMessage("Email address is not Valid.", context);
                            }
                            else if(passwordTextEditingController.text.isEmpty){
                              displayToastMessage("Password is mandatory.", context);
                            }
                            else if(passwordTextEditingController.text.length < 6){
                              displayToastMessage("Password must be at least 6 Characters.", context);
                            }
                            else{
                              logInAndAuthenticateBusDriver(context);
                            }
                          }
                      ),
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
                            ..onTap =() => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpDriverPage()
                                  ))},
                          style: TextStyle(color: Colors.deepPurpleAccent),
                        )
                      ]),
                    ),],
                ),
              ),
            ),],
        ),
      ),
    );
  }

  final _firebaseAuth = FirebaseAuth.instance;

  void logInAndAuthenticateBusDriver(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if (firebaseUser != null ){
      busDriversRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null) {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => ));
          setState(() {
            firebaseUserCurrent.value = firebaseUser;
            driverType.value='b';
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeDriverPage()));
          displayToastMessage("You are logged_In Now.", context);
        }
        else{
          _firebaseAuth.signOut();
          displayToastMessage("No record exists for this user. Please create new account.", context);
        }
      });
    }
    else{
      //error occured - display error msg
      displayToastMessage("Error Occured, can not be Signed-in.", context);
    }
  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
