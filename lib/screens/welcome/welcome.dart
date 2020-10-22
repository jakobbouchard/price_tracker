import 'package:flutter/material.dart';
import 'package:Price_Tracker/screens/login/login.dart';
import 'package:Price_Tracker/screens/register/register.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  // if (_formKey.currentState.validate()) {
                  //   // Process data.
                  // }
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  // if (_formKey.currentState.validate()) {
                  //   // Process data.
                  // }
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
