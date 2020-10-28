import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:price_tracker/constants.dart';
import 'package:price_tracker/services/auth.dart';
import 'package:price_tracker/screens/home/home.dart';
import 'package:price_tracker/screens/authentication/register.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _showSpinner = false;
  String _email;
  String _password;

  void _validateForm() async {
    dynamic user = await _auth.signInWithEmail(_email, _password);
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
      appBar: AppBar(
        title: Text('Sign in'),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Register'),
            onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                hasScrollBody: false,
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
                      decoration: authFieldDecoration.copyWith(
                        icon: Icon(Icons.alternate_email),
                        labelText: 'Email',
                        hintText: 'email@example.com',
                      ),
                    ),
                    SizedBox(height: 10.0),
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
                      decoration: authFieldDecoration.copyWith(
                        icon: Icon(Icons.lock_open),
                        labelText: 'Password',
                        hintText: '●●●●●●●●●●●●',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: _validateForm,
                        child: Text('Sign in'),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(height: 36),
                          ),
                        ),
                        Text("OR"),
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <SignInButton>[
                        SignInButton(
                          Buttons.Twitter,
                          mini: true,
                          onPressed: () async {
                            await _auth.signInWithTwitter();
                          },
                        ),
                        SignInButton(
                          Buttons.Apple,
                          mini: true,
                          onPressed: () async {
                            await _auth.signInWithApple();
                          },
                        ),
                        SignInButton(
                          Buttons.GitHub,
                          mini: true,
                          onPressed: () async {
                            await _auth.signInWithGitHub();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
