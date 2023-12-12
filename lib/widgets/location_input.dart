import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.transferLocationBack});

  final void Function(PlaceLocation location) transferLocationBack;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  final myMapsAPIKey = 'AIzaSyDkReGQ5LlRVm_PiTFkqdw-T6XP2u23pLc';

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lon = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lon&key=$myMapsAPIKey';
  }

  void _getCurrentLocation() async {
    Location location = Location(); // Location library

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$myMapsAPIKey');
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final address = decodedData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat!, longitude: lon!, address: address);
    });

    if (_pickedLocation == null) {
      return;
    }

    widget.transferLocationBack(_pickedLocation!);
  }

  void _getSelectedLocation() async {
    final userLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (userLocation == null) {
      return;
    }

    final lat = userLocation.latitude;
    final lon = userLocation.longitude;

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=$myMapsAPIKey');
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final address = decodedData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation =
          PlaceLocation(latitude: lat, longitude: lon, address: address);
    });

    widget.transferLocationBack(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text('No location selected',
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: Theme.of(context).colorScheme.primary));

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(50, 178, 96, 96),
              borderRadius: BorderRadius.circular(15.0),
            ),
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            child: previewContent,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              onPressed: _getCurrentLocation,
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              onPressed: _getSelectedLocation,
              label: const Text('Select on map'),
            ),
          ],
        ),
      ],
    );
  }
}
