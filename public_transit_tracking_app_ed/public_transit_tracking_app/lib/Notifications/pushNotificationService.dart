
import 'dart:io' show Platform;
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:public_transit_tracking_app/UserRegistration/log_in_user_page.dart';
import 'package:public_transit_tracking_app/model/rideDetails.dart';

import '../main.dart';
import 'NotificationDialog.dart';

class PushNotificationService {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future initialize(context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        retrieveRideRequestInfo(getRideRequestId(message),context);
            //getRideRequestId(message);
         flutterLocalNotificationsPlugin.show(
            notification.hashCode,
             notification.title,
             notification.body,
             NotificationDetails(
              android: AndroidNotificationDetails(
                 //channel.id,
                 channel.name,
                channel.description,
                color: Colors.deepPurpleAccent,
                playSound: true,
              ),
      )
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen(((RemoteMessage message) {
       print('A new onMessageOpenedApp event was published!');
       RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        getRideRequestId(message);
         showDialog(
             builder: (_) {
               return AlertDialog(
                 title: Text(notification.title),
                 content: SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(notification.body),
                     ],
                   ),
                 ),
               );
             }, context: null
         );

      }
    }));

  }

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    print("This is token :: ");
    print(token);
    taxiDriversRef.child(firebaseUserCurrent.value.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
    return token;
  }

  // String getRideRequestId(Map<String, dynamic> message) {
  //   String rideRequestId = "";
  //
  //   if (Platform.isAndroid) {
  //     rideRequestId = message['data']['ride_request_id'];
  //   } else {
  //     rideRequestId = message['ride_request_id'];
  //   }
  //   return rideRequestId;
  // }
  String getRideRequestId(RemoteMessage message)
  {
    String rideRequestId = rideRequestRef.key;
    if(Platform.isAndroid)
    {

      rideRequestId = message.data['ride_request_id'] ; //message['data']['ride_request_id'];
    }
    else
    {
      rideRequestId = message.data['ride_request_id'];
    }
return rideRequestId;

  }




  void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
    newRequestsRef.child(rideRequestId).once().then((DataSnapshot dataSnapShot){
      if(dataSnapShot.value != null) {}
        double pickUpLocationLat = double.parse(dataSnapShot.value['pickup']['latitude'].toString());
        double pickUpLocationLng = double.parse(dataSnapShot.value['pickup']['longitude'].toString());
        String pickUpAddress = dataSnapShot.value['pickup'].toString();

        double dropOffLocationLat = double.parse(dataSnapShot.value['dropoff']['latitude'].toString());
        double dropOffLocationLng = double.parse(dataSnapShot.value['dropoff']['longitude'].toString());
        String dropOffAddress = dataSnapShot.value['dropoff'].toString();

        String paymentMethod = dataSnapShot.value['payment_method'].toString();

        String rider_name = dataSnapShot.value["rider_name"];
        String rider_phone = dataSnapShot.value["rider_phone"];


        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickUpAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = rider_name;
        rideDetails.rider_phone = rider_phone;

        print("Information :: ");
        print(rideDetails.pickup_address);
        print(rideDetails.dropoff_address);
        print(rideDetails.rider_name);
        print(rideDetails.rider_phone);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              NotificationDialog(rideDetails: rideDetails,),
        );
       });
  }
  // void showNotification(){
  //   flutterLocalNotificationsPlugin.show(
  //     0,
  //     "Testing",
  //     "How you doing ?",
  //     NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.name,
  //           channel.description,
  //           importance: Importance.high,
  //           color: Colors.deepPurpleAccent,
  //           playSound: true,
  //         )
  //     ),
  //   );
  // }

}
