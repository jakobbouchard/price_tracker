import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';

enum CredPlatform { google, twitter }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Gets the FCM token, save it to the database for current user
  /// Also creates a high importance notification channel
  _configureFCM(User user) async {
    // Get the current user ID
    String uid = user.uid;

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens =
          _db.collection('users').doc(uid).collection('tokens').doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
      print('Saved token $fcmToken');
    }

    // Create the high importance notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'product_on_sale', // id
      'Tracked product on sale', // title
      'This channel is used when one of your tracked product goes on sale.', // description
      importance: Importance.max,
    );

    // Create the channel on the device
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<User> _handleExistsWithDiffCred(e) async {
    // The account already exists with a different credential
    String email = e.email;
    AuthCredential pendingCredential = e.credential;
    User user;

    // Fetch a list of what sign-in methods exist for the conflicting user
    List<String> userSignInMethods =
        await _auth.fetchSignInMethodsForEmail(email);

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

  Future<TwitterAuthCredential> _triggerTwitterAuth() async {
    // Create a TwitterLogin instance
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: 'O5uojX8kCERafME1bvVPRycqb',
      consumerSecret: 'jAU2Aat7ooRTSjRxsARGy2lx55ZUhKxNbhHLk15POZbgWN1JBa',
    );

    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await twitterLogin.authorize();

    // Get the Logged In session
    final TwitterSession twitterSession = loginResult.session;

    // Create a credential from the access token
    final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(
        accessToken: twitterSession.token, secret: twitterSession.secret);

    return twitterAuthCredential;
  }

  /// Notifies about changes to the user's sign-in state (such as sign-in or
  /// sign-out).
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // Signing in //

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
        platformCredential = await _triggerTwitterAuth();
        break;
    }

    // Once signed in, return the UserCredential
    try {
      final UserCredential credential =
          await _auth.signInWithCredential(platformCredential);
      print(
          'User signed in: ${credential.user.email}, uid: ${credential.user.uid}');
      _configureFCM(credential.user);
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
