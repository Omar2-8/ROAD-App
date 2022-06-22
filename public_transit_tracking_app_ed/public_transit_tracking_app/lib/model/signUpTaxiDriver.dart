import 'package:firebase_database/firebase_database.dart';

class signUpTaxiDriver
{
  String name;
  String phone;
  String email;
  String id;
  String VehicleNumber;


  signUpTaxiDriver({this.name, this.phone, this.email, this.id, this.VehicleNumber, });

  signUpTaxiDriver.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    phone = dataSnapshot.value["PhoneNumber"];
    email = dataSnapshot.value["Email"];
    name = dataSnapshot.value["UserName"];
    VehicleNumber = dataSnapshot.value["VehicleNumber"];

  }
}