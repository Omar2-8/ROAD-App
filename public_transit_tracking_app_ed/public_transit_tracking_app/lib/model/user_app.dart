import 'dart:convert';

UserApp userAppFromJson(String str) => UserApp.fromJson(json.decode(str));

String userAppToJson(UserApp data) => json.encode(data.toJson());

class UserApp {
  UserApp({
    this.email,
    this.phoneNumber,
    this.username,
  });

  String email;
  String phoneNumber;
  String username;

  factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
    email: json["Email"] == null ? null : json["Email"],
    phoneNumber: json["PhoneNumber"] == null ? null : json["PhoneNumber"],
    username: json["UserName"] == null ? null : json["UserName"],
  );

  Map<String, dynamic> toJson() => {
    "Email": email == null ? null : email,
    "PhoneNumber": phoneNumber == null ? null : phoneNumber,
    "UserName": username == null ? null : username,
  };
}
