import 'package:enquiry/pages/dashboard.dart';
import 'package:enquiry/pages/loadin_screen.dart';
import 'package:enquiry/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/login': (context) => LogInScreen(),
        '/dashboard': (context) => MyDashboard(),
      },
      initialRoute: '/', // Set initial route to splash screen
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => LogInScreen(),
//         '/dashboard': (context) => const MyDashboard(),
//       },
//     );
//   }
// }
