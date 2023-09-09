// import 'package:encrynotes/models/note.dart';
// import 'package:encrynotes/models/note_provider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:provider/provider.dart';
//
// class EditingNotePage extends StatefulWidget {
//   Note note;
//   bool isNewNote;
//
//   EditingNotePage({required this.note, required this.isNewNote});
//
//   @override
//   State<EditingNotePage> createState() => _EditingNotePageState();
// }
//
// class _EditingNotePageState extends State<EditingNotePage> {
//   QuillController _controller = QuillController.basic();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadExistingNote();
//   }
//
//   // load existing note
//   void loadExistingNote() {
//     final doc = Document()..insert(0, widget.note.txt);
//     final offset = widget.note.txt.trim().length;
//     TextPosition pos = TextPosition(offset: offset);
//     setState(() {
//       _controller = QuillController(
//           document: doc, selection: TextSelection.fromPosition(pos));
//     });
//   }
//
//   // add a new note
//   void addNewNote() {
//     // get new id
//     int id = Provider.of<NoteData>(context,listen: false).getAllNotes().length;
//     // get text from editor
//     String txt = _controller.document.toPlainText();
//     // add the new note
//     Provider.of<NoteData>(context, listen: false)
//         .addNewNote(Note(id: id, txt: txt,isProtect: false));
//   }
//
//   // update an existing note
//   void updateNote() {
//     // get text from editor
//     String text = _controller.document.toPlainText();
//     print(text.length);
//     if(text.trim() == widget.note.txt.trim()){
//       print("Nothing done");
//     }
//     // update Note
//     else {
//       Provider.of<NoteData>(context, listen: false).updateNote(
//           widget.note, text);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async{
//         // if it is a new note
//         if(widget.isNewNote==true && !_controller.document.isEmpty()){
//           addNewNote();
//         }
//         // if it is an existing note
//         else{
//           updateNote();
//         }
//         return true;
//         Navigator.pop(context);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back,color: Colors.black,),
//             onPressed: () {
//               // if it is a new note
//               if(widget.isNewNote==true && !_controller.document.isEmpty()){
//                 addNewNote();
//               }
//               // if it is an existing note
//               else{
//                 updateNote();
//               }
//               Navigator.pop(context);
//             },
//           ),
//           backgroundColor: CupertinoColors.systemGroupedBackground,
//         ),
//         body: Column(
//           children: [
//             // editor
//             Expanded(
//               child: Container(
//                 color: CupertinoColors.systemGroupedBackground,
//                 padding: EdgeInsets.all(25),
//                 child:
//                     QuillEditor.basic(controller: _controller, readOnly: false),
//               ),
//             ),
//             QuillToolbar.basic(
//               controller: _controller,
//               showAlignmentButtons: false,
//               showBackgroundColorButton: false,
//               showBoldButton: false,
//               showCenterAlignment: false,
//               showClearFormat: false,
//               showCodeBlock: false,
//               showColorButton: false,
//               showDirection: false,
//               showDividers: false,
//               showFontFamily: false,
//               showFontSize: false,
//               showHeaderStyle: false,
//               showIndent: false,
//               showInlineCode: false,
//               showItalicButton: false,
//               showJustifyAlignment: false,
//               showLeftAlignment: false,
//               showLink: false,
//               showListBullets: false,
//               showListCheck: false,
//               showListNumbers: false,
//               showQuote: false,
//               showRedo: true,
//               showRightAlignment: false,
//               showSearchButton: false,
//               showSmallButton: false,
//               showStrikeThrough: false,
//               showUnderLineButton: false,
//               showUndo: true,
//             ),
//             //toolbar
//           ],
//         ),
//       ),
//     );
//   }
// }
