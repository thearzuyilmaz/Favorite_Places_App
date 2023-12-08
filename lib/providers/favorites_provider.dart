import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier
class FavoritePlaceNotifier extends StateNotifier<List<Place>> {
  FavoritePlaceNotifier() : super([]);

  // add & remove methods are not supported by the riverpod package!!!!!
  bool addToFavorites(Place place) {
    // removing place if it's already in the list
    if (state.contains(place)) {
      state = state.where((m) => m.id != m.id).toList();
      return false;
      // adding place if it's not in the list
    } else {
      state = [...state, place];
      return true;
    }
  }
}

// Provider
final favoritePlaceProvider =
    StateNotifierProvider<FavoritePlaceNotifier, List<Place>>(
  (ref) => FavoritePlaceNotifier(),
);
