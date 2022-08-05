import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInWindow extends ChangeNotifier {
  // got scopes from https://developers.google.com/classroom/guides/manage-classwork
  final googleSignIn = GoogleSignIn(scopes: [
    "https://www.googleapis.com/auth/classroom.coursework.me.readonly",
    "https://www.googleapis.com/auth/classroom.coursework.me",
    "https://www.googleapis.com/auth/classroom.courses",
    "https://www.googleapis.com/auth/classroom.courses.readonly"
  ]);

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  //Todo Major fucking bug?
  //https://www.youtube.com/watch?v=1k-gITZA9CI
  Future login() async {
    try {
      FirebaseAuth.instance.signOut();
    } catch (e) {}

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    _user = googleUser; // some stuff for change notifer
    // probably going to get rid of this soon....

    final auth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken, idToken: auth.idToken);

    final UserCredential currentUserCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    var currentUser = currentUserCredential.user;

    notifyListeners();

    final authHeaders = await googleUser.authHeaders;

    return {"user": googleUser, "authHeaders": authHeaders};
  }
}
