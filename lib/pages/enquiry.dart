import 'dart:convert';
import 'package:enquiry/models/user_detail_model.dart';
import 'package:enquiry/utils/user_account_management.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:enquiry/pages/view_enquiries.dart';

class EnquiryApproval extends StatefulWidget {
  const EnquiryApproval({super.key});

  @override
  State<EnquiryApproval> createState() => _EnquiryApprovalState();
}

class _EnquiryApprovalState extends State<EnquiryApproval>
    with SingleTickerProviderStateMixin {
  late UserDetail userDetail;

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
  }

  _loadUserDetail() async {
    userDetail = (await UserAccountManagement().getUserDetail())!;
  }

  Future<List<dynamic>> fetchEnquiries(String status) async {
    final completer = Completer<List<dynamic>>();
    Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.completeError('Timeout');
      }
    });

    final userDetail = await UserAccountManagement().getUserDetail();
    final userId = userDetail?.user.id.toString();

    final response = await http.get(
      Uri.parse(
          'https://macargotest.iosuite.org/api/v1/enquiry?status=$status'),
      headers: <String, String>{
        'user-id': userId!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      if (status == 'pending') {
        data =
            data.where((enquiry) => int.parse(enquiry['level']) == 1).toList();
      } else if (status == 'approved') {
        data =
            data.where((enquiry) => int.parse(enquiry['level']) >= 2).toList();
      }
      completer.complete(data);
    } else {
      completer.completeError('Error: ${response.body}');
    }

    return completer.future;
  }

  Widget _buildEnquiryList(String status) {
    return Theme(
      data: ThemeData(
        hintColor: const Color.fromARGB(255, 182, 6, 6),
      ),
      child: RefreshIndicator(
        color: const Color.fromARGB(255, 246, 37, 22),
        onRefresh: () => fetchEnquiries(status),
        child: FutureBuilder<List<dynamic>>(
          future: fetchEnquiries(status),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              // return Center(child: Text('Error: ${snapshot.error}'));
              // Display icon and text when there is an error
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/404.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'There is an Issue with the Network',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              // Display icon and text when no data is available
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/404.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Enquiries Loaded',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              List<dynamic> enquiryData = snapshot.data ?? [];
              return ListView.builder(
                itemCount: enquiryData.length,
                itemBuilder: (context, index) {
                  final enquiryItem = enquiryData[index];

                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewEnquiryPage1(
                            enquiry: enquiryItem,
                            userId: userDetail.user.id,
                          ),
                        ),
                      );

                      if (result == true) {
                        // Refresh the list of enquiries
                        setState(() {});
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0, right: 8.0),
                                  height: 40.0,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0),
                                    ),
                                    color: Color.fromARGB(255, 182, 6, 6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${enquiryItem['date']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 8.0,
                                  right: 8.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    height: 40.0,
                                    width: 150.0,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      color: Color.fromARGB(255, 223, 223, 223),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'REF NO : ${enquiryItem['client_inquiry_id']}',
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 182, 6, 6),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Table(
                                    columnWidths: const {
                                      0: FlexColumnWidth(1),
                                      1: FlexColumnWidth(2),
                                    },
                                    children: [
                                      TableRow(
                                        children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.0,
                                                  vertical: 1.0),
                                              child: Text(
                                                'Client:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0,
                                                      vertical: 1.0),
                                              child: Text(
                                                enquiryItem['client'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.0,
                                                  vertical: 2.0),
                                              child: Text(
                                                'Received:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0,
                                                      vertical: 2.0),
                                              child: Text(
                                                enquiryItem['received_by'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TableRow(
                                        children: [
                                          const TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.0,
                                                  vertical: 2.0),
                                              child: Text(
                                                'Cargo Type:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0,
                                                      vertical: 2.0),
                                              child: Text(
                                                enquiryItem['type'],
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                                color: Color.fromARGB(255, 182, 6, 6),
                              ),
                              child: const Center(
                                child: Text(
                                  "WAITING FOR APPROVAL",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enquiries',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 6, 6),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _buildEnquiryList('pending'), // Display only pending list
    );
  }
}
