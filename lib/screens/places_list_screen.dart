import 'package:favorite_places_app/providers/favorites_provider.dart';
import 'package:favorite_places_app/screens/add_place_screen.dart';
import 'package:favorite_places_app/widgets/places_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _favoritePlaces = ref.watch(favoritePlaceProvider); //provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PlacesList(
        places: _favoritePlaces,
      ),
    );
  }
}
