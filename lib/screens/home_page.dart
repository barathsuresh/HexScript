import 'package:HexScript/constants/firestore_constants.dart';
import 'package:HexScript/models/note.dart';
import 'package:HexScript/providers/authentication_provider.dart';
import 'package:HexScript/providers/note_provider.dart';
import 'package:HexScript/providers/theme_provider.dart';
import 'package:HexScript/screens/about_page.dart';
import 'package:HexScript/screens/login_screen.dart';
import 'package:HexScript/screens/note_page.dart';
import 'package:HexScript/screens/search_page.dart';
import 'package:HexScript/screens/settings_page.dart';
import 'package:HexScript/widgets/custom_grid.dart';
import 'package:HexScript/widgets/custom_list_tile_material_you.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  // const HomePage({Key? key}) : super(key: key);
  final SharedPreferences prefs;
  HomePage({required this.prefs});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var protectF;
  bool _showFab = true;

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NoteData>(context, listen: false).initializeNotes();
    _setGreeting();
    // _searchBarFocus.unfocus();
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

  // update note security
  void updateNoteSec(Note note, bool isProtect) {
    Provider.of<NoteData>(context, listen: false)
        .updateNoteSecurity(note, isProtect);
  }

  // delete a note
  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNote(note);
  }

  // Create new note
  void createNewNote() {
    // create new id
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;

    // create new note
    Note newNote =
        Note(id: id, txt: "", title: "", edited: "", isProtect: false);

    // go to edit page
    goToNotePage(newNote, true);
  }

  final ScrollController _scrollController = ScrollController();
  bool _hasScrolled = false;

  // Scroll the "Welcome" text once to show the full text
  void _scrollWelcomeText() async {
    await Future.delayed(Duration(milliseconds: 500), () {
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 4), // Adjust the duration as needed
        curve: Curves.bounceInOut,
      )
          .then((_) async {
        await Future.delayed(Duration(milliseconds: 500), () {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(seconds: 3), // Adjust the duration as needed
            curve: Curves.decelerate,
          );
        }).then((value) async {
          // Bring the text back to its normal position
          await Future.delayed(Duration(seconds: 3), () {
            setState(() {
              // _scrollController.jumpTo(0);
              _hasScrolled = true;
              _showGreeting = false;
            });
          });
        });
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _greeting = ""; // greeting message
  bool _showGreeting = true;
  // Set the greeting based on the time of day
  void _setGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      _greeting = "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      _greeting = "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      _greeting = "Good Evening";
    } else if (hour >= 21 || hour < 5) {
      _greeting = "Are you Caffeinated?";
    }
  }

  // search bar focus node
  FocusNode _searchBarFocus = FocusNode();
  PageRouteBuilder<void> customPageRouteBuilder(Widget page) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    var backgroundColorLerp =
        themeProvider.isDark ? Colors.black : Colors.white;
    var textIconColor = themeProvider.isDark ? Colors.white : Colors.black;

    return Consumer<NoteData>(
      // This continuously listens to the note provider
      builder: (context, value, child) => Scaffold(
        drawer: Drawer(
          backgroundColor: Color.lerp(
              backgroundColorLerp, Theme.of(context).colorScheme.primary, 0.2),
          child: Column(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.lerp(backgroundColorLerp,
                      Theme.of(context).colorScheme.primary, 0.4),
                ),
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      MdiIcons.hexadecimal,
                      color: textIconColor,
                      size: 70,
                      weight: 1,
                    ),
                    Text(
                      'HexScript',
                      style: GoogleFonts.sourceCodePro(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: textIconColor),
                    ),
                  ],
                ),
              ),
              CustomListTile(
                title: "New Note",
                subtitle: "Create a New Note",
                leadingIcon: MdiIcons.notebookPlus,
                onTap: () {
                  _scaffoldKey.currentState!.closeDrawer();
                  createNewNote();
                },
              ),
              CustomListTile(
                title: "Locked Notes",
                subtitle: "Access notes with Biometrics",
                leadingIcon: MdiIcons.fingerprint,
                onTap: () {
                  _scaffoldKey.currentState!.closeDrawer();
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              CustomListTile(
                title: "Settings",
                subtitle: "Customization",
                leadingIcon: Icons.settings,
                onTap: () {
                  // TODO
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SettingsPage(sharedPreferences: widget.prefs,)));
                },
              ),
              CustomListTile(
                title: "About",
                subtitle: "About HexScript",
                leadingIcon: CommunityMaterialIcons.information_outline,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutPage()));
                },
              ),
              Spacer(),
              CustomListTile(
                title: "Logout",
                subtitle: "bye, ${widget.prefs.get(fireConstants.nickname)}",
                leadingIcon: CommunityMaterialIcons.logout,
                onTap: () {
                  authProvider.handleSignOut();
                  _scaffoldKey.currentState!.closeDrawer();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(prefs: widget.prefs)));
                },
              ),
            ],
          ),
        ),
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleTextStyle: TextStyle(color: textIconColor),
          title: Row(
            children: [
              // ImageIcon(
              //   const AssetImage("images/notepad.png"),
              //   color:
              //       Theme.of(context).colorScheme.secondary.computeLuminance() >
              //               0.5
              //           ? Colors.black
              //           : Colors.white,
              //   size: 30,
              // ),
              const SizedBox(
                width: 8,
              ),
              _showGreeting
                  ? Expanded(
                      child: AnimatedContainer(
                        height: _showGreeting ? 40 : 0,
                        duration: Duration(milliseconds: 500),
                        child: Opacity(
                          opacity: _showGreeting ? 1.0 : 0.0,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics:
                                _hasScrolled ? null : BouncingScrollPhysics(),
                            child: AnimatedTextKit(
                                totalRepeatCount: 1,
                                repeatForever: false,
                                onTap: () {
                                  setState(() {
                                    _hasScrolled = true;
                                    _showGreeting = false;
                                  });
                                },
                                onFinished: _scrollWelcomeText,
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    "${_greeting}, ${widget.prefs.get(fireConstants.nickname)}",
                                    textStyle: GoogleFonts.inconsolata(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: textIconColor),
                                    speed: const Duration(milliseconds: 80),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: AnimatedOpacity(
                        opacity: _showGreeting ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          height: 50,
                          child: Hero(
                            tag: "search",
                            child: SearchBar(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchPage(prefs: widget.prefs)));
                              },
                              hintText: "Search your notes",
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5)),
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
                              leading: InkWell(
                                child: Icon(
                                  Icons.menu,
                                  color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withOpacity(0.5)
                                              .computeLuminance() >
                                          0.5
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                onTap: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                              trailing: [
                                IconButton(
                                  onPressed: () {},
                                  icon: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: CachedNetworkImageProvider(
                                      '${widget.prefs.get(fireConstants.photoUrl)}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          backgroundColor: backgroundColorLerp,
          elevation: 0,
        ),
        backgroundColor: backgroundColorLerp,
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          // borderRadius: BorderRadius.all(Radius.circular(75)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: NavigationBar(
              // backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
              indicatorColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5)
                          .computeLuminance() <
                      0.5
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.tertiary,
              selectedIndex: _currentIndex,
              surfaceTintColor: Colors.black,
              onDestinationSelected: _onTabTapped,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.description_outlined),
                  label: "Notes",
                  selectedIcon: Icon(Icons.description),
                ),
                NavigationDestination(
                  icon: Icon(Icons.lock_open),
                  label: "Personal Space",
                  selectedIcon: Icon(Icons.lock),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: createNewNote,
            elevation: 0,
            //backgroundColor: Colors.grey,
            child: Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
// heading
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      MdiIcons.hexadecimal,
                      size: 70,
                      color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .computeLuminance() >
                              0.5
                          ? Colors.black45
                          : Colors.white70,
                    ),
                    Text(
                      "Notes",
                      style: GoogleFonts.inconsolata(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .computeLuminance() >
                                  0.5
                              ? Colors.black45
                              : Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
// List of Notes
              value.getAllNotes().isEmpty
                  ? Center(
                      child: Text(
                        ":( Create a Note",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 30,
                            color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .computeLuminance() >
                                    0.5
                                ? Colors.black45
                                : Colors.white70),
                      ),
                    )
                  : StaggeredGrid.count(
                      crossAxisCount: 2,
                      children: _currentIndex == 0
                          ? value
                              .getAllNotes()
                              .where((element) => element.isProtect == false)
                              .toList()
                              .map((e) => CustomGridTile(
                                    note: e,
                                    onTap: () {
                                      goToNotePage(e, false);
                                    },
                                    onLockToggle: (bool isLocked) {
                                      updateNoteSec(e, isLocked);
                                    },
                                    onDelete: () {
                                      deleteNote(e);
                                    },
                                  ))
                              .toList()
                          : value
                              .getAllNotes()
                              .where((element) => element.isProtect == true)
                              .toList()
                              .map((e) => CustomGridTile(
                                    note: e,
                                    onTap: () {
                                      goToNotePage(e, false);
                                    },
                                    onLockToggle: (bool isLocked) {
                                      updateNoteSec(e, isLocked);
                                    },
                                    onDelete: () {
                                      deleteNote(e);
                                    },
                                  ))
                              .toList()),
            ]),
          ),
        ),
      ),
    );
  }
}