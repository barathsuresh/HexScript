import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:encrynotes/api/local_auth_api.dart';
import 'package:encrynotes/models/note.dart';
import 'package:encrynotes/models/note_data.dart';
import 'package:encrynotes/screens/note_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var protectF;
  bool _showFab = true;

  // init
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NoteData>(context, listen: false).initializeNotes();
  }

  // go to note page
  void goToNotePage(Note note, bool isNew) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NotePage(
        note: note,
        isNewNote: isNew,
      ),
    ));
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

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    return Consumer<NoteData>(
      // This continuously listens to the provider
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black87 : Colors.white),
          title: Row(
            children: [
              ImageIcon(
                const AssetImage("images/notepad.png"),
                color:
                    Theme.of(context).colorScheme.secondary.computeLuminance() >
                            0.5
                        ? Colors.black
                        : Colors.white,
                size: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              AnimatedTextKit(
                  totalRepeatCount: 1,
                  repeatForever: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "HexScript",
                      textStyle: GoogleFonts.inconsolata(
                          fontSize: 40, fontWeight: FontWeight.bold),
                      speed: const Duration(milliseconds: 100),
                    )
                  ]),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: createNewNote,
          elevation: 0,
          //backgroundColor: Colors.grey,
          label: const Row(
            children: [
              Icon(
                Icons.add,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "NEW NOTE",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // heading
            Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  "Notes",
                  style: GoogleFonts.inconsolata(
                      fontSize: 60, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black45 : Colors.white70),
                )),
            const SizedBox(
              height: 10,
            ),
            // List of Notes
            value.getAllNotes().isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Developed by",
                            style: TextStyle(fontWeight: FontWeight.normal,color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black45 : Colors.white70),
                          ),
                          Text(
                            "               ~Barath Suresh",
                            style: TextStyle(fontWeight: FontWeight.w900,color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black45 : Colors.white70),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.bottom) *
                        0.75,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CupertinoListSection.insetGrouped(
                            backgroundColor: Colors.transparent,
                            children: List.generate(
                                value.getAllNotes().length,
                                (index) => CupertinoListTile(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      title: Text(
                                        value.getAllNotes()[index].title,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                        .colorScheme
                                                        .tertiary
                                                        .computeLuminance() >
                                                    0.5
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                      subtitle: value
                                              .getAllNotes()[index]
                                              .isProtect
                                          ? Text(
                                              "Biometric unlock to access🗝️",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                              .colorScheme
                                                              .tertiary
                                                              .computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Colors.white))
                                          : Text(
                                              value.getAllNotes()[index].txt,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                              .colorScheme
                                                              .tertiary
                                                              .computeLuminance() >
                                                          0.5
                                                      ? Colors.black
                                                      : Colors.white),
                                            ),
                                      additionalInfo:
                                          value.getAllNotes()[index].isProtect
                                              ? const Icon(
                                                  Icons.fingerprint_outlined,
                                                  color: Colors.blue,
                                                )
                                              : const Text(""),
                                      trailing: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              protectF = await LocalAuthApi
                                                  .authenticate();
                                              print(protectF);
                                              // lock the note
                                              setState(() {
                                                if (value
                                                        .getAllNotes()[index]
                                                        .isProtect ==
                                                    false) {
                                                  updateNoteSec(
                                                      value
                                                          .getAllNotes()[index],
                                                      protectF);
                                                }
                                                // unlock the note
                                                else {
                                                  updateNoteSec(
                                                      value
                                                          .getAllNotes()[index],
                                                      !protectF);
                                                }
                                              });
                                            },
                                            icon: value
                                                    .getAllNotes()[index]
                                                    .isProtect
                                                ? const Icon(
                                                    Icons.lock_outline,
                                                    color: Colors.yellow,
                                                  )
                                                : const Icon(
                                                    Icons.lock_open_outlined,
                                                    color: Colors.yellowAccent,
                                                  ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              if (value
                                                      .getAllNotes()[index]
                                                      .isProtect ==
                                                  true) {
                                                if (await LocalAuthApi
                                                    .authenticate()) {
                                                  deleteNote(value
                                                      .getAllNotes()[index]);
                                                }
                                              } else {
                                                deleteNote(
                                                    value.getAllNotes()[index]);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        // if fingerprint require authenticate
                                        if (value
                                                .getAllNotes()[index]
                                                .isProtect ==
                                            true) {
                                          if (await LocalAuthApi
                                              .authenticate()) {
                                            goToNotePage(
                                                value.getAllNotes()[index],
                                                false);
                                          }
                                        } else {
                                          goToNotePage(
                                              value.getAllNotes()[index],
                                              false);
                                        }
                                      },
                                    )),
                          ),
                        ],
                      ),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
