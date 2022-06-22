import 'package:firebase_database/firebase_database.dart';

class Station {
  String id, name, lat, lng, driverId, routes;

  Station({this.id, this.name, this.lat, this.lng, this.driverId, this.routes});

  factory Station.fromJson(DataSnapshot json) => Station(
        id: json.key,
        name: json.value['name'],
        driverId: json.value['driverId'],
        lng: json.value['lng'],
        lat: json.value['lat'],
        routes: json.value['routes'],
      );

  factory Station.fromJson2(Map<dynamic, dynamic> json, String key) => Station(
        id: key,
        name: json['name'],
        driverId: json['driverId'],
        lng: json['lng'],
        lat: json['lat'],
        routes: json['routes'],
      );
}
