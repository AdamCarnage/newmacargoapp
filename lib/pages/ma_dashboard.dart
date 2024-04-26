import 'dart:convert';
import 'dart:io';
import 'package:enquiry/pages/enquiry.dart';
import 'package:enquiry/pages/login.dart';
import 'package:enquiry/pages/nomination.dart';
import 'package:enquiry/utils/user_account_management.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_detail_model.dart';

class ma_dashboard extends StatefulWidget {
  const ma_dashboard({super.key});

  @override
  State<ma_dashboard> createState() => _ma_dashboardState();
}

class _ma_dashboardState extends State<ma_dashboard> {
  late Future<int> _enquiryCount;
  late UserDetail userDetail;
  late Future<int> _nominationCount;

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
    _enquiryCount = fetchEnquiryCount();
    _refreshEnquiryCount();
    _nominationCount = fetchNominationCount();
    _refreshNominationCount();
  }

  _refreshEnquiryCount() async {
    setState(() {
      _enquiryCount = fetchEnquiryCount();
    });
  }

  _refreshNominationCount() async {
    setState(() {
      _nominationCount = fetchNominationCount();
    });
  }

  _loadUserDetail() async {
    try {
      userDetail = (await UserAccountManagement().getUserDetail())!;
      print(userDetail.user.apiToken);
    } catch (e) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LogInScreen()));
    }
  }

  Future<int> fetchNominationCount() async {
    final userDetail = await UserAccountManagement().getUserDetail();
    final userId = userDetail?.user.id.toString();

    final response = await http.get(
      Uri.parse('https://macargotest.iosuite.org/api/v1/loading-nomination'),
      headers: <String, String>{
        'user-id': userId!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      int count = data.length;

      return count;
    } else {
      return 0;
    }
  }

  Future<int> fetchEnquiryCount() async {
    final userDetail = await UserAccountManagement().getUserDetail();
    final userId = userDetail?.user.id.toString();

    final response = await http.get(
      Uri.parse('https://macargotest.iosuite.org/api/v1/enquiry'),
      headers: <String, String>{
        'user-id': userId!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];

      int count = data.length;

      return count;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 182, 6, 6),
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/abood.png',
                  height: 30,
                  width: 30,
                ),
                PopupMenuButton<String>(
                  offset: Offset(0, 50), // Position the popup below the dots
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) async {
                    if (value == 'logout') {
                      // Remove user data from SharedPreferences
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('api_token');
                      await prefs.remove('id');
                      await prefs.remove('username');
                      await prefs.remove('email');

                      // Navigate to login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogInScreen()),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'logout',
                      child: ListTile(
                        leading: Icon(Icons.logout,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        title: Text('Logout'),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
                height: 5), // Add some space between initial row and title
            const Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          ],
        ),
        toolbarHeight: 100.0,
      ),
      body: FutureBuilder<int>(
        future: _enquiryCount,
        builder: (context, enquirySnapshot) {
          if (enquirySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 182, 6, 6),
                ),
              ),
            );
          } else if (enquirySnapshot.hasError) {
            if (enquirySnapshot.error is SocketException) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off,
                        size: 60, color: Color.fromARGB(255, 182, 6, 6)),
                    Text(
                      'Check Your Internet Connection!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: Text('Error: ${enquirySnapshot.error}'));
          } else {
            return FutureBuilder<int>(
              future: _nominationCount,
              builder: (context, nominationSnapshot) {
                if (nominationSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 182, 6, 6),
                      ),
                    ),
                  );
                } else if (nominationSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${nominationSnapshot.error}'));
                } else {
                  return DashboardContent(
                    size: size,
                    enquiryCount: enquirySnapshot.data ?? 0,
                    nominationCount: nominationSnapshot.data ?? 0,
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({
    super.key,
    required this.size,
    this.enquiryCount,
    this.nominationCount,
  });

  final Size size;
  final int? enquiryCount;
  final int? nominationCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Debtors Container
              Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 182, 6, 6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Transform.scale(
                      scale: 0.7, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/images/credt.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  const Text(
                    'Debtors',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Creditors Container
              Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 182, 6, 6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Transform.scale(
                      scale: 0.7, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/images/debt.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  const Text(
                    'Creditors',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Allowance Container
              Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 182, 6, 6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Transform.scale(
                      scale: 0.7, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/images/allowance.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  const Text(
                    'Allowance',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              // Requisition Container
              Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 182, 6, 6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Transform.scale(
                      scale: 0.7, // Adjust the scale factor as needed
                      child: Image.asset(
                        'assets/images/requisition.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  const Text(
                    'Requisition',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Container(
        //   margin: EdgeInsets.zero,
        //   child: const Divider(
        //     height: 1,
        //     thickness: 1,
        //     color: Colors.grey,
        //   ),
        // ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Enquiry Container
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EnquiryApproval()),
                );
              },
              child: Container(
                width: size.width * 0.47,
                margin: EdgeInsets.all(size.width * 0.01),
                constraints: const BoxConstraints(minHeight: 100),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 182, 6, 6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: size.width * 0.27,
                              height: size.height * 0.12,
                              decoration: const BoxDecoration(),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.47,
                                    height: size.height * 0.06,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/images/enquiry.png',
                                            height: size.height * 0.07,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.2,
                          height: size.height * 0.07,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    // color: const Color(0xffC8EA00),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                                width: size.width * 0.07,
                                child: Center(
                                  child: Text(
                                    '${enquiryCount ?? 0}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                right: 6,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 182, 6, 6),
                                  radius: 11,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                          // backgroundColor: Color(0xffC8EA00),
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: size.width * 0.46,
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: const Text(
                        'Enquiry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Truck Nomination Container
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => truck_nomination()),
                );
              },
              child: Container(
                width: size.width * 0.47,
                margin: EdgeInsets.all(size.width * 0.01),
                constraints: const BoxConstraints(minHeight: 100),
                decoration: BoxDecoration(
                  color: const Color(0xFF00072D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: size.width * 0.27,
                              height: size.height * 0.12,
                              decoration: const BoxDecoration(),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.47,
                                    height: size.height * 0.07,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/images/nomination2.png',
                                            height: size.height * 0.08,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.2,
                          height: size.height * 0.07,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    // color: const Color(0xffC8EA00),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                                width: size.width * 0.07,
                                child: Center(
                                  child: Text(
                                    '${nominationCount ?? 0}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                right: 6,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF00072D),
                                  radius: 11,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                          // backgroundColor: Color(0xffC8EA00),
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: size.width * 0.46,
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: const Text(
                        'Nomination',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // row for the pipeline container
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Enquiry Container
            GestureDetector(
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const EnquiryApproval()),
              //   );
              // },
              child: Container(
                width: size.width * 0.47,
                margin: EdgeInsets.all(size.width * 0.01),
                constraints: const BoxConstraints(minHeight: 100),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 1, 129, 175),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: size.width * 0.27,
                              height: size.height * 0.12,
                              decoration: const BoxDecoration(),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.47,
                                    height: size.height * 0.06,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/images/pipeline.png',
                                            height: size.height * 0.09,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.2,
                          height: size.height * 0.07,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                                width: size.width * 0.07,
                                child: Center(
                                  child: Text(
                                    '0',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                right: 6,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 1, 129, 175),
                                  radius: 11,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: size.width * 0.46,
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: const Text(
                        'Pipeline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Driver Ammendment Container
            GestureDetector(
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => truck_nomination()),
              //   );
              // },
              child: Container(
                width: size.width * 0.47,
                margin: EdgeInsets.all(size.width * 0.01),
                constraints: const BoxConstraints(minHeight: 100),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 211, 46, 0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: size.width * 0.27,
                              height: size.height * 0.12,
                              decoration: const BoxDecoration(),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.47,
                                    height: size.height * 0.07,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            'assets/images/amend.png',
                                            height: size.height * 0.08,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: size.width * 0.2,
                          height: size.height * 0.07,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    // color: const Color(0xffC8EA00),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                                width: size.width * 0.07,
                                child: Center(
                                  child: Text(
                                    '0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: 0,
                                right: 6,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 211, 46, 0),
                                  radius: 11,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: size.width * 0.46,
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: const Text(
                        'Driver Amendment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
