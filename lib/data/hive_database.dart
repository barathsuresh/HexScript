import 'package:HexScript/models/note.dart';

import 'package:hive/hive.dart';

class HiveDatabase{
  // reference our hive box
  final _myBox = Hive.box('note_database');

  // load box
  List<Note> loadNotes(){
    List<Note> savedNotesFormatted = [];

    // if the exists notes, return that, otherwise return empty
    if (_myBox.get("ALL_NOTES") != null){
      List<dynamic> savedNotes = _myBox.get("ALL_NOTES");
      for(int i=0; i<savedNotes.length; i++){
        // create individual notes
        Note individualNote = Note(id: savedNotes[i][0], title: savedNotes[i][1],txt: savedNotes[i][2],edited: savedNotes[i][3], isProtect: savedNotes[i][4]);
        // add to list
        savedNotesFormatted.add(individualNote);
      }
    }else{
      print("Nothing");
    }
    return savedNotesFormatted;
  }

  // save notes
  void saveNotes(List<Note> allNotes){
    List<List<dynamic>> allNotesFormatted = [
      /*
        [
          [0,"First Note"],
          [1,"Second Note"],
          ..
        ]
      */
    ];

    // each note has an id and text
    for(var note in allNotes){
      int id = note.id;
      String text = note.txt;
      String title = note.title;
      String edited = note.edited;
      bool isProtect = note.isProtect;
      allNotesFormatted.add([id,title,text,edited,isProtect]);
    }

    // then store into hive
    _myBox.put("ALL_NOTES", allNotesFormatted);
  }
}