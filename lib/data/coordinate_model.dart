import 'dart:convert';

import 'package:latlong2/latlong.dart';

List<HouseCoordinate> houseCoordinateFromJson(String str) => List<HouseCoordinate>.from(json.decode(str).map((x) => HouseCoordinate.fromJson(x)));


class HouseCoordinate {
  HouseCoordinate(this.latLng);

  final LatLng latLng;

  factory HouseCoordinate.fromJson(Map<String, dynamic> json) {
    double lat = double.parse(json["lat"]);
    double lon = double.parse(json["lon"]);
    return HouseCoordinate(LatLng(lat, lon));
  }

}
