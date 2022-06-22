import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import 'model/signUpTaxiDriver.dart';
import 'model/taxi_user.dart';

String mapKey = "AIzaSyA8FaWVRl9s4lR6FPsW694qJTLY7_b-whg";

User firebaseUser;

User currentfirebaseUser;
TaxiUser userCurrentInfo;

StreamSubscription<Position> homeDriverBageStreamSubscription;
StreamSubscription<Position> homeTabPageStreamSubscription;
StreamSubscription<Position> rideStreamSubscription;

int driverRequestTimeOut = 40;
String statusRide = "";
String rideStatus = "Driver is Coming";
String carDetailsDriver = "";
String driverName = "";
String driverphone = "";

Position currentPosition;

signUpTaxiDriver driversInformation;

String serverToken ="key=AAAAFint98I:APA91bFvV4X46d8EreSpGegFtTHVCPMSOY7I-tX-2c-w-qQOOXBBHg7F6XzMHXkpDL1foH5UF19y1fAmj5DwJCBl8nQr5W1PE22-bGQe7vU4wmTGCffgN_riJAO8-cvr9e_oo0monr5G";
String rideType="";