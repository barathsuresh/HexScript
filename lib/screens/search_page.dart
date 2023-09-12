import 'package:HexScript/api/encrypt_decrypt.dart';
import 'package:HexScript/api/local_auth_api.dart';
import 'package:HexScript/models/note.dart';
import 'package:HexScript/providers/note_provider.dart';
import 'package:HexScript/providers/theme_provider.dart';
import 'package:HexScript/screens/note_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  final SharedPreferences prefs;

  SearchPage({required this.prefs});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode _searchBarFocus = FocusNode();
  var _searchResults = <Note>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // go to note page
  void goToNotePage(Note note, bool isNew) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          if (!isNew) {
            // Use SlideTransition for slide animation
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0), // Slide from right to left
                end: Offset.zero,
              ).animate(animation),
              child: NotePage(
                note: note,
                isNewNote: isNew,
              ),
            );
          } else {
            // Use FadeTransition for fade animation
            return FadeTransition(
              opacity: animation,
              child: NotePage(
                note: note,
                isNewNote: isNew,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    TextEditingController _searchController = TextEditingController();

    var backgroundColorLerp =
        themeProvider.isDark ? Colors.black : Colors.white;
    var textIconColor = themeProvider.isDark ? Colors.white : Colors.black;
    var textIconInverted = themeProvider.isDark ? Colors.black : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColorLerp,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              CommunityMaterialIcons.hexadecimal,
              size: 50,
              color: textIconColor,
            ),
            Text(
              "Search",
              style: GoogleFonts.sourceCodePro(
                  fontSize: 40,
                  color: textIconColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: backgroundColorLerp,
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: "search",
              child: SearchBar(
                onChanged: (query) {
                  var notes;
                  if (query.isNotEmpty) {
                    notes = Provider.of<NoteData>(context, listen: false)
                        .searchNotes(query);
                  }

                  setState(() {
                    _searchResults.clear(); // Clear previous results
                    if (notes != null && !notes.isEmpty) {
                      _searchResults.addAll(
                          notes); // Add new search results if there are any
                    }
                  });
                },
                textStyle: MaterialStateProperty.all(GoogleFonts.sourceCodePro(
                    color: textIconColor, fontSize: 20)),
                focusNode: _searchBarFocus,
                hintText: "Search your notes",
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                hintStyle: MaterialStateProperty.all(
                  GoogleFonts.roboto(
                    fontSize: 20,
                    color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5)
                                .computeLuminance() >
                            0.5
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                trailing: [
                  IconButton(
                    onPressed: () {},
                    icon: CircleAvatar(
                      child: Text(
                        _searchResults.length.toString(),
                        style:
                            GoogleFonts.sourceCodePro(color: textIconInverted),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final note = _searchResults[index];
                  // Display the search results here
                  return Card(
                    color: Color.lerp(Colors.white,
                        Theme.of(context).colorScheme.primary, 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 2.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      leading: CircleAvatar(
                        child: Icon(note.isProtect
                            ? MdiIcons.fingerprint
                            : MdiIcons.noteSearch),
                      ),
                      title: Text(
                        note.title.isEmpty
                            ? ""
                            : EncryptionDecryption.decryptMessage(note.title),
                        style: GoogleFonts.sourceCodePro(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      subtitle: Text(
                        note.isProtect
                            ? "Authentication Required"
                            : note.txt.isEmpty
                                ? ""
                                : EncryptionDecryption.decryptMessage(note.txt),
                        style: GoogleFonts.sourceCodePro(color: Colors.black),
                      ),
                      trailing: Text(
                        index.toString(),
                        style: GoogleFonts.sourceCodePro(
                            color: textIconInverted, fontSize: 15),
                      ), // Use the provided trailing widget
                      onTap: () async {
                        // Handle tap action here
                        if (note.isProtect) {
                          if (await LocalAuthApi.authenticate()) {
                            goToNotePage(note, false);
                          }
                        } else {
                          goToNotePage(note, false);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
