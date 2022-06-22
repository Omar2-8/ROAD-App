import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:public_transit_tracking_app/Assistants/assistantMethods.dart';
import 'package:public_transit_tracking_app/UserRegistration/NewRideScreen.dart';

import 'package:public_transit_tracking_app/model/rideDetails.dart';

import '../main.dart';

class NotificationDialog extends StatelessWidget {

  final RideDetails rideDetails;

  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.0),
            Image.asset('assets/images/icons-taxi.png', package: 'public_transit_tracking_app', width: 120.0,),
            SizedBox(height: 18.0,),
            Text("New Ride Request", style: TextStyle(fontFamily: "Langer", fontSize: 18.0,),),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   //   Image.asset('assets/images/pickup.png', package:'public_transit_tracking_app', height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child: Container(child: Text(rideDetails.rider_name, style: TextStyle(fontSize: 18.0),)),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     // Image.asset('assets/images/destination.png', package:'public_transit_tracking_app', height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                          child: Container(child: Text(rideDetails.rider_phone, style: TextStyle(fontSize: 18.0),))
                      ),
                    ],
                  ),
                  SizedBox(height:15.0),

                ],
              ),
            ),

            SizedBox(height: 20.0),
            Divider(height: 2.0, color:Colors.black, thickness: 2.0,),
            SizedBox(height: 8.0),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8.0),
                    onPressed: ()
                    {
                      //assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  SizedBox(width: 10.0),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    onPressed: ()
                    {
                      // assetsAudioPlayer.stop();
                      checkAvailabilityOfRide(context);
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Accept".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),

                ],
              ),
            ),

            SizedBox(height: 0.0),
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context) {
    rideRequestRef.once().then((DataSnapshot dataSnapShot){
      Navigator.pop(context);
      String theRideId = "";
      if(dataSnapShot.value != null)
      {
        theRideId = dataSnapShot.value.toString();
      }
      else
      {
        displayToastMessage("Ride not exists.", context);
      }

      if(theRideId == rideDetails.ride_request_id)
      {

        rideRequestRef.set("accepted");
        AssistantMethods.disableHomeTabLiveLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NewRideScreen(rideDetails: rideDetails) ));
      }
      else if(theRideId == "cancelled")
      {
        displayToastMessage("Ride has been Cancelled.", context);
      }
      else if(theRideId == "timeout")
      {
        displayToastMessage("Ride has time out.", context);
      }
      else
      {
        displayToastMessage("Ride not exists.", context);
      }
    });
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
