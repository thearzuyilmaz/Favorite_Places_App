import 'package:favorite_places_app/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';
import '../screens/add_place_screen.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
            label: const Text('Add the First One')),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => PlaceDetailScreen(
                    place: places[index],
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              radius: 16,
              backgroundImage: FileImage(places[index].image),
            ),
            title: Text(
              places[index].title,
            ),
            subtitle: Text(
              places[index].placeLocation!.address!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          );
        },
      ),
    );
  }
}
