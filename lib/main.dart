import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'home_page.dart'; // Import your home page
import 'login_page.dart'; // Import your login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Your App Name',
      initialRoute: '/login', // Specify initial route
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final user = settings.arguments as User; // Extract user argument
          return MaterialPageRoute(
            builder: (context) => HomePage(user: user), // Pass user to HomePage
          );
        }
        // Handle other routes if needed
      },
      routes: {
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while checking authentication state
        }
        if (snapshot.hasData) {
          return HomePage(user: snapshot.data!); // Navigate to home page if user is authenticated
        } else {
          return LoginPage(); // Navigate to login page if user is not authenticated
        }
      },
    );
  }
}
