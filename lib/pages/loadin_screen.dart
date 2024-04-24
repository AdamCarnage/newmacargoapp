import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enquiry/models/user_detail_model.dart';
import 'package:enquiry/pages/login.dart';
import 'package:enquiry/pages/ma_dashboard.dart'; // Import your dashboard screen
import 'package:enquiry/utils/user_account_management.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserDetail userDetail;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  _initializeApp() async {
    await Future.delayed(Duration(seconds: 2)); // Delay for 2 seconds

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apiToken = prefs.getString('api_token');

    if (apiToken != null && apiToken.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo (if you have one)
                Image.asset('assets/images/abood.png',
                    width: 120.0, height: 120.0),
                SizedBox(height: 20.0), // Add spacing
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/brand.png',
                width: MediaQuery.of(context).size.width *
                    0.5, // Adjust width as needed
              ),
            ),
          ),
        ],
      ),
    );
  }
}
