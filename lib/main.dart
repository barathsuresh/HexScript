import 'package:HexScript/providers/authentication_provider.dart';
import 'package:HexScript/providers/note_provider.dart';
import 'package:HexScript/providers/theme_provider.dart';
import 'package:HexScript/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // initialize hive
  await Hive.initFlutter();
  // open a hive box
  await Hive.openBox('note_database');
  runApp(MyApp(
    prefs: sharedPreferences,
  ));
}

class MyApp extends StatelessWidget {
  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.light);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  final SharedPreferences prefs; // used to remember your login info
  final FirebaseFirestore firebaseFirestore =
      FirebaseFirestore.instance; // Using FirebaseDatabase

  MyApp({required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationProvider(
              preferences: prefs,
              firebaseFirestore: firebaseFirestore,
              firebaseAuth: FirebaseAuth.instance,
              googleSignIn: GoogleSignIn()),
        ),
        ChangeNotifierProvider(
          create: (context) => NoteData(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          builder: (context,child) => DynamicColorBuilder(builder: (ColorScheme1, ColorScheme2) {
            return Consumer<ThemeProvider>(builder: (context,themeProvider,child){
              return MaterialApp(
                  home: SplashScreen(
                    prefs: prefs,
                  ),
                  theme: ThemeData(
                      useMaterial3: true,
                      colorScheme: ColorScheme2 ?? _defaultLightColorScheme,
                      // brightness: Brightness.light,
                      textTheme: GoogleFonts.robotoSlabTextTheme(Theme.of(context)
                          .textTheme
                          .apply(
                          bodyColor: Colors.white,
                          displayColor: Colors.white70)),
                      navigationBarTheme: NavigationBarThemeData(
                        // indicatorColor: Colors.transparent,
                        iconTheme: MaterialStateProperty.all(
                          IconThemeData(color: Colors.black54),
                        ),
                        labelTextStyle: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: 1.0,
                            );
                          }
                          return const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            letterSpacing: 1.0,
                          );
                        }),
                      )),
                  darkTheme: ThemeData(
                    // brightness: Brightness.dark,
                      useMaterial3: true,
                      colorScheme: ColorScheme1 ?? _defaultDarkColorScheme,
                      textTheme: GoogleFonts.robotoSlabTextTheme(
                        Theme.of(context).textTheme.apply(
                            bodyColor: Colors.white, displayColor: Colors.white70),
                      ),
                      navigationBarTheme: NavigationBarThemeData(
                        iconTheme: MaterialStateProperty.all(
                          IconThemeData(color: Colors.white70),
                        ),
                        // indicatorColor: Colors.transparent,
                        labelTextStyle: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            );
                          }
                          return const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          );
                        }),
                      )),
                  themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light
              );
            });
          }),
        )
      ],
    );
  }
}
