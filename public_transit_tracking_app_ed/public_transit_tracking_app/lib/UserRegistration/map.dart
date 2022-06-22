// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart' as fgp;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart' as plac;
//
//
// class AddDeliveryAddressBottomSheet extends StatefulWidget {
//   final BuildContext buildContext;
//   final String flag;
//   final int resId;
//   final double subtotal;
//
//   AddDeliveryAddressBottomSheet(
//       {this.buildContext, this.flag, this.resId, this.subtotal});
//
//   _AddDeliveryAddressBottomSheetState createState() =>
//       _AddDeliveryAddressBottomSheetState(buildContext);
// }
//
// class _AddDeliveryAddressBottomSheetState
//     extends State<AddDeliveryAddressBottomSheet> {
//   final BuildContext buildContext;
//
//   bool isLoading = false;
//   bool isCameraPosition = true;
//   Completer<GoogleMapController> _controller1 = Completer();
//
//   _AddDeliveryAddressBottomSheetState(this.buildContext);
//
//   GoogleMapController _controller;
//   Location _location = Location();
//   LatLng _lastMapPosition;
//
//   void _onMapCreated(GoogleMapController _contr) {
//     _controller = _contr;
//     _location.onLocationChanged.listen((currentLocation) {
//       if (isCameraPosition) {
//         _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//             target: LatLng(currentLocation.latitude, currentLocation.longitude),
//             zoom: 15)));
//         isCameraPosition = false;
//       }
//     });
//   }
//
//   void _onCameraMove(CameraPosition position) {
//     _lastMapPosition = position.target;
//   }
//
//   static final CameraPosition _centerUS =
//   CameraPosition(target: LatLng(41.500000, -100.000000), zoom: 3);
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Column(
//         children: [
//           SizedBox(
//             height: 40,
//           ),
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: Stack(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Add Address',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontSize: 20),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerRight,
//                   child: InkWell(
//                     onTap: () {
//                       autoCompleteDialog();
//                     },
//                     child: Icon(
//                       Icons.search,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: Card(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(23),
//                       topLeft: Radius.circular(23))),
//               margin: EdgeInsets.all(0),
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 0.0),
//                 child: isLoading
//                     ? Container(
//                   color: Colors.white,
//                   height: double.infinity,
//                   child: Center(
//                     child: Container(
//                       width: 50,
//                       height: 50,
//                       child: CircularProgressIndicator(
//                         backgroundColor: Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ),
//                 )
//                     : Stack(
//                   children: [
//                     Center(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(23),
//                           topRight: Radius.circular(23),
//                         ),
//                         child: GoogleMap(
//                           // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/2),
//
//                           mapType: MapType.normal,
//                           initialCameraPosition: _centerUS,
//                           onMapCreated: _onMapCreated,
//                           myLocationEnabled: true,
//                           onCameraMove: _onCameraMove,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 24),
//                         child: Icon(
//                           Icons.location_on,
//                           color: Colors.red,
//                           size: 32,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.bottomCenter,
//                       child: Padding(
//                         padding: EdgeInsets.only(bottom: 25.0),
//                         child: SizedBox(
//                           height: 50,
//                           child: RaisedButton(
//                             onPressed: () {
//
//                             },
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 40),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             color: Theme.of(context).primaryColor,
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment:
//                               MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Add Address",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 18),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   autoCompleteDialog() async {
//     plac.GoogleMapsPlaces _places =
//     plac.GoogleMapsPlaces(apiKey: '');
//     plac.Prediction p = await fgp.PlacesAutocomplete.show(
//         context: context,
//         apiKey: '',
//         mode: fgp.Mode.overlay,
//         // Mode.fullscreen
//         language: "ar",
//         components: [new plac.Component(plac.Component.country, "JO")]);
//     if(p!=null){
//       plac.PlacesDetailsResponse detail =
//       await _places.getDetailsByPlaceId(p.placeId);
//       var lat = detail.result.geometry.location.lat;
//       var lng = detail.result.geometry.location.lng;
//       _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target: LatLng(lat,lng),
//           zoom: 15)));}
//   }
// }