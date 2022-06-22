import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:public_transit_tracking_app/DriverRegistration/home_driver_page.dart';
import 'package:public_transit_tracking_app/UserRegistration/log_in_user_page.dart';
import 'package:public_transit_tracking_app/model/station_model.dart';

import '../UserRegistration/home_page_user.dart';
import '../main.dart';
import 'log_in_bus_driver_page.dart';

List<Station> stations = [];

class BusDriverTab extends StatefulWidget {
  @override
  _BusDriverTabState createState() => _BusDriverTabState();
}

class _BusDriverTabState extends State<BusDriverTab> {

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController = TextEditingController();
  TextEditingController vehicleNumberTextEditingController = TextEditingController();
  TextEditingController routeNameTextEditingController = TextEditingController();
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
                    child: Column(
                      children: [
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
                          controller: routeNameTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Enter Route Name',
                            hintText: 'Amman-Zarqa',
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
                        Text(
                          'Choose the stations you cross and the start and end station'
                              .toUpperCase(),
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: stations.length,
                            itemBuilder: (context, index) {
                              return stationCard(stations[index], index);
                            }),
                        SizedBox(
                          height: 25,
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: 400, height: 50),
                          child: ElevatedButton(
                            child: Text(
                              'Choose from map'.toUpperCase(),
                              style: TextStyle(fontSize: 14),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepPurpleAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Colors.deepPurpleAccent,
                                      ))),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey:
                                        'AIzaSyA8FaWVRl9s4lR6FPsW694qJTLY7_b-whg',
                                    // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) {
                                      print(result.id);
                                      print(result.formattedAddress);
                                      print(result.placeId);
                                      print(result.name);
                                      print(result.geometry.location.lat);
                                      print(result.geometry.location.lng);
                                      stations.add(Station(
                                          id: result.placeId,
                                          name: result.formattedAddress,
                                          lng: result.geometry.location.lng
                                              .toString(),
                                          lat: result.geometry.location.lat
                                              .toString()));
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                    useCurrentLocation: true,
                                    initialPosition: LatLng(31.955633, 35.851317),
                                  ),
                                ),
                              );
                            },
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
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.deepPurpleAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                        color: Colors.deepPurpleAccent,
                                      ))),
                            ),
                            onPressed: () async {
                              print('jknjn');
                              if (userNameTextEditingController.text.length <
                                  3) {
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
                              } else if (vehicleNumberTextEditingController
                                  .text.isEmpty) {
                                displayToastMessage(
                                    "Vehicle Number is Mandatory.", context);
                              } else if (routeNameTextEditingController
                                  .text.isEmpty) {
                                displayToastMessage(
                                    "Route Name is Mandatory.", context);
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
                              } else if (stations.length < 1) {
                                displayToastMessage(
                                    "You must choose your stations", context);
                              } else {
                                registerNewBusDriver(context);
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
                                                  LoginBusDriverPage()))
                                    },
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  final _firebaseAuth = FirebaseAuth.instance;

  void registerNewBusDriver(BuildContext context) async {
    print('ml');
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      displayToastMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    ///Set id for each station in a list to save it in Driver collection as a array
    ///and we will get it stations by id from stations collection
    List<String> stationsId = [];
    stations.forEach((element) {
      stationsId.add(element.id);
    });
    if (firebaseUser != null) {
      // user created
      // save user info to database
      Map userDataMap = {
        "UserName": userNameTextEditingController.text.trim(),
        "PhoneNumber": phoneNumberTextEditingController.text.trim(),
        "VehicleNumber": vehicleNumberTextEditingController.text.trim(),
        "RouteName": routeNameTextEditingController.text.trim(),
        "Email": emailTextEditingController.text.trim(),
        'Stations': stationsId.toList(),
      };
      await busDriversRef.child(firebaseUser.uid).set(userDataMap);

      displayToastMessage(
          "Congratulations, your account has been created.", context);

      //save the stations in stations collection
      stations.forEach((element) {
        stationsBusRef.child(element.id).set({
          'name': element.name,
          'lat': element.lat,
          'lng': element.lng,
          'driverId': firebaseUser.uid,
          'routes':routeNameTextEditingController.text.trim(),
        });
      });

      setState(() {
        firebaseUserCurrent.value = firebaseUser;
        driverType.value = 'b';
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeDriverPage()));
      // Navigator.pushNamed(context, 'HomePageUser');
    } else {
      //error occured - display error msg
      displayToastMessage("New User Account Has Not Been Created.", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }

  Widget stationCard(Station station, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.deepPurpleAccent.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.deepPurpleAccent,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        station.name,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    stations.removeAt(index);
                    setState(() {});
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.red.shade800,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
