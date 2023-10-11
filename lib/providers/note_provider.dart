import 'package:HexScript/api/encrypt_decrypt.dart';
import 'package:HexScript/data/hive_database.dart';
import 'package:HexScript/models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class NoteData extends ChangeNotifier {
  // hive data base
  final db = HiveDatabase();

  // for firebase database
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _notesCollection;
  // overall list
  List<Note> allNotes = [];

  // Constructor for NoteProvider
  NoteData() {
    _notesCollection = _firestore.collection("notes");
    initializeNotes();
  }
  // initialize database
  Future<void> initializeNotes() async {
    // allNotes = db.loadNotes();
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _notesCollection.doc(user.uid).get();
      if (snapshot.exists) {
        final datas = snapshot.data() as Map<String, dynamic>;
        allNotes = List<Note>.from(datas['notes'].map((note) {
          return Note.fromJSON(note);
        }));
        print("Notes retrieved");
        print(allNotes);
        notifyListeners();
      }else{
        allNotes = db.loadNotes();
        notifyListeners();
      }
    }
  }

  // get notes
  List<Note> getAllNotes() {
    return allNotes;
  }

  // add a new note
  void addNewNote(Note note) {
    allNotes.add(note);
    db.saveNotes(allNotes);
    _syncWithFirebase();
    notifyListeners();
  }

  // update note
  void updateNote(Note note, String txt, String title) {
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        allNotes[i].txt = txt.isEmpty ? "" : EncryptionDecryption.encryptMessage(txt);
        allNotes[i].title = title.isEmpty ? "" : EncryptionDecryption.encryptMessage(title);
        allNotes[i].edited =
            DateFormat("E, d MMM yyyy h:mm a").format(DateTime.now());
      }
    }
    db.saveNotes(allNotes);
    _syncWithFirebase();
    notifyListeners();
  }

  List<Note> searchNotes(String query) {
    query = query.toLowerCase(); // Convert the query to lowercase for case-insensitive search
    return allNotes.where((note) {
      final title = note.title.toLowerCase().isEmpty ? "" : EncryptionDecryption.decryptMessage(note.title).toString().toLowerCase();
      final txt = note.txt.toLowerCase().isEmpty ? "" : EncryptionDecryption.decryptMessage(note.txt).toString().toLowerCase();
      return title.contains(query) || txt.contains(query);
    }).toList();
  }

  // update note security
  void updateNoteSecurity(Note note, bool isProtect) {
    for (int i = 0; i < allNotes.length; i++) {
      if (allNotes[i].id == note.id) {
        allNotes[i].isProtect = isProtect;
      }
    }
    db.saveNotes(allNotes);
    _syncWithFirebase();
    notifyListeners();
  }

  // delete note
  void deleteNote(Note note) {
    allNotes.remove(note);
    db.saveNotes(allNotes);
    _syncWithFirebase();
    notifyListeners();
  }

  Future<void> _syncWithFirebase() async{
    final user = _auth.currentUser;
    if(user!=null){
      final data = {
        'notes' : allNotes.map((note) => note.toJson()).toList(),
      };
      await _notesCollection.doc(user.uid).set(data);
    }
  }
  Future<void> clearHiveDatabase() async{
    final box = await Hive.openBox('note_database');
    await box.clear();
  }
  // Delete documents associated with a user
  Future<void> deleteUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Delete the documents associated with the user
      await _notesCollection.doc(user.uid).delete();
      await clearHiveDatabase();
    }
  }
}
