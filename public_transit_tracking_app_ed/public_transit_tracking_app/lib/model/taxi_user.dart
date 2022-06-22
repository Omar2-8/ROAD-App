
import 'dart:convert';

TaxiUser taxiUserFromJson(String str) => TaxiUser.fromJson(json.decode(str));

String taxiUserToJson(TaxiUser data) => json.encode(data.toJson());

class TaxiUser {
  TaxiUser({
    this.email,
    this.phoneNumber,
    this.userName,
    this.vehicleNumber,
    this.latCurrentPos,
    this.lngCurrentPos,
    this.token,
  });

  String email;
  String phoneNumber;
  String userName;
  String vehicleNumber;
  String latCurrentPos;
  String lngCurrentPos;
  String token;

  factory TaxiUser.fromJson(Map<String, dynamic> json) => TaxiUser(
    email: json["Email"] == null ? null : json["Email"],
    phoneNumber: '${json["PhoneNumber"]}' == null ? null : json["PhoneNumber"],
    userName: '${json["UserName"]}' == null ? null : json["UserName"],
    vehicleNumber: '${json["VehicleNumber"]}' == null ? null : '${json["VehicleNumber"]}',
    latCurrentPos: '${json["latCurrentPos"]}' == null ? null : '${json["latCurrentPos"]}',
    lngCurrentPos: '${json["lngCurrentPos"]}' == null ? null : '${json["lngCurrentPos"]}',
    token: '${json["Token"]}' == null ? null : '${json["Token"]}',
  );

  Map<String, dynamic> toJson() => {
    "Email": email == null ? null : email,
    "PhoneNumber": phoneNumber == null ? null : phoneNumber,
    "UserName": userName == null ? null : userName,
    "VehicleNumber": vehicleNumber == null ? null : vehicleNumber,
    "latCurrentPos": latCurrentPos == null ? null : latCurrentPos,
    "lngCurrentPos": lngCurrentPos == null ? null : lngCurrentPos,
    "Token": token == null ? null : token,
  };
}
