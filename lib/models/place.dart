import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:location/location.dart';

const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  Place({required this.title, required this.image, required this.placeLocation})
      : id = uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation? placeLocation;
}
