import 'dart:async';
import 'dart:convert';
import 'package:enquiry/models/user_detail_model.dart';
import 'package:enquiry/pages/view_nomination.dart';
import 'package:enquiry/utils/user_account_management.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class truck_nomination extends StatefulWidget {
  const truck_nomination({super.key});

  @override
  State<truck_nomination> createState() => _trucknominationState();
}

class _trucknominationState extends State<truck_nomination>
    with SingleTickerProviderStateMixin {
  late UserDetail userDetail; // Set the user ID here

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
  }

  _loadUserDetail() async {
    userDetail = (await UserAccountManagement().getUserDetail())!;
  }

  Future<List<dynamic>> fetchNominations(String status) async {
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
          'https://macargotest.iosuite.org/api/v1/loading-nomination?status=$status'),
      headers: <String, String>{
        'user-id': userId!,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      completer.complete(data);
    } else {
      completer.completeError('Error: ${response.body}');
    }

    return completer.future;
  }

  Widget _buildNominationList(String status) {
    return Theme(
      data: ThemeData(
        hintColor: const Color.fromARGB(255, 182, 6, 6),
      ),
      child: RefreshIndicator(
        color: const Color.fromARGB(255, 182, 6, 6),
        onRefresh: () => fetchNominations(status),
        child: FutureBuilder<List<dynamic>>(
          future: fetchNominations(status),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF00072D)),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<dynamic> nominationData = snapshot.data ?? [];

              return ListView.builder(
                itemCount: nominationData.length,
                itemBuilder: (context, index) {
                  final nominationItem = nominationData[index];
                  // bool isApproved = int.parse(nominationItem['level']) == 2;

                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewNominationPage(
                            nominationData: nominationItem,
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
                                    color: Color(0xFF00072D),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${nominationItem['created_date']}',
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
                                        'REF NO : ${nominationItem['id']}',
                                        style: const TextStyle(
                                          color: Color(0xFF00072D),
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
                                                nominationItem['client'],
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
                                                nominationItem['created_by'],
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
                                                nominationItem['type'],
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
                                color: Color(0xFF00072D),
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
        title: Text(
          'Nomination',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00072D),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _buildNominationList('PENDING'), // Display only pending list
    );
  }
}
