import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:public_transit_tracking_app/DriverRegistration/bus_driver.dart';
import 'package:public_transit_tracking_app/DriverRegistration/taxi_driver.dart';

import '../get_started_page.dart';


class SignUpDriverPage extends StatefulWidget {
  @override
  _SignUpDriverPageState createState() => _SignUpDriverPageState();
}

class _SignUpDriverPageState extends State<SignUpDriverPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                //onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedPage(),)),
                //onPressed: () => Navigator.pushNamed(context, 'GetStartedPage'),
                //onPressed: () => Navigator.of(context).pop(),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedPage()))
              ),
              backgroundColor: Colors.deepPurpleAccent,
              title: Text(
                'Create Your Account',
                style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
              ),
              bottom: TabBar(
                indicatorWeight: 5,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon:Image.asset(
                      'assets/images/icons-bus.png',package:'public_transit_tracking_app',
                      width: 40, height: 30,
                    ),
                    text: 'Bus Driver',
                  ),
                  Tab(
                    icon:Image.asset(
                      'assets/images/icons-taxi.png',package:'public_transit_tracking_app',
                      width: 40, height: 30,
                    ),
                    text: 'Taxi Driver',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                BusDriverTab(),
                TaxiDriverTab(),
              ],
            ),
          ),
        ),
    );
  }
 }

