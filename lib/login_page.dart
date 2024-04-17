import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '729272461010-g8ugbb2asksc67l7cv9a0jv94s3j814d.apps.googleusercontent.com',
  );

  String _email = '';
  String _password = '';
  String _errorMessage = '';

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      // Get the authenticated user
      User user = userCredential.user!;

      // Navigate to home page and replace current route with home page
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: user, // Pass user as an argument
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sign in: $e';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          final UserCredential userCredential = await _auth.signInWithCredential(credential);
          // Get the authenticated user
          User user = userCredential.user!;

          // Navigate to home page and replace current route with home page
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: user, // Pass user as an argument
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to sign in with Google';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to sign in with Google: $e';
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Sign In with Google'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
