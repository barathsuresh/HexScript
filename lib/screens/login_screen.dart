import 'package:HexScript/providers/authentication_provider.dart';
import 'package:HexScript/providers/theme_provider.dart';
import 'package:HexScript/screens/home_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context);

    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in failed");
        break;
      case Status.authenticateCancelled:
        Fluttertoast.showToast(msg: "Sign in cancelled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Signed in ");
        break;
      default:
        break;
    }
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    var backgroundColorLerp =
        themeProvider.isDark ? Colors.black : Colors.white;
    var textIconColor = themeProvider.isDark ? Colors.white : Colors.black;
    var invertColor = themeProvider.isDark ? Colors.black : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColorLerp,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Hero(
                    tag: "logo",
                    child: FittedBox(
                      child: TextLiquidFill(
                        text: "0xHexScript",
                        waveColor: textIconColor,
                        boxBackgroundColor: backgroundColorLerp,
                        textStyle: GoogleFonts.sourceCodePro(
                            fontSize: 50,
                            color: textIconColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Text("Powered by Firebase x Hive",style: GoogleFonts.sourceCodePro(fontSize: 15,fontWeight: FontWeight.w500,color: textIconColor),),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width-100, // Set the width to your desired value
              child: OutlinedButton(
                onPressed: () async {
                  bool isSuccess = await authProvider.handleSignIn();
                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(prefs: widget.prefs),
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CommunityMaterialIcons.google,
                      color: textIconColor,
                      size: 30,
                    ),
                    SizedBox(width: 10), // Add spacing between the icon and text
                    Text(
                        "Sign in with Google",
                        style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.bold,color: textIconColor)
                    ),
                  ],
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
