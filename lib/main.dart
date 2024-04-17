import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // Import Firebase options
import './pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //runApp(const HomePage());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String _signInMessage = '';
  String email = ''; // Declare email variable
  String password = ''; // Declare password variable

  Future<void> _signInWithEmailAndPassword(String email, String password) async {
    setState(() {
      _isLoading = true;
      _signInMessage = ''; // Clear previous sign-in message
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        _isLoading = false;
        _signInMessage = 'Signed in successfully: ${userCredential.user!.uid}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _signInMessage = 'Failed to sign in: $e';
      });
    }
  }

  Future<void> _signUpWithEmailAndPassword(String email, String password) async {
    setState(() {
      _isLoading = true;
      _signInMessage = ''; // Clear previous sign-in message
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      setState(() {
        _isLoading = false;
        _signInMessage = 'Signed up successfully: ${userCredential.user!.uid}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _signInMessage = 'Failed to sign up: $e';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _signInMessage = ''; // Clear previous sign-in message
    });

    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
      setState(() {
        _isLoading = false;
        _signInMessage = 'Signed in with Google successfully: ${userCredential.user!.uid}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _signInMessage = 'Failed to sign in with Google: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Authentication Demo'),
        actions: [
          _auth.currentUser != null
              ? IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () async {
                    await _auth.signOut();
                    setState(() {
                      _signInMessage = 'Signed out successfully';
                    });
                  },
                )
              : Container(), // Hide sign-out button if not signed in
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // Navigate to sign-up page or implement sign-up functionality here
              // For simplicity, let's just show a dialog for sign-up
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Sign Up'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(labelText: 'Email'),
                            onChanged: (value) {
                              setState(() {
                                email = value; // Update email variable
                              });
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                password = value; // Update password variable
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : () => _signUpWithEmailAndPassword(email, password),
                        child: _isLoading
                            ? const CircularProgressIndicator() // Show loading indicator while signing up
                            : const Text('Sign Up'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter your email'),
                onChanged: (value) {
                  setState(() {
                    email = value; // Update email variable
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Enter your password'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value; // Update password variable
                  });
                },
              ),
              ElevatedButton(
                onPressed: _isLoading? null : () => _signInWithEmailAndPassword(email, password),
                child: _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator while signing in
                    : const Text('Sign in with email and password'),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _signInWithGoogle,
                child: _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator while signing in
                    : const Text(
                                'Sign in with Google',
                                style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 68, 34, 194)),
              ),
              const SizedBox(height: 20),
              Text(_signInMessage), // Display sign-in message
            ],
          ),
        ),
      ),
    );
  }
}
