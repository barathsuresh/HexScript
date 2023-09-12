import 'package:HexScript/constants/firestore_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDoc {
  String id;
  String nickName;
  String photoUrl;

  UserDoc({required this.id, required this.nickName, required this.photoUrl});

  Map<String, String> toJSON() { // converts the data to JSON Format
    return {
      fireConstants.id: id,
      fireConstants.nickname: nickName,
      fireConstants.photoUrl: photoUrl,
    };
  }

  factory UserDoc.fromDocument(DocumentSnapshot doc) { // used to fetch the values from the key value pair
    String id = "";
    String nickName = "";
    String photoUrl = "";

    try {
      id = doc.get(fireConstants.id);
      nickName = doc.get(fireConstants.nickname);
      photoUrl = doc.get(fireConstants.photoUrl);
    } on Exception catch (e) {
      print(e);
    }
    return UserDoc(id: id, nickName: nickName, photoUrl: photoUrl);
  }


}
