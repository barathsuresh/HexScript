import 'package:HexScript/providers/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  void _launchWebPage() async {
    const url = 'https://avatars.githubusercontent.com/u/39296391?s=400&u=8553b8a3b1d25ae35ad03ff0af0c79dfef30cff2&v=4'; // Replace with the URL you want to open
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    var backgroundColorLerp =
        themeProvider.isDark ? Colors.black : Colors.white;
    var textIconColor = themeProvider.isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColorLerp,
      appBar: AppBar(
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
        backgroundColor: backgroundColorLerp,
        title: Row(
          children: [
            Icon(
              CommunityMaterialIcons.hexadecimal,
              size: 50,
              color: textIconColor,
            ),
            Text(
              'About Page',
              style: GoogleFonts.sourceCodePro(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: textIconColor),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // App Logo/Icon
            Center(
              child: Row(
                children: [
                  Icon(
                    CommunityMaterialIcons.hexadecimal,
                    size: 100,
                    color: textIconColor,
                  ),
                  Expanded(
                    child: Text(
                      "HexScript",
                      style: GoogleFonts.sourceCodePro(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: textIconColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: _launchWebPage,
              child: Text(
                'Developed with ❤️',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      "https://avatars.githubusercontent.com/u/39296391?s=400&u=8553b8a3b1d25ae35ad03ff0af0c79dfef30cff2&v=4"),
                  radius: 40.0, // Adjust the size as needed
                ),
                SizedBox(width: 16.0), // Add spacing between the image and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Barath Suresh",
                      style: TextStyle(
                        fontSize: 18.0, // Adjust the font size as needed
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15,),
            // Description
            Text(
              "HexScript is a secure and user-friendly notes app designed to help you organize your thoughts, ideas, and important information with confidence. Whether you're jotting down personal thoughts, work-related notes, or creative inspirations, HexScipt keeps your data safe with advanced encryption.",
              style:
                  GoogleFonts.sourceCodePro(fontSize: 16, color: textIconColor),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '''
End-to-End Encryption: Your notes are protected with industry-standard encryption, ensuring that only you can access and decipher your sensitive information.

Sleek and Intuitive Interface: HexScript provides a clean and intuitive user interface that makes note-taking a breeze. Focus on your ideas without distractions.

Rich Text Formatting: Customize your notes with various formatting options, including bold, italics, bullet points, and more. Make your notes visually appealing and easy to read.

Organize Your Notes: Create multiple notebooks or categories to keep your notes organized. Quickly search and find the notes you need.

Sync Across Devices: Seamlessly sync your notes across multiple devices, so you can access your information anytime, anywhere.

Dark Mode: Enjoy a comfortable reading experience in low-light conditions with the app's dark mode.

Biometric Lock: Add an extra layer of security with biometric or PIN lock, ensuring your notes are safe even if your device falls into the wrong hands.

Automatic Backups: Your notes are automatically backed up to the cloud, preventing data loss in case of device issues.

Date and Time Stamps: Each note is timestamped, helping you keep track of when you created or edited it.

Search Functionality: Easily find specific notes using the powerful search feature.

Whether you're a student, professional, or creative thinker, HexScript is the perfect companion for capturing and safeguarding your ideas. Download HexScript today and start taking notes with confidence.
              ''',
              style:
                  GoogleFonts.sourceCodePro(fontSize: 16, color: textIconColor),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
