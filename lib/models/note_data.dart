import 'package:encrynotes/data/hive_database.dart';
import 'package:encrynotes/models/note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NoteData extends ChangeNotifier{
  // hive data base
  final db = HiveDatabase();
  // overall list
  List<Note> allNotes = [];
  // initialize database
  void initializeNotes(){
    allNotes = db.loadNotes();
  }
  // get notes
  List<Note> getAllNotes(){
    return allNotes;
  }
  // add a new note
  void addNewNote(Note note){
    allNotes.add(note);
    db.saveNotes(allNotes);
    notifyListeners();
  }
  // update note
  void updateNote(Note note, String txt, String title){
    for (int i=0; i < allNotes.length; i++){
      if(allNotes[i].id == note.id){
        allNotes[i].txt = txt;
        allNotes[i].title = title;
        allNotes[i].edited =DateFormat("E, d MMM yyyy h:mm a").format(DateTime.now());
      }
    }
    db.saveNotes(allNotes);
    notifyListeners();
  }
  // update note security
  void updateNoteSecurity(Note note, bool isProtect){
    for (int i=0; i < allNotes.length; i++){
      if(allNotes[i].id == note.id){
        allNotes[i].isProtect = isProtect;
      }
    }
    db.saveNotes(allNotes);
    notifyListeners();
  }
  // delete note
  void deleteNote(Note note){
    allNotes.remove(note);
    db.saveNotes(allNotes);
    notifyListeners();
  }
}