import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:public_transit_tracking_app/Notifications/pushNotificationService.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transit_tracking_app/Assistants/geoFireAssistant.dart';
import 'package:public_transit_tracking_app/UserRegistration/log_in_user_page.dart';
import 'package:public_transit_tracking_app/main.dart';
import 'package:public_transit_tracking_app/model/bus_user.dart';
import 'package:public_transit_tracking_app/DriverRegistration/settings_driver_page.dart';
import 'package:public_transit_tracking_app/model/signUpTaxiDriver.dart';
import 'package:public_transit_tracking_app/model/station_model.dart';
import 'package:public_transit_tracking_app/model/taxi_user.dart';


import '../configMaps.dart';


class HomeDriverPage extends StatefulWidget {
  @override
  _HomeDriverPageState createState() => _HomeDriverPageState();
}

class _HomeDriverPageState extends State<HomeDriverPage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Position currentPosition;
  var geoLocator = Geolocator();

  double DriveronlineAndOfflinePanel = 0;
  String driverStatus = "Offline Now - Go Online ";
  Color driverStatusColor = Colors.black;
  bool isDriverAvailable = false;

  BitmapDescriptor taxiIcon;


  void lacatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }


  Set<Marker> markers = new Set();
  List<Station> stations = [];
  bool loading = true;


  @override
  void initState() {
    getUserInfo();
    getCurrentDriverInfo();
    super.initState();
  }

  void getCurrentDriverInfo() async
  {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser;

    taxiDriversRef.child(currentfirebaseUser.uid).once().then((DataSnapshot dataSnapShot){
      if(dataSnapShot.value != null)
      {
        driversInformation = signUpTaxiDriver.fromSnapshot(dataSnapShot);
      }
    });

    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    pushNotificationService.getToken();

   //AssistantMethods.retrieveHistoryInfo(context);
    //getRatings();
    //getRideType();
  }
  getUserInfo() async {
    print('driver type ${driverType.value}');
    switch (driverType.value) {
      case 'b':
        await busDriversRef
            .child(firebaseUserCurrent.value.uid)
            .once()
            .then((DataSnapshot snap) async {
          print(snap.value);
          // Map<String, String> map = Map.from(snap.value);
          // print('dataSnapshot : $map');
          currentBusUser.value = BusUser.fromJson(snap);
        });
        await getMyStations(currentBusUser.value.myStationsId).then((s) async {
          await setMarker();
        });
        setState(() {});
        break;
      case 't':
        taxiDriversRef
            .child(firebaseUserCurrent.value.uid)
            .once()
            .then((DataSnapshot snap) {
          Map<String, dynamic> map = Map.from(snap.value);
          print('dataSnapshot : $map');
          setState(() {
            currentTaxiUser.value = TaxiUser.fromJson(map);
            DriveronlineAndOfflinePanel = 140.0;
          });
        });

        PushNotificationService pushNotificationService = PushNotificationService();
        pushNotificationService.initialize(context);
        pushNotificationService.getToken();
        break;
    }
  }

  ///GET my stations by stations id
  getMyStations(List<dynamic> stationsId) async {
    stations.clear();
    stationsId.forEach((element) async {
      var value = await stationsBusRef.child(element.toString()).once();
      stations.add(Station.fromJson(value));
      print("I FOR $stations");
      setState(() {
        setMarker();
      });
    });
  }

  setMarker() {
    markers.clear();
    print('STATION $stations');
    //set Marker for each station
    stations.forEach((element) async {
      print('Marker${element.name}');
      markers.add(Marker(
        //add second marker
        markerId: MarkerId(element.id),
        position: LatLng(double.parse(element.lat), double.parse(element.lng)),
        //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: element.name,
          snippet: element.id,
        ),
        icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(
            size: Size(15, 15),
          ),
          'assets/images/icons-bus.png',
          package: 'public_transit_tracking_app',
        ),
        //Icon for Marker
      ));
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    //target: LatLng(31.955633, 35.851317),
    target: LatLng(31.9758, 35.9787),
    //target: LatLng(31.9764, 35.9808),
    //target: LatLng(31.9744, 35.9802),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              markers: markers,
              padding: EdgeInsets.only(bottom: 0),
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                lacatePosition();
              },
              // markers: Marker(markerId: ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                color: Colors.deepPurpleAccent,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsDriverPage(),
                              ));
                        },
                        child: Icon(
                          Icons.sort,
                          size: 35,
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        driverType.value == 't'
                            ? 'assets/images/icons-taxi.png'
                            : 'assets/images/icons-bus.png',
                        package: 'public_transit_tracking_app',
                        height: 100,
                        width: 100,
                      ),
                    )
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: DriveronlineAndOfflinePanel,
                width: double.infinity,
                color: Colors.black54,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: RaisedButton(
                      onPressed: (){
                        if(isDriverAvailable != true){

                          makeDriverOnlineNow();
                          getLocationLiveUpdates();

                          setState(() {
                            driverStatusColor = Colors.deepPurpleAccent;
                            driverStatus = "Online Now";
                            isDriverAvailable = true;
                          });
                          displayToastMessage("You Are Online Now.", context);
                        }
                        else{
                          makeDriverOfflineNow();
                          setState(() {
                            driverStatusColor = Colors.black;
                            driverStatus = "Offline Now - Go Online ";
                            isDriverAvailable = false;
                          });
                          displayToastMessage("You Are Offline Now.", context);
                        }
                      },
                      color: driverStatusColor,
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(driverStatus,style: TextStyle(fontSize:20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                            Icon(Icons.phone_android,color: Colors.white,size: 26.0,),
                          ],
                        ),
                      ),
                    ),
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
  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(firebaseUserCurrent.value.uid, currentPosition.latitude, currentPosition.longitude);

    rideRequestRef.set("searching");
    rideRequestRef.onValue.listen((event) {

    });
  }
  void getLocationLiveUpdates(){
    homeDriverBageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      if(isDriverAvailable == true)
      {
        Geofire.setLocation(firebaseUserCurrent.value.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
  void makeDriverOfflineNow(){
    Geofire.removeLocation(firebaseUserCurrent.value.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    rideRequestRef=null;
  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}

