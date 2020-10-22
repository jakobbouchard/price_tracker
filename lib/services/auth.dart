import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Streams the user using the authStateChanges function from Firebase Auth
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  /// Signing in ///

  // sign in email
  Future<User> signInWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in google
  Future<User> signInWithGoogle() async {
    try {
      UserCredential credential = await _auth.signInWithCredential(null);
      User user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in apple
  Future<User> signInWithApple() async {
    try {
      UserCredential credential = await _auth.signInWithCredential(null);
      User user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in twitter
  Future<User> signInWithTwitter() async {
    try {
      UserCredential credential = await _auth.signInWithCredential(null);
      User user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in github
  Future<User> signInWithGitHub() async {
    try {
      UserCredential credential = await _auth.signInWithCredential(null);
      User user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// This function takes an email and a password as paramters and creates a
  /// user using the createUserWithEmailAndPassword function from Firebase Auth
  Future<User> registerWithEmail(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = credential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Pretty self-explanatory
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
