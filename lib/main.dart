import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:favorite_places_app/screens/places_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 178, 96, 96),
  background: const Color.fromARGB(255, 255, 232, 232),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: GoogleFonts.ubuntuTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntu(
      fontWeight: FontWeight.bold,
    ),
    titleMedium: GoogleFonts.ubuntu(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.ubuntu(
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: colorScheme.onBackground, // Set the text color to white
    ),
    bodyMedium: TextStyle(
      color: colorScheme.onBackground, // Set the text color to white
    ),
    bodySmall: TextStyle(
      color: colorScheme.primary, // Set the text color to white
    ),
    // Add more text styles as needed
  ),
);

void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Great Places',
      theme: theme,
      home: PlacesListScreen(),
    );
  }
}

// ----------- Styling for Text (optional) ------------

// style: Theme.of(context)
//     .textTheme
//     .bodyLarge!
//     .copyWith(color: Theme.of(context).colorScheme.onBackground),
