import 'package:HexScript/constants/firestore_constants.dart';
import 'package:HexScript/models/UserDocumentJsonFormatting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCancelled,
}

class AuthenticationProvider extends ChangeNotifier {
  late final GoogleSignIn googleSignIn;
  late final FirebaseFirestore firebaseFirestore;
  late final FirebaseAuth firebaseAuth;
  late CollectionReference _userCollection;
  final SharedPreferences preferences;
  Status _status = Status.uninitialized;
  Status get status => _status;

  // for the constructor
  AuthenticationProvider({
    required this.preferences,
    required this.firebaseFirestore,
    required this.firebaseAuth,
    required this.googleSignIn,
    CollectionReference? userCollection,
  }) : _userCollection =
            userCollection ?? FirebaseFirestore.instance.collection('users');

  String? getUserFirebaseId() {
    return preferences.getString(fireConstants.id);
  }

  Future<bool> isLoggedIn() async {
    // checks whether the user is already logged in or not
    bool isLoggedIn = await googleSignIn.isSignedIn();

    if (isLoggedIn &&
        preferences.getString(fireConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleSignIn() async {
    // handle signing in
    _status = Status.authenticating;
    notifyListeners(); // notify listeners that it is still authenticating

    GoogleSignInAccount? gUser = await googleSignIn.signIn();

    // after signing in
    if (gUser != null) {
      print("gUser Not Null");
      GoogleSignInAuthentication googleAuth = await gUser
          .authentication; // by doing this we can get access token and id token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ); // now we have the credential tokens for our user
      var temp = await firebaseAuth.signInWithCredential(
          credential); // now we finally completed the sign-in process
      User? firebaseUser = temp
          .user; // now we can access the users photoUrl, displayName, and many other details of the user account

      if (firebaseUser != null) {
        final QuerySnapshot res = await firebaseFirestore
            .collection(fireConstants.pathUserCollection)
            .where(fireConstants.id, isEqualTo: firebaseUser.uid)
            .get(); // this returns the current user document
        final List<DocumentSnapshot> documents = res.docs;
        if (documents.isEmpty) {
          // if there are no such user then create one in the database and then add to database
          firebaseFirestore
              .collection(fireConstants.pathUserCollection)
              .doc(firebaseUser.uid)
              .set({
            fireConstants.id: firebaseUser.uid,
            fireConstants.nickname: firebaseUser.displayName,
            fireConstants.photoUrl: firebaseUser.photoURL,
            fireConstants.createdAt:
                DateTime.now().microsecondsSinceEpoch.toString(),
          });

          // now updating our shared preferences
          await preferences.setString(
              fireConstants.createdAt, firebaseUser.uid);
          await preferences.setString(
              fireConstants.nickname, firebaseUser.displayName ?? "");
          await preferences.setString(
              fireConstants.photoUrl, firebaseUser.photoURL ?? "");
        } else {
          // existing user just fetching the first user since all ID are unique
          DocumentSnapshot snapshot = documents[0];
          UserDoc userDetails = UserDoc.fromDocument(
              snapshot); // getting the relevant details from our Document

          // updating our shared preferences
          await preferences.setString(fireConstants.id, userDetails.id);
          await preferences.setString(
              fireConstants.nickname, userDetails.nickName);
          await preferences.setString(
              fireConstants.photoUrl, userDetails.photoUrl);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCancelled;
      notifyListeners();
      return false;
    }
  }

  Future<void> clearHiveDatabase() async {
    final box = await Hive.openBox('note_database');
    await box.clear();
  }

  Future<void> handleSignOut() async {
    // handle signout
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await clearHiveDatabase();
  }

  Future<void> deleteUserAccount() async {
    try {
      final User? firebaseUser = firebaseAuth.currentUser;
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (firebaseUser != null) {
        await _userCollection.doc(firebaseUser.uid).delete();
        await firebaseUser.delete();
        await handleSignOut();
        sharedPreferences.clear();
        _status = Status.uninitialized;
        notifyListeners();
      }
    } catch (error) {
      // Handle any errors that occur during account deletion
      print("Error deleting user account: $error");
    }
  }
}
