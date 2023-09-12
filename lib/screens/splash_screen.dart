import 'package:HexScript/providers/authentication_provider.dart';
import 'package:HexScript/providers/theme_provider.dart';
import 'package:HexScript/screens/home_page.dart';
import 'package:HexScript/screens/login_screen.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final SharedPreferences prefs;
  SplashScreen({required this.prefs});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Shows the splash screen for 4 seconds and call the function checkSignedIn()
    Future.delayed(Duration(seconds: 3,milliseconds: 450),(){
      checkSignedIn();
    });
  }

  void checkSignedIn() async{
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if(isLoggedIn){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage(prefs: widget.prefs,)));
      return;
    }
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen(prefs: widget.prefs,)));
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    var backgroundColorLerp =
    themeProvider.isDark ? Colors.black : Colors.white;
    var textIconColor = themeProvider.isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: backgroundColorLerp,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "logo",
              child: Icon(CommunityMaterialIcons.hexadecimal,size: 300,color: textIconColor,),
            ),
            SizedBox(height: 20,),
            SizedBox(height: 20,),
            LoadingAnimationWidget.hexagonDots(color: textIconColor, size: 100),
          ],
        ),
      ),
    );
  }
}