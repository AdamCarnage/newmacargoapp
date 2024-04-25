// import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:enquiry/models/user_detail_model.dart'; // Import your dashboard screen
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
    _loadUserDetail();
  }

  _loadUserDetail() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      userDetail = (await UserAccountManagement().getUserDetail())!;
      // Navigate to dashboard if user token exists
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      // Navigate to login screen if user token doesn't exist
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
