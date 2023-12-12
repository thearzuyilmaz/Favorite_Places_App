import 'package:favorite_places_app/providers/place_provider.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'dart:io';
import 'package:location/location.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPlaceScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _takenImage;
  PlaceLocation? _placeLocation;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Adding directly to the RiverPod Provider List
  void _savePlace() {
    final newPlace = Place(
        title: _titleController.text,
        image: _takenImage!,
        placeLocation: _placeLocation);

    if (_titleController.text.isEmpty ||
        _takenImage == null ||
        _placeLocation == null) {
      return;
    }

    // .notifier is needed to reach to the addToFavorites method of provider
    ref.read(placeProvider.notifier).addPlace(newPlace);

    Navigator.of(context).pop();
  }

  void saveImage(File? inputImage) {
    _takenImage = inputImage;
  }

  void saveLocation(PlaceLocation inputLocation) {
    _placeLocation = inputLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Title'),
            controller: _titleController,
          ),
          const SizedBox(
            height: 16.0,
          ),
          ImageInput(transferImageBack: saveImage),
          const SizedBox(
            height: 16.0,
          ),
          LocationInput(transferLocationBack: saveLocation),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: _savePlace,
            label: const Text('Add Place'),
          )
        ]),
      ),
    );
  }
}
