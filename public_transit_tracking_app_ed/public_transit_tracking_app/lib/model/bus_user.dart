import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

BusUser busUserFromJson(String str) => BusUser.fromJson(json.decode(str));

String busUserToJson(BusUser data) => json.encode(data.toJson());

class BusUser {
  BusUser({
    this.email,
    this.phoneNumber,
    this.routeName,
    this.userName,
    this.vehicleNumber,this.myStationsId,
  });

  String email;
  String phoneNumber;
  String routeName;
  String userName;
  String vehicleNumber;
  List<dynamic> myStationsId;

  factory BusUser.fromJson(DataSnapshot json) => BusUser(
    email: json.value["Email"] == null ? null : json.value["Email"],
    phoneNumber: json.value["PhoneNumber"] == null ? null : json.value["PhoneNumber"],
    routeName: json.value["RouteName"] == null ? null : json.value["RouteName"],
    userName: json.value["UserName"] == null ? null : json.value["UserName"],
    vehicleNumber: json.value["VehicleNumber"] == null ? null : json.value["VehicleNumber"],
    myStationsId: json.value["Stations"] == null ? null : json.value["Stations"],
  );

  Map<String, dynamic> toJson() => {
    "Email": email == null ? null : email,
    "PhoneNumber": phoneNumber == null ? null : phoneNumber,
    "RouteName": routeName == null ? null : routeName,
    "UserName": userName == null ? null : userName,
    "VehicleNumber": vehicleNumber == null ? null : vehicleNumber,
    "Stations": myStationsId == null ? null : myStationsId,
  };
}
