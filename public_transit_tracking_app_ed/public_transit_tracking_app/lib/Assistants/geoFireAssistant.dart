import 'package:public_transit_tracking_app/model/directDetails.dart';
import 'package:public_transit_tracking_app/model/nearbyAvailableDrivers.dart';

class GeoFireAssistant
{
  static List<NearbyAvailableDrivers> nearByAvailableDriversList = [];

  static void removeDriverFromList(String key)
  {
    int index = nearByAvailableDriversList.indexWhere((element) => element.key == key);
    nearByAvailableDriversList.removeAt(index);
  }

  static void updateDriverNearbyLocation(NearbyAvailableDrivers driver)
  {
    int index = nearByAvailableDriversList.indexWhere((element) => element.key == driver.key);

    nearByAvailableDriversList[index].latitude = driver.latitude;
    nearByAvailableDriversList[index].longitude = driver.longitude;
  }
  // static int calculateFares(DirectionDetails directionDetails)
  // {
  //   //in terms USD
  //   double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
  //   double distancTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
  //   double totalFareAmount = timeTraveledFare + distancTraveledFare;
  //
  //   //Local Currency
  //   //1$ = 160 RS
  //   //double totalLocalAmount = totalFareAmount * 160;
  //   if(rideType == "uber-x")
  //   {
  //     double result = (totalFareAmount.truncate()) * 2.0;
  //     return result.truncate();
  //   }
  //   else if(rideType == "uber-go")
  //   {
  //     return totalFareAmount.truncate();
  //   }
  //   else if(rideType == "bike")
  //   {
  //     double result = (totalFareAmount.truncate()) / 2.0;
  //     return result.truncate();
  //   }
  //   else
  //   {
  //     return totalFareAmount.truncate();
  //   }
  // }

  // static void disableHomeTabLiveLocationUpdates()
  // {
  //   homeTabPageStreamSubscription.pause();
  //   Geofire.removeLocation(currentfirebaseUser.uid);
  // }

}