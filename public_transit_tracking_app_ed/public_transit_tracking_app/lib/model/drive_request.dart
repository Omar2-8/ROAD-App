import 'dart:convert';

DriveRequest driveRequestFromJson(String str) => DriveRequest.fromJson(json.decode(str));

String driveRequestToJson(DriveRequest data) => json.encode(data.toJson());

class DriveRequest{
  String Driver_Name;
  String Driver_Phone;
  String Driver_ID;
  String Created_At;
  String currentPos_Lat;
  String currentPos_Lng;

  DriveRequest({
    this.Driver_Name,this.Driver_Phone,this.Driver_ID,this.Created_At,
    this.currentPos_Lat, this.currentPos_Lng,
  });

  factory DriveRequest.fromJson(Map<String, dynamic> json) => DriveRequest(
    Driver_Name: json["Driver_Name"] == null ? null : json["Driver_Name"],
    Driver_Phone: json["Driver_Phone"] == null ? null : json["Driver_Phone"],
    Driver_ID: json["Driver_ID"] == null ? null : json["Driver_ID"],
    Created_At: json["Created_At"] == null ? null : json["Created_At"],
    currentPos_Lat: json["currentPos_Lat"] == null ? null : json["currentPos_Lat"],
    currentPos_Lng: json["currentPos_Lng"] == null ? null : json["currentPos_Lng"],
  );

  Map<String, dynamic> toJson() => {
    "Driver_Name": Driver_Name == null ? null : Driver_Name,
    "Driver_Phone": Driver_Phone == null ? null : Driver_Phone,
    "Created_At": Created_At == null ? null : Created_At,
    "Driver_ID": Driver_ID == null ? null : Driver_ID,
    "currentPos_Lat": currentPos_Lat == null ? null : currentPos_Lat,
    "currentPos_Lng": currentPos_Lng == null ? null : currentPos_Lng,
  };
}