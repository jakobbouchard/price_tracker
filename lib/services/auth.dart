import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum CredPlatform { google, twitter, apple, github }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> _handleExistsWithDiffCred(e) async {
    // The account already exists with a different credential
    String email = e.email;
    AuthCredential pendingCredential = e.credential;
    User user;

    // Fetch a list of what sign-in methods exist for the conflicting user
    List<String> userSignInMethods =
        await _auth.fetchSignInMethodsForEmail(email);

    // If the user has several sign-in methods,
    // the first method in the list will be the "recommended" method to use.
    if (userSignInMethods.first == 'password') {
      // Prompt the user to enter their password
      String password = '...';

      // Sign the user in to their account with the password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Link the pending credential with the existing account
      await userCredential.user.linkWithCredential(pendingCredential);

      // Success! Go back to your application flow
      user = userCredential.user;
    }

    if (userSignInMethods.first == 'google.com') {
      // Create a new Google credential
      GoogleAuthCredential googleAuthCredential = await _triggerGoogleAuth();

      // Sign the user in with the credential
      UserCredential userCredential =
          await _auth.signInWithCredential(googleAuthCredential);

      // Link the pending credential with the existing account
      await userCredential.user.linkWithCredential(pendingCredential);

      // Success! Go back to your application flow
      user = userCredential.user;
    }

    // Handle other OAuth providers...

    return user;
  }

  Future<GoogleAuthCredential> _triggerGoogleAuth() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential googleAuthCredential =
        GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return googleAuthCredential;
  }

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out).
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // Signing in //

  /// Attemps to sign in a user with the given email address and password.
  Future<User> signInWithEmail(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(
          'User signed in: ${credential.user.email}, uid: ${credential.user.uid}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return null;
    }
  }

  /// Attemps to sign in a user using a 3rd-party account.
  ///
  /// If the user doesn't have an account already, one will be created
  /// automatically.
  Future<User> signInWithCredential(CredPlatform platform) async {
    dynamic platformCredential;
    switch (platform) {
      case CredPlatform.google:
        platformCredential = await _triggerGoogleAuth();
        break;
      case CredPlatform.twitter:
        platformCredential = await _triggerGoogleAuth();
        break;
      case CredPlatform.apple:
        platformCredential = await _triggerGoogleAuth();
        break;
      case CredPlatform.github:
        platformCredential = await _triggerGoogleAuth();
        break;
    }

    // Once signed in, return the UserCredential
    try {
      final UserCredential credential =
          await _auth.signInWithCredential(platformCredential);
      print(
          'User signed in: ${credential.user.email}, uid: ${credential.user.uid}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return await _handleExistsWithDiffCred(e);
      } else {
        print('Failed with error code: ${e.code}');
        print(e.message);
        return null;
      }
    }
  }

  /// This function takes an email and a password as paramters and creates a
  /// user using the createUserWithEmailAndPassword function from Firebase Auth
  Future<User> registerWithEmail(String email, String password) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(
          'User registered: ${credential.user.email}, uid: ${credential.user.uid}');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return null;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
      return;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return null;
    }
  }
}
