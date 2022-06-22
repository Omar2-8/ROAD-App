import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'DriverRegistration/bus_driver.dart';
import 'DriverRegistration/sign_up_driver_page.dart';
import 'DriverRegistration/taxi_driver.dart';
import 'UserRegistration/log_in_user_page.dart';
import 'UserRegistration/settings_user_page.dart';
import 'UserRegistration/sign_up_user_page.dart';
import 'configMaps.dart';
import 'get_started_page.dart';
import 'UserRegistration/home_page_user.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications' // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print('A bg message just showed up : ${message.messageId}');
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //currentfirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("signUpUser");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("signUpdriver");
DatabaseReference taxiDriversRef = FirebaseDatabase.instance.reference().child("signUpTaxiDriver");
DatabaseReference busDriversRef = FirebaseDatabase.instance.reference().child("signUpBusDriver");
DatabaseReference stationsBusRef = FirebaseDatabase.instance.reference().child("stationsBus");
DatabaseReference newRequestsRef = FirebaseDatabase.instance.reference().child("Ride Requests");
DatabaseReference rideRequestRef = FirebaseDatabase.instance.reference().child("signUpTaxiDriver").child(firebaseUserCurrent.value.uid).child("newRide");
DatabaseReference availableDriversRef=FirebaseDatabase.instance.reference().child("availableDrivers");
ValueNotifier<String> driverType=ValueNotifier('n');

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState(){
    super.initState();
  }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'GetStartedPage',
        //initialRoute: 'HomePageUser',
        //initialRoute: 'SettingsUserPage',
        routes: {
          'GetStartedPage': (context) => GetStartedPage(),
          'LoginUserPage': (context) => LoginUserPage(),
          'SignUpUserPage': (context) => SignUpUserPage(),
          'SignUpDriverPage': (context) => SignUpDriverPage(),
          'TaxiDriverTab': (context) => TaxiDriverTab(),
          'BusDriverTab': (context) => BusDriverTab(),
          'HomePageUser': (context) => HomePageUser(),
          'SettingsUserPage': (context) => SettingsUserPage(),
        },
      );
    }
}







