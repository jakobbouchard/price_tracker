import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Price_Tracker/views/welcome/welcome.dart';
import 'package:Price_Tracker/views/login/login.dart';
import 'package:Price_Tracker/views/register/register.dart';
import 'package:Price_Tracker/views/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PriceTracker());
}

class PriceTracker extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          final _auth = FirebaseAuth.instance;
          return MaterialApp(
            title: 'Price Tracker',
            theme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute:
                _auth.currentUser == null ? WelcomeScreen.id : HomeScreen.id,
            routes: {
              WelcomeScreen.id: (context) => WelcomeScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              HomeScreen.id: (context) => HomeScreen(title: 'Home'),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Tracker',
      home: Scaffold(
        body: Center(
          child: Text(
            'Something went wrong, please try again in a little bit.',
          ),
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Tracker',
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
