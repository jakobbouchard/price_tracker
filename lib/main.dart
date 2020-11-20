import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:price_tracker/services/auth.dart';
import 'package:price_tracker/screens/authentication/login.dart';
import 'package:price_tracker/screens/home/home.dart';

FirebaseAnalytics analytics;
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
          analytics = FirebaseAnalytics();
          if (kDebugMode) {
            // Force disable Crashlytics collection while doing every day development.
            // Temporarily toggle this to true if you want to test crash reporting in your app.
            FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
          } else {
            FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
          }
          FlutterError.onError =
              FirebaseCrashlytics.instance.recordFlutterError;

          return StreamProvider<User>.value(
            catchError: (_, __) => null,
            value: AuthService().user,
            child: MaterialApp(
              title: 'Price Tracker',
              theme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
              initialRoute: LoginScreen.id,
              routes: {
                LoginScreen.id: (context) => LoginScreen(),
                HomeScreen.id: (context) => HomeScreen(title: 'Price Tracker'),
              },
              debugShowCheckedModeBanner: false,
            ),
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
