import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';

Future<Database> _getDatabase() async {
  final dbPath = await sql
      .getDatabasesPath(); // gets the path to the directory where databases can be stored on the device
  // OPENS or CREATES an SQLite database and defines a table named user_places "if it doesn't exist."
  final db = await sql.openDatabase(
    path.join(
        dbPath, 'places.db'), // specifies the full path to the SQLite database
    onCreate: (db, version) {
      // callback is invoked if the database does not exist.
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

// Notifier
class PlaceNotifier extends StateNotifier<List<Place>> {
  PlaceNotifier() : super([]);

  // Retrieves places from the SQLite database and updates the state with a list of Place objects
  Future<void> loadPlaces() async {
    final db = await _getDatabase(); // loading database
    final data = await db.query('user_places');
    // to convert every list item (rows) to different item, [row1, row2, row3...], each row is a map
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String), // import 'dart:io';
            placeLocation: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();

    state = places;
  }

  // Adds a new place to the database and updates the state with the new place.
  // Updating the state after inserting data into the database is a common approach in Flutter applications.
  // It allows you to reflect the changes immediately in the user interface.
  // add & remove methods are not supported by the riverpod package!!!!!
  // For example, if you have a list of places displayed in your app, updating the state triggers a rebuild of the UI,
  // and the new place is displayed without needing to fetch the data again from the database.
  // If you choose not to update the state immediately, make sure to handle state updates appropriately elsewhere in your application
  // to keep it in sync with the data stored in the database.
  void addPlace(Place place) async {
    // storing image locally
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$filename');

    place.image = copiedImage; // assigning new copied image

    final db = await _getDatabase(); // creating database

    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.placeLocation?.latitude,
      'lng': place.placeLocation?.longitude,
      'address': place.placeLocation?.address,
    });

    state = [
      ...state,
      place
    ]; // Updates the state by adding the new place to the existing list.
  }
}

// Provider
final placeProvider = StateNotifierProvider<PlaceNotifier, List<Place>>(
  (ref) => PlaceNotifier(),
);
