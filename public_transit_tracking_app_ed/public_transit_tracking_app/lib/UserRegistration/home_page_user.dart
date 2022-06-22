import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:public_transit_tracking_app/Assistants/assistantMethods.dart';
import 'package:public_transit_tracking_app/DataHandler/appData.dart';
import 'package:public_transit_tracking_app/Divider.dart';
import 'package:public_transit_tracking_app/DriverRegistration/home_driver_page.dart';
import 'package:public_transit_tracking_app/UserRegistration/log_in_user_page.dart';
import 'package:public_transit_tracking_app/UserRegistration/settings_user_page.dart';
import 'package:public_transit_tracking_app/model/directDetails.dart';
import 'package:public_transit_tracking_app/model/nearbyAvailableDrivers.dart';
import '../Assistants/geoFireAssistant.dart';
import 'package:public_transit_tracking_app/main.dart';
import 'package:public_transit_tracking_app/methodes.dart';
import 'package:public_transit_tracking_app/model/station_model.dart';
import 'package:public_transit_tracking_app/model/user_app.dart';

import 'package:google_maps_webservice/places.dart' as plac;
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart'as fgp;

import '../configMaps.dart';
import '../progressDialog.dart';
import 'noDriverAvailableDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageUser extends StatefulWidget {
  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Position currentPosition;
  var geoLocator = Geolocator();

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  int selectedType = 0; // 0: bus , 1: taxi
  BitmapDescriptor busIcon;
  BitmapDescriptor taxiIcon;

  bool drawerOpen = true;
  bool nearbyAvailableDriverKeysLoaded = false;

  DatabaseReference rideRequestRef;
  Set<Polyline> polylineSet = {};

  List<NearbyAvailableDrivers> availableDrivers;

  String state = "normal";
  StreamSubscription<Event> rideStreamSubscription;
  bool isRequestingPositionDetails = false;

  double bottomPaddingOfMap = 0;
  double rideDetailsContainerHeight = 0;
  double searchContainerHeight = 300.0;
  double driverDetailsContainerHeight = 0;
  double requestRideContainerHeight=0.0;
  double requestContainerHeight=0.0;
  DirectionDetails tripDirectionDetails;
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  String uName="";
  List<LatLng> pLineCoordinates = [];


  void displayRequestContainer(){
    setState(() {
      requestContainerHeight=230.0;
    });
  }
  void cancelRequestContainer(){
    setState(() {
      requestContainerHeight=0.0;
    });
  }

  void displayDriverDetailsContainer()
  {
    setState(() {
      requestRideContainerHeight = 0.0;
      rideDetailsContainerHeight = 0.0;
      bottomPaddingOfMap = 295.0;
      driverDetailsContainerHeight = 285.0;

    });
  }
  void displayRideRequestContainer(){
    setState(() {
      requestRideContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = true;
    });
    saveRideRequest();
  }
  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address :: " + address);

    initGeoFireListner();

    uName = userCurrentInfo.userName;

    AssistantMethods.retrieveHistoryInfo(context);
  }
  void cancelRideRequestContainer(){
    rideRequestRef.remove();
    setState(() {
      requestRideContainerHeight=0.0;
      state="normal";
    });
  }
  void displayRideDetailsContainer() async {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 340.0;
      bottomPaddingOfMap = 360.0;
      drawerOpen = false;
    });
  }
  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);

    print("This is Encoded Points ::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if(decodedPolyLinePointsResult.isNotEmpty)
    {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude  &&  pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
    {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my Location"),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
  void updateRideTimeToPickUpLoc(LatLng driverCurrentLocation) async
  {
    if(isRequestingPositionDetails == false)
    {}
      isRequestingPositionDetails = true;

      var positionUserLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
      var details = await AssistantMethods.obtainPlaceDirectionDetails(driverCurrentLocation, positionUserLatLng);
      if(details == null)
      {
        return;
      }
      setState(() {
        rideStatus = "Driver is Coming - " + details.durationText;
      });

      isRequestingPositionDetails = false;

  }

  void updateRideTimeToDropOffLoc(LatLng driverCurrentLocation) async
  {
    if(isRequestingPositionDetails == false)
    {}
      isRequestingPositionDetails = true;

      var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
      var dropOffUserLatLng = LatLng(dropOff.latitude, dropOff.longitude);

      var details = await AssistantMethods.obtainPlaceDirectionDetails(driverCurrentLocation, dropOffUserLatLng);
      if(details == null)
      {
        return;
      }
      setState(() {
        rideStatus = "Going to Destination - " + details.durationText;
      });

      isRequestingPositionDetails = false;

  }

  void saveRideRequest(){
    rideRequestRef = FirebaseDatabase.instance.reference().child("Ride Requests").push();
    Map pickUpLocMap = {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };
    Map dropOffLocMap ={
      "latitude": lat.toString(),
      "longitude": lng.toString(),
    };
    Map rideInfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": currentUser.value.username,
      "rider_phone": currentUser.value.phoneNumber,
     //"pickup_address": pickUp.placeName,
      //"dropoff_address": dropOff.placeName,
    };
    rideRequestRef.set(rideInfoMap);
    rideStreamSubscription = rideRequestRef.onValue.listen((event) async
    {
      if(event.snapshot.value == null) {
        return;
      }
      if(event.snapshot.value["car_details"] != null) {
        setState(() {
          carDetailsDriver = event.snapshot.value["car_details"].toString();
        });
      }
      if(event.snapshot.value["driver_name"] != null) {
        setState(() {
          driverName = event.snapshot.value["driver_name"].toString();
        });
      }
      if(event.snapshot.value["driver_phone"] != null) {
        setState(() {
          driverphone = event.snapshot.value["driver_phone"].toString();
        });
      }
      if(event.snapshot.value["driver_location"] != null) {
        double driverLat = double.parse(event.snapshot.value["driver_location"]["latitude"].toString());
        double driverLng = double.parse(event.snapshot.value["driver_location"]["longitude"].toString());
        LatLng driverCurrentLocation = LatLng(driverLat, driverLng);

        if(statusRide == "accepted")
        {
          updateRideTimeToPickUpLoc(driverCurrentLocation);
        }
        else if(statusRide == "onride")
        {
          updateRideTimeToDropOffLoc(driverCurrentLocation);
        }
        else if(statusRide == "arrived")
        {
          setState(() {
            rideStatus = "Driver has Arrived.";
          });
        }
      }
      if(event.snapshot.value["status"] != null) {
        statusRide = event.snapshot.value["status"].toString();
      }
      if(statusRide == "accepted") {
        displayDriverDetailsContainer();
        Geofire.stopListener();
        deleteGeofileMarkers();
      }
      if(statusRide == "ended") {
        if(event.snapshot.value["fares"] != null)
        {
          int fare = int.parse(event.snapshot.value["fares"].toString());
          var res = await showDialog(
            context: context,
            barrierDismissible: false, builder: (BuildContext context) {  },
           // builder: (BuildContext context)=> CollectFareDialog(paymentMethod: "cash", fareAmount: fare,),
          );

          String driverId="";
          if(res == "close")
          {
            if(event.snapshot.value["driver_id"] != null)
            {
              driverId = event.snapshot.value["driver_id"].toString();
            }

           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RatingScreen(driverId: driverId)));

            rideRequestRef.onDisconnect();
            rideRequestRef = null;
            rideStreamSubscription.cancel();
            rideStreamSubscription = null;
            resetApp();
          }
        }
      }
    });
  }


  void deleteGeofileMarkers() {
    setState(() {
      markersSet.removeWhere((element) => element.markerId.value.contains("driver"));
    });
  }
  resetApp() {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMap = 230.0;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();

      statusRide = "";
      driverName = "";
      driverphone = "";
      carDetailsDriver = "";
      rideStatus = "Driver is Coming";
      driverDetailsContainerHeight = 0.0;
    });

    locatePosition();
  }


  void lacatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // generateNearbyBusOrTaxiLocation();
  }

  // generateNearbyBusOrTaxiLocation(){
  //   setState(() {
  //     markers = <MarkerId, Marker>{};
  //   });
  //   for(int i =0 ; i<10; i++){
  //     final random = Random();
  //     double randomLat = currentPosition.latitude + random.nextDouble() * (currentPosition.latitude+.015 - currentPosition.latitude);
  //     double randomLng = currentPosition.longitude + random.nextDouble() * (currentPosition.longitude-.009 - currentPosition.longitude);
  //     print('$randomLat, $randomLng');
  //     _addMarker(LatLng(randomLat, randomLng));
  //   }
  // }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/icons-bus.png',
      package: 'public_transit_tracking_app',
    ).then((onValue) {
      busIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/icons-taxi.png',
      package: 'public_transit_tracking_app',
    ).then((onValue) {
      taxiIcon = onValue;
    });
    getUserInfo();
    super.initState();
  }

  ///TODO This new code for all Bus Stations
  List<Station> stations = [];

  //Marker in map for all stations
  Set<Marker> markers = new Set();

  ///GET my stations by stations id
  getBusStations() async {
    stations.clear();
    Map<String, Map> data = {};
    await stationsBusRef.onValue.listen((event) {
      data = Map<String, Map>.from(event.snapshot.value);
      data.forEach((key, value) {
        stations.add(Station.fromJson2(value, key));
        setState(() {
          setMarker();
        });
      });
      print("I FOR$stations");
    });
  }

  //Set marker
  setMarker() {
    markers.clear();
    print('STATION $stations');
    //set Marker for each station
    if (stations.length > 0)
      stations.forEach((element) async {
        print('Marker${element.name}');
        markers.add(Marker(
          //add second marker
          markerId: MarkerId(element.id),
          position: LatLng(double.parse(element.lat.toString()),
              double.parse(element.lng.toString())),
          //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: element.name,
            snippet: element.routes,
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
        setState(() {});
      });
  }

  // void _addMarker(LatLng latLng) {
  //   var markerIdVal = latLng.toJson().toString();
  //   final MarkerId markerId = MarkerId(latLng.toJson().toString());
  //
  //   // creating a new MARKER
  //   final Marker marker = Marker(
  //     markerId: markerId,
  //     position: LatLng(
  //       latLng.latitude ,
  //       latLng.longitude ,
  //     ),
  //     infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
  //    icon:selectedType==0?busIcon:taxiIcon
  //   );
  //
  //   setState(() {
  //     // adding a new marker to map
  //     markers[markerId] = marker;
  //
  //   });
  // }

  getUserInfo() async{
    usersRef
        .child(firebaseUserCurrent.value.uid)
        .once()
        .then((DataSnapshot snap) {
      Map<String, String> map = Map.from(snap.value);
      print('dataSnapshot : $map');
      setState(() {
        currentUser.value = UserApp.fromJson(map);
      });
    });
  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    //target: LatLng(31.955633, 35.851317),
    target: LatLng(31.9747, 35.9776),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Main Screen"),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: true,
              trafficEnabled: true,
              padding: EdgeInsets.only(bottom: 0),
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              zoomGesturesEnabled: true,
              markers: markers,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                lacatePosition();
              },
            ),
           // Lana Adel
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: requestContainerHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 16.0,
                      color: Colors.black,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.deepPurpleAccent,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child:  Row(
                            children: [
                              Image.asset('assets/images/icons-taxi.png', package: 'public_transit_tracking_app', height:70.0, width: 80.0,),
                              SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("CAR", style: TextStyle(fontSize:18.0,fontFamily: "Langer",)),
                                  //Text("CAR", style: TextStyle(fontSize:18.0,fontFamily: "Langer",))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black54,),
                            SizedBox(width: 20.0,),
                            Text("cash"),
                            SizedBox(width: 10.0,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16.0,),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: (){
                            cancelRequestContainer();
                            displayRideRequestContainer();
                            availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                            searchNearestDriver();
                          },
                          color: Colors.deepPurpleAccent,
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Request", style: TextStyle(fontSize:20.0,fontFamily: "Langer", fontWeight: FontWeight.bold, color: Colors.white),),
                                Icon(FontAwesomeIcons.taxi, color: Colors.white, size: 26.0,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 70,
                right: 1,
                child: InkWell(
                  onTap: () {
                    markers.clear();
                    //cancelRideRequestContainer();
                    cancelRequestContainer();
                    getBusStations();
                    setState(() {
                      selectedType = 0;
                    });
                    // generateNearbyBusOrTaxiLocation();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: selectedType == 0 ? Colors.blue : Colors.white,
                        shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/images/icons-bus.png',
                      package: 'public_transit_tracking_app',
                      height: 50,
                      width: 60,
                    ),
                  ),
                )),
            Positioned(
                top: 135,
                right: 1,
                child: InkWell(
                  onTap: () {
                    stations.clear();
                    markers.clear();
                    getUserInfo();
                    displayRequestContainer();
                    initGeoFireListner();

                    //availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                    //searchNearestDriver();
                    setState(() {
                      selectedType = 1;
                      state="requesting";
                    });
                    // generateNearbyBusOrTaxiLocation();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: selectedType == 1 ? Colors.blue : Colors.white,
                        shape: BoxShape.circle),
                    child: Image.asset(
                      'assets/images/icons-taxi.png',
                      package: 'public_transit_tracking_app',
                      height: 50,
                      width: 60,
                    ),
                  ),
                )),
            Positioned(
              top: 5,
              left: 15,
              right: 15,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsUserPage(),
                          ));
                    },
                    child: Icon(
                      Icons.sort,
                      size: 35,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        autoCompleteDialog();
                       },
                      child: TextField(
                        enabled: false,
                        decoration: new InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          fillColor: Colors.white.withOpacity(1),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(100)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 0, color: Colors.transparent),
                              borderRadius: BorderRadius.circular(100)),
                          //label: Text('Search'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50,),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
               child: Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16.0,
                        color: Colors.black54,
                        offset: Offset(0.7, 0.7),
                      ),],
                  ),
                  height: requestRideContainerHeight,
                  child:Column(
                    children: [
                      SizedBox(height: 30.0,),
                      SizedBox(
                          width: double.infinity,
                          child: ColorizeAnimatedTextKit(
                            // onTap: (){
                            //
                            // },
                            text: [
                              'Requesting a ride ..',
                              'Please wait ..',
                              'Finding a driver ..',
                            ],
                            textStyle: TextStyle(
                              fontSize: 40.0,
                              fontFamily:'Langer',
                            ),
                            colors: [
                              Colors.purple,
                              Colors.blue,
                              Colors.yellow,
                              Colors.red,
                            ],
                            textAlign: TextAlign.center,
                          )
                      ),
                      SizedBox(height: 22.0,),
                      InkWell(
                        onTap: (){
                          cancelRideRequestContainer();
                          setState(() {

                          });
                        },
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26.0),
                            border: Border.all(width: 2.0, color: Colors.black54),
                          ),
                          child: Icon(Icons.close, size: 40.0,),
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      Container(
                        width: double.infinity,
                        child: Text('Cancel Ride', textAlign: TextAlign.center, style: TextStyle(fontSize: 15.0,fontFamily: 'Langer'),),
                      ),
                    ],
                  ),
                ),
             ),

            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 16.0,
                      color: Colors.black54,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                height: driverDetailsContainerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(rideStatus, textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),),
                        ],
                      ),

                      SizedBox(height: 22.0,),

                      Divider(height: 2.0, thickness: 2.0,),

                      SizedBox(height: 22.0,),

                      Text(carDetailsDriver, style: TextStyle(color: Colors.grey),),

                      Text(driverName, style: TextStyle(fontSize: 20.0),),

                      SizedBox(height: 22.0,),

                      Divider(height: 2.0, thickness: 2.0,),

                      SizedBox(height: 22.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //call button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(24.0),
                              ),

                              onPressed: () async
                              {
                                launch(('tel://${driverphone}'));
                              },
                              color: Colors.black87,

                              child: Padding(
                                padding: EdgeInsets.all(17.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Call Driver   ", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                    Icon(Icons.call, color: Colors.white, size: 26.0,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
  var lat;
  var lng;
autoCompleteDialog() async {
  plac.GoogleMapsPlaces _places = plac.GoogleMapsPlaces(
    apiKey: 'AIzaSyA8FaWVRl9s4lR6FPsW694qJTLY7_b-whg',

  );
  plac.Prediction p = await fgp.PlacesAutocomplete.show(
      context: context,
      apiKey: 'AIzaSyA8FaWVRl9s4lR6FPsW694qJTLY7_b-whg',
      mode: fgp.Mode.overlay,
      types: [],
      language: "ar",
      components: [new plac.Component(plac.Component.country, "JO")]);
  if (p != null) {
    plac.PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(p.placeId);

    //var placeId = p.placeId;

    lat = detail.result.geometry.location.lat;
    lng = detail.result.geometry.location.lng;

    print(lat);
    print(lng);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15)));
  }
  _getPolyline();
}

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      mapKey,
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(lat, lng),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }


  void initGeoFireListner() {
    Geofire.initialize("availableDrivers");
    //comment
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 15).listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers = NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.nearByAvailableDriversList.add(nearbyAvailableDrivers);
            if(nearbyAvailableDriverKeysLoaded == true)
            {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers = NearbyAvailableDrivers();
            nearbyAvailableDrivers.key = map['key'];
            nearbyAvailableDrivers.latitude = map['latitude'];
            nearbyAvailableDrivers.longitude = map['longitude'];
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
    //comment
  }
  void updateAvailableDriversOnMap() {
    setState(() {
      markers.clear();
    });

    Set<Marker> tMakers = Set<Marker>();
    for(NearbyAvailableDrivers driver in GeoFireAssistant.nearByAvailableDriversList)
    {
      LatLng driverAvaiablePosition = LatLng(driver.latitude, driver.longitude);

      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverAvaiablePosition,
        //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        icon:taxiIcon,
        //rotation: AssistantMethods.createRandomNumber(360),
      );

      tMakers.add(marker);
    }
    setState(() {
      markers = tMakers;
    });
  }

  void createIconMarker() {
    if(taxiIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/icons-taxi.png', package: 'public_transit_tracking_app',).then((value)
      {
        taxiIcon = value;
      });
    }
  }

  void noDriverFound()
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => NoDriverAvailableDialog()
    );
  }
  void searchNearestDriver() {
    if(availableDrivers.length == 0)
    {
      cancelRideRequestContainer();
      resetApp();
     noDriverFound();
      return;
    }

    var driver = availableDrivers[0];
    notifyDriver(driver);
    availableDrivers.removeAt(0);

    // driversRef.child(driver.key).child("car_details").child("type").once().then((DataSnapshot snap) async
    // {
    //   if(await snap.value != null)
    //   {
    //     String carType = snap.value.toString();
    //     if(carType == carRideType)
    //     {
    //
    //       availableDrivers.removeAt(0);
    //     }
    //     else
    //     {
    //       displayToastMessage(carRideType + " drivers not available. Try again.", context);
    //     }
    //   }
    //   else
    //   {
    //     displayToastMessage("No car found. Try again.", context);
    //   }
    // });
  }
  void notifyDriver(NearbyAvailableDrivers driver)
  {
    taxiDriversRef.child(driver.key).child("newRide").set(rideRequestRef.key);

    taxiDriversRef.child(driver.key).child("token").once().then((DataSnapshot snap){
      if(snap.value != null)
      {
        String token = snap.value.toString();
        AssistantMethods.sendNotificationToDriver(token, context, rideRequestRef.key);
      }
      else
      {
        return;
      }

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
      driverRequestTimeOut = driverRequestTimeOut - 1;

      taxiDriversRef.child(driver.key).child("newRide").onValue.listen((event) {

          if(event.snapshot.value.toString() == "accepted")
          {
            taxiDriversRef.child(driver.key).child("newRide").onDisconnect();
            driverRequestTimeOut = 40;
            timer.cancel();
          }
        });
      if(state != "requesting")
      {
        taxiDriversRef.child(driver.key).child("newRide").set("cancelled");
        taxiDriversRef.child(driver.key).child("newRide").onDisconnect();
        driverRequestTimeOut = 40;
        timer.cancel();
      }
        if(driverRequestTimeOut == 0)
        {
          taxiDriversRef.child(driver.key).child("newRide").set("timeout");
          taxiDriversRef.child(driver.key).child("newRide").onDisconnect();
          driverRequestTimeOut = 40;
          timer.cancel();

          searchNearestDriver();
        }

      });
    });
  }


}

