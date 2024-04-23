import 'package:enquiry/models/user_detail_model.dart';
import 'package:enquiry/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/user_account_management.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 182, 6, 6),
        title: const Center(
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FutureBuilder<UserDetail?>(
            future: UserAccountManagement().getUserDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userDetail = snapshot.data!;
                // Use userDetail here
                userDetail.user.username;
                userDetail.user.email;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/account.png'),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userDetail.user.username,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  userDetail.user.email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('api_token');
                          await prefs.remove('id');
                          await prefs.remove('username');
                          await prefs.remove('email');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LogInScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color.fromARGB(255, 182, 6, 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'LOGOUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              // return a loading indicator while waiting
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
