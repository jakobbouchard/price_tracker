import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:price_tracker/services/auth.dart';
import 'package:price_tracker/screens/home/home.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();

  Future _loginWithThirdParty(CredPlatform platform) async {
    dynamic user = await _auth.signInWithCredential(platform);

    if (user != null) {
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
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Price Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 50.0),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  await _loginWithThirdParty(CredPlatform.google);
                },
              ),
              SignInButton(
                Buttons.Twitter,
                onPressed: () async {
                  await _loginWithThirdParty(CredPlatform.twitter);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
