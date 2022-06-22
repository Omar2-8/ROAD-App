import 'dart:convert';

RideRequest rideRequestFromJson(String str) => RideRequest.fromJson(json.decode(str));

String rideRequestToJson(RideRequest data) => json.encode(data.toJson());

class RideRequest{
  String Rider_Name;
  String Rider_Phone;
  String Created_At;
  String Payment_Method;
  String Driver_ID;
  String PickUp_Lat;
  String PickUp_Lng;
  String DropOff_Lat;
  String DropOff_Lng;

  RideRequest({
    this.Rider_Name,this.Rider_Phone,this.Created_At,this.Payment_Method,this.Driver_ID,
    this.PickUp_Lat, this.PickUp_Lng,this.DropOff_Lat,this.DropOff_Lng
});

  factory RideRequest.fromJson(Map<String, dynamic> json) => RideRequest(
    Rider_Name: json["Rider_Name"] == null ? null : json["Rider_Name"],
    Rider_Phone: json["Rider_Phone"] == null ? null : json["Rider_Phone"],
    Created_At: json["Created_At"] == null ? null : json["Created_At"],
    Payment_Method: json["Payment_Method"] == null ? null : json["Payment_Method"],
    Driver_ID: json["Driver_ID"] == null ? null : json["Driver_ID"],
    PickUp_Lat: json["PickUp_Lat"] == null ? null : json["PickUp_Lat"],
    PickUp_Lng: json["PickUp_Lng"] == null ? null : json["PickUp_Lng"],
    DropOff_Lat: json["DropOff_Lat"] == null ? null : json["DropOff_Lat"],
    DropOff_Lng: json["DropOff_Lng"] == null ? null : json["DropOff_Lng"],
  );

  Map<String, dynamic> toJson() => {
    "Rider_Name": Rider_Name == null ? null : Rider_Name,
    "Rider_Phone": Rider_Phone == null ? null : Rider_Phone,
    "Created_At": Created_At == null ? null : Created_At,
    "Payment_Method": Payment_Method == null ? null : Payment_Method,
    "Driver_ID": Driver_ID == null ? null : Driver_ID,
    "PickUp_Lat": PickUp_Lat == null ? null : PickUp_Lat,
    "PickUp_Lng": PickUp_Lng == null ? null : PickUp_Lng,
    "DropOff_Lat": DropOff_Lat == null ? null : DropOff_Lat,
    "DropOff_Lng": DropOff_Lng == null ? null : DropOff_Lng,
  };
}