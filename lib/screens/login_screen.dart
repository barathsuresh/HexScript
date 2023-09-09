import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:encrynotes/providers/authentication_provider.dart';
import 'package:encrynotes/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;
  LoginScreen({required this.prefs});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch(authProvider.status){
      case Status.authenticateError: Fluttertoast.showToast(msg: "Sign in failed");
      break;
      case Status.authenticateCancelled: Fluttertoast.showToast(msg: "Sign in cancelled");
      break;
      case Status.authenticated: Fluttertoast.showToast(msg: "Signed in ");
      break;
      default:
        break;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Hero(
                tag: "logo",
                child: ImageIcon(AssetImage("icons/heliumicon.png"),size: 100,color: Colors.black),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: TextLiquidFill(
                text: "Helium Messenger",
                waveColor: Colors.black,
                boxBackgroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () async{
                  bool isSuccess = await authProvider.handleSignIn();
                  if(isSuccess){
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage(prefs: widget.prefs,)));
                  }
                },
                child: Image.asset(
                  "images/gsignin.png",
                  height: 100,
                  width: 200,
                ),
              ),
            ),
            // Positioned(
            //       child: authProvider.status == Status.authenticating ? LoaderLoginCircle() : SizedBox.shrink(),
            // )
          ],
        ),
      ),
    );
  }
}