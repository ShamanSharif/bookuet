import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  String? _userUID;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get userUID => _userUID;
  String? get userName => _userName;

  logInUser() async {
    UserCredential userCredential = await signInWithGoogle();
    _isLoggedIn = true;
    _userUID = userCredential.user?.uid;
    _userName = userCredential.user?.displayName;
    notifyListeners();
  }

  logOutUser() async {
    auth.signOut();
    _isLoggedIn = false;
    _userUID = null;
    _userName = null;
    notifyListeners();
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return auth.signInWithCredential(credential);
  }
}
