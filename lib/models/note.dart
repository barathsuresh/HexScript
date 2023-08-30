import 'package:intl/intl.dart';

class Note{
  int id;
  String title;
  String txt;
  String edited;
  bool isProtect;
  Note({required this.id,required this.title,required this.txt,required this.edited,required this.isProtect});
}