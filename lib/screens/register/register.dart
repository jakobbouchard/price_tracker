import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Price_Tracker/screens/home/home.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;
  String _email;
  String _password;

  void _validateForm() {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    if (_formKey.currentState.validate()) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.id,
        ModalRoute.withName(HomeScreen.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.alternate_email),
                    hintText: 'Enter your email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    _email = value;
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock_open),
                    hintText: 'Enter your password',
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _validateForm,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    _password = value;
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: _validateForm,
                    child: Text('Register'),
                  ),
                ),
                SignInButton(
                  Buttons.Email,
                  mini: false,
                  onPressed: () {},
                ),
                SignInButton(
                  Buttons.Google,
                  mini: false,
                  onPressed: () {},
                ),
                SignInButton(
                  Buttons.Twitter,
                  mini: false,
                  onPressed: () {},
                ),
                SignInButton(
                  Buttons.Apple,
                  mini: false,
                  onPressed: () {},
                ),
                SignInButton(
                  Buttons.GitHub,
                  mini: false,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
