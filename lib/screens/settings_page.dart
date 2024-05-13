import 'package:HexScript/api/local_auth_api.dart';
import 'package:HexScript/providers/authentication_provider.dart';
import 'package:HexScript/providers/note_provider.dart';
import 'package:HexScript/providers/theme_provider.dart';
import 'package:HexScript/screens/login_screen.dart';
import 'package:HexScript/widgets/custom_list_tile_material_you.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  SettingsPage({required this.sharedPreferences});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDeleting = false;

  // Function to delete the account
  Future<void> deleteAccount() async {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context);
    NoteData noteData = Provider.of<NoteData>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context);
    NoteData noteData = Provider.of<NoteData>(context, listen: false);
    var background = themeProvider.isDark ? Colors.black : Colors.white;
    var textIconColor = themeProvider.isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: textIconColor,
            size: 40,
          ),
        ),
        title: Row(
          children: [
            Icon(
              CommunityMaterialIcons.hexadecimal,
              size: 50,
              color: textIconColor,
            ),
            Text(
              'Settings',
              style: GoogleFonts.sourceCodePro(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: textIconColor),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              CustomListTile(
                leadingIcon:
                    themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                title: "Enable Dark Mode",
                subtitle: "(Recommended) Dark Mode gives comfortable viewing.",
                onTap: () {},
                trailing: Transform.scale(
                  scale: 1.3,
                  child: Switch(
                    value: themeProvider
                        .isDark, // Get the current theme value from your app settings,
                    onChanged: (newValue) {
                      themeProvider.isDark
                          ? themeProvider.isDark = false
                          : themeProvider.isDark = true;
                    },
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "DANGER ZONE ⚠️\n",
                  style: GoogleFonts.sourceCodePro(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Warning: Account Deletion\n\n",
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Deleting your account will permanently remove all your data and you will lose access to your account. This action cannot be undone. Please make sure you have backed up any important information before proceeding.\n\n",
                  style: GoogleFonts.sourceCodePro(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Are you sure you want to delete your account?",
                  style: GoogleFonts.sourceCodePro(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Spacer(),
              Card(
                color: Color.lerp(
                    Colors.white, Theme.of(context).colorScheme.primary, 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2.0,
                child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    leading: CircleAvatar(
                      child: Icon(CommunityMaterialIcons.account_remove),
                    ),
                    title: Text(
                      "Delete Account",
                      style: GoogleFonts.sourceCodePro(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    subtitle: Text(
                      "Authorization Required",
                      style: GoogleFonts.sourceCodePro(color: Colors.black),
                    ),
                    // Use the provided trailing widget
                    onTap: () async {
                      // Handle tap action here
                      setState(() {
                        isDeleting = true;
                      });
                      if (await LocalAuthApi.authenticate()) {
                        await noteData.deleteUserData();
                        await authProvider.deleteUserAccount();

                        Fluttertoast.showToast(msg: "Sorry To see you go :(");
                        Future.delayed(Duration(seconds: 4), () {
                          setState(() {
                            isDeleting = false; // Hide progress indicator
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                    prefs: widget.sharedPreferences)),
                          );
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Cancelled");
                      }
                      setState(() {
                        isDeleting = false; // Hide progress indicator
                      });
                    }),
              ),
              Divider(),
            ],
          ),
          if (isDeleting)
            Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor:
                      Colors.transparent, // Set your desired background color
                  valueColor: AlwaysStoppedAnimation<Color>(
                      textIconColor), // Set your desired progress bar color
                ),
                SizedBox(height: 8), // Adjust spacing as needed
              ],
            ),
        ],
      ),
    );
  }
}
