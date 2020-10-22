import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:Price_Tracker/services/auth.dart';
import 'package:Price_Tracker/screens/home/home.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _showSpinner = false;
  String _email;
  String _password;

  void _validateForm() async {
    if (_formKey.currentState.validate()) {
      dynamic user = await _auth.registerWithEmail(_email, _password);
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
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value.isEmpty ? 'Please enter your email' : null,
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.alternate_email),
                  hintText: 'Enter your email',
                ),
              ),
              TextFormField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (value) => value.length < 6
                    ? 'Please enter a password longer than 5 characters'
                    : null,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                onFieldSubmitted: (_) => _validateForm,
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock_open),
                  hintText: 'Enter your password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _validateForm,
                  child: Text('Register'),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(height: 36),
                    ),
                  ),
                  Text("OR"),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(height: 36),
                    ),
                  ),
                ],
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  await _auth.signInWithGoogle();
                },
              ),
              SignInButton(
                Buttons.Twitter,
                onPressed: () async {
                  await _auth.signInWithTwitter();
                },
              ),
              SignInButton(
                Buttons.Apple,
                onPressed: () async {
                  await _auth.signInWithApple();
                },
              ),
              SignInButton(
                Buttons.GitHub,
                onPressed: () async {
                  await _auth.signInWithGitHub();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
