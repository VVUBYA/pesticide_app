import 'package:flutter/material.dart';
import 'package:csdatabase/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:csdatabase/home.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = FirebaseOptions(
    appId: '1:561438017487:android:25a54d463368ea9a56f4ba',
    apiKey: 'AIzaSyC65db59i51Oz9vrG2eL1JfPDeiGAM9FgA',
    projectId: 'pesticides-dd824',
    messagingSenderId: '561438017487',
  );

  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'PESTICIDE',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        //'/signup': (context) => SignupScreen(),
        //'/forgot_password': (context) => ForgotPasswordScreen(),
      },
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
    );
  }
}
