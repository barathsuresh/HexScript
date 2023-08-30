import 'package:dynamic_color/dynamic_color.dart';
import 'package:encrynotes/models/note_data.dart';
import 'package:encrynotes/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // initialize hive
  await Hive.initFlutter();
  // open a hive box
  await Hive.openBox('note_database');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final _defaultLightColorScheme =
  ColorScheme.fromSwatch(primarySwatch: Colors.blue,brightness: Brightness.light);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,brightness: Brightness.dark);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteData(),
      builder: (context, child) => DynamicColorBuilder(builder: (ColorScheme1, ColorScheme2){
        return MaterialApp(
          home: HomePage(),
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme2 ?? _defaultLightColorScheme,
            // brightness: Brightness.light,
            textTheme:
            GoogleFonts.robotoSlabTextTheme(Theme.of(context).textTheme.apply(bodyColor: Colors.white,displayColor: Colors.white70)),
          ),

          darkTheme: ThemeData(
            // brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme1 ?? _defaultDarkColorScheme,
            textTheme:
            GoogleFonts.robotoSlabTextTheme(Theme.of(context).textTheme.apply(bodyColor: Colors.white,displayColor: Colors.white70)),
          ),
          themeMode: ThemeMode.system,
        );
      }),
    );
  }
}
