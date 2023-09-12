import 'package:HexScript/api/encrypt_decrypt.dart';
import 'package:HexScript/models/note.dart';
import 'package:HexScript/providers/note_provider.dart';
import 'package:HexScript/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  Note note;
  bool isNewNote;

  NotePage({required this.note, required this.isNewNote});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> with WidgetsBindingObserver{
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  FocusNode _focusNoteNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadExistingNote();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }
  // load existing note
  void loadExistingNote() {
    // final doc = Document()..insert(0, widget.note.txt);
    final offset = widget.note.txt.trim().length;
    TextPosition pos = TextPosition(offset: offset);
    setState(() {
      _titleController = TextEditingController(text: widget.isNewNote ? "" : widget.note.title.trim().isEmpty ? "" : EncryptionDecryption.decryptMessage(widget.note.title.trim()));
      _contentController = TextEditingController(text: widget.isNewNote ? "" : widget.note.txt.trim().isEmpty ? "" : EncryptionDecryption.decryptMessage(widget.note.txt.trim()));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      // Handle the home button press or recent apps button press here
        if (widget.isNewNote == true && _contentController.text.isNotEmpty) {
          addNewNote();
          widget.isNewNote = false;
        } else if (widget.isNewNote == true && _titleController.text.isNotEmpty) {
          addNewNote();
          widget.isNewNote = false;
        } else {
          updateNote();
        }
        break;
      case AppLifecycleState.resumed:
      // App is brought back to the foreground
        break;
      default:
        break;
    }
  }

  // add a new note
  void addNewNote() {
    // get new id
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    // get text from editor
    // String txt = _controller.document.toPlainText();
    String title = _titleController.text.isEmpty ? "" : EncryptionDecryption.encryptMessage(_titleController.text);
    String txt = _contentController.text.isEmpty ? "" : EncryptionDecryption.encryptMessage(_contentController.text);
    String formatDateTime = DateFormat("E, d MMM yyyy h:mm a").format(DateTime.now());
    // add the new note
    Provider.of<NoteData>(context, listen: false)
        .addNewNote(Note(id: id, txt: txt,title: title,edited: formatDateTime, isProtect: false));
    print("added new note");
  }

  // update an existing note
  void updateNote() {
    // get text from editor
    // String text = _controller.document.toPlainText();
    String text = _contentController.text;
    String title = _titleController.text;

    print(text.length);
    print(text);

    var checktext = widget.note.txt.trim().isEmpty ? "" : EncryptionDecryption.decryptMessage(widget.note.txt.trim());
    var checktitle = widget.note.title.trim().isEmpty ? "" : EncryptionDecryption.decryptMessage(widget.note.title.trim());
    if (text.trim() ==  checktext && title.trim() == checktitle) {
      print("Nothing done");
    }
    // update Note
    else {
      Provider.of<NoteData>(context, listen: false)
          .updateNote(widget.note, text,title);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth;
    final double screenHeight;
    final double screenSafeHeight;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    screenSafeHeight = screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom -16;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    var backgroundColorLerp =
    themeProvider.isDark ? Colors.black : Colors.white;
    var textIconColor = themeProvider.isDark ? Colors.white : Colors.black;

    return WillPopScope(
      onWillPop: () async {
        // if it is a new note
        if (widget.isNewNote == true && !_contentController.text.isEmpty) {
          addNewNote();
        }
        else if(widget.isNewNote == true && !_titleController.text.isEmpty){
          addNewNote();
        }
        // if it is an existing note
        else {
          updateNote();
        }
        return true;
        Navigator.pop(context);
      },
      child: GestureDetector(
        onTap: (){
          _focusNoteNode.requestFocus();
        },
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  // if it is a new note
                  if (widget.isNewNote == true &&
                      !_contentController.text.isEmpty) {
                    addNewNote();
                  }
                  // if it is an existing note
                  else {
                    updateNote();
                  }
                  Navigator.pop(context);
                },
              ),
              backgroundColor: backgroundColorLerp,
            ),
            backgroundColor: backgroundColorLerp,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      cursorColor: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                      showCursor: true,
                      controller: _titleController,
                      style: TextStyle(fontSize: 25,color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 25,color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 7,),
                    TextFormField(
                      controller: _contentController,
                      showCursor: true,
                      cursorColor: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                      focusNode: _focusNoteNode,
                      style: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Note',
                        hintStyle: TextStyle(fontSize: 18,color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black : Colors.white),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                    ),
                    Center(child: widget.isNewNote ? SizedBox.shrink() : Text("Edited "+widget.note.edited,style: TextStyle(color: Theme.of(context).colorScheme.secondary.computeLuminance() > 0.5 ? Colors.black54 : Colors.white54),)),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
