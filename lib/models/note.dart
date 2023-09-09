import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrynotes/constants/firestore_constants.dart';
import 'package:intl/intl.dart';

class Note {
  int id;
  String title;
  String txt;
  String edited;
  bool isProtect;

  Note(
      {required this.id,
      required this.title,
      required this.txt,
      required this.edited,
      required this.isProtect});

  Map<String, dynamic> toJson() {
    return {
      fireConstants.noteId: id,
      fireConstants.title: title,
      fireConstants.txt: txt,
      fireConstants.editedAt: edited,
      fireConstants.isBiometricEnabled: isProtect,
    };
  }

  factory Note.fromDocument(DocumentSnapshot doc) {
    int noteId = 0;
    String title = "";
    String txt = "";
    String edited = "";
    bool isProtect = false;

    try {
      noteId = doc.get(fireConstants.noteId);
      title = doc.get(fireConstants.title);
      txt = doc.get(fireConstants.txt);
      edited = doc.get(fireConstants.editedAt);
      isProtect = doc.get(fireConstants.isBiometricEnabled);
    } on Exception catch (e) {
      print(e);
    }

    return Note(
        id: noteId,
        title: title,
        txt: txt,
        edited: edited,
        isProtect: isProtect);
  }

  factory Note.fromJSON(Map<String, dynamic> json) {
    return Note(
        id: json[fireConstants.noteId] ?? 0,
        title: json[fireConstants.title] ?? "",
        txt: json[fireConstants.txt] ?? "",
        edited: json[fireConstants.editedAt] ?? "",
        isProtect: json[fireConstants.isBiometricEnabled] ?? false);
  }

}
