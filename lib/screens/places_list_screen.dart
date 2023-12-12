import 'package:favorite_places_app/providers/place_provider.dart';
import 'package:favorite_places_app/screens/add_place_screen.dart';
import 'package:favorite_places_app/widgets/places_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlacesListScreen> createState() {
    return _PlacesListScreenState();
  }
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _placesFuture = ref.read(placeProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(placeProvider); //provider

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
      body: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : PlacesList(places: userPlaces)),
    );
  }
}
