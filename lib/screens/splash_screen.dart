import 'package:encrynotes/providers/authentication_provider.dart';
import 'package:encrynotes/screens/home_page.dart';
import 'package:encrynotes/screens/login_screen.dart';
import 'package:flutter/material.dart';
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
    Future.delayed(Duration(seconds: 2),(){
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "logo",
              child: ImageIcon(AssetImage("icons/heliumicon.png"),size: 300,color: Colors.black),
            ),
            SizedBox(height: 20,),
            SizedBox(height: 20,),
            Container(
              width: 20,
              height: 20,
              color: Colors.white,
              child: CircularProgressIndicator(color: Colors.black,),
            )
          ],
        ),
      ),
    );
  }
}