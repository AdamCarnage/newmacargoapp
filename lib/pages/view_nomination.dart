import 'dart:convert';
import 'package:enquiry/models/user_detail_model.dart';
import 'package:enquiry/utils/user_account_management.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewNominationPage extends StatefulWidget {
  final Map<String, dynamic> nominationData;
  final String userId;

  const ViewNominationPage({
    super.key,
    required this.nominationData,
    required this.userId,
  });

  @override
  _ViewNominationPageState createState() => _ViewNominationPageState();
}

class _ViewNominationPageState extends State<ViewNominationPage> {
  late TextEditingController _remarksController;
  bool canApprove = false;
  late UserDetail userDetail;

  @override
  void initState() {
    super.initState();
    _loadUserDetail();
    canApprove = widget.nominationData['is_approve'] == 1;
    _remarksController = TextEditingController();
  }

  _loadUserDetail() async {
    userDetail = (await UserAccountManagement().getUserDetail())!;
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleData = widget.nominationData['vehicle'][0];
    final vehicleRegistrationNumber =
        vehicleData['vehicle_registration_number'];
    final trailerChassisNumber = vehicleData['trailer_chassis_number'];
    final driverName = vehicleData['driver_name'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nomination - ${widget.nominationData['id']}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF00072D),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'REF -${widget.nominationData['id']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 8), // Spacer
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Received On',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${widget.nominationData['created_date']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Received By',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        child: Text(
                          '${widget.nominationData['created_by']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Client',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${widget.nominationData['client']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), // Add some space between columns
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Type',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${widget.nominationData['type']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Color.fromARGB(255, 182, 6, 6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12.0),

              Center(
                child: Container(
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Waiting to be Approved by ${widget.nominationData['position']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color.fromARGB(255, 141, 141, 141),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 12.0),

              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Nomination Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.zero,
                child: const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),

              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Reg_no:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 69, 69, 69),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$vehicleRegistrationNumber',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 152, 152, 152),
                                    ),
                                  ),
                                  const SizedBox(width: 28),
                                  const Text(
                                    'Chassis_no:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 69, 69, 69),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$trailerChassisNumber',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 152, 152, 152),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$driverName',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      child: Divider(
                        height: 4,
                        thickness: 4,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18.0),

              SizedBox(
                height: 50.0, // Adjust height as needed
                width: 500.0, // Adjust width as needed
                child: TextField(
                  controller: _remarksController,
                  decoration: InputDecoration(
                    hintText: 'Remarks',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18.0),

              // Action Button
              SizedBox(
                height: 60.0, // Fixed height for the button
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                            actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                child: const Text(
                                  'Approve Nomination',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.green, // Green color for approve
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  approveNomination(); // Call the new function here
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text(
                                  'Reject Nomination',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 182, 6,
                                        6), // Black color for reject
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  rejectNomination(); // Keep the rejectEnquiry function as it is
                                },
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              child: const Text('Cancel',
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  )),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF00072D),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'ACTION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> approveNomination() async {
    if (_remarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide remarks')),
      );
      return;
    }

    final String apiUrl =
        'http://macargotest.iosuite.org/api/v1/loading-nomination/approve/${widget.nominationData['id']}';

    final userDetail = await UserAccountManagement().getUserDetail();
    final userId = userDetail?.user.id.toString();

    final Map<String, String> headers = {
      'user-id': userId!,
      // 'department-Id': '3',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'remarks': _remarksController.text,
      'response': 'APPROVED',
    };

    print('Sending JSON: ${jsonEncode(requestBody)}');

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = {
          'status': 8000,
          'message': 'SUCCESS',
          'data': {
            'remarks': _remarksController.text,
            'response': 'APPROVED',
          },
        };

        print('Response: ${jsonEncode(responseData)}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomination approved successfully')),
        );

        Navigator.pop(context, true);
      } else {
        print('Failed to approve Nomination: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to approve nomination')),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while sending the request')),
      );
    }
  }

  Future<void> rejectNomination() async {
    if (_remarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide remarks')),
      );
      return;
    }

    final String apiUrl =
        'http://macargotest.iosuite.org/api/v1/loading-nomination/approve/${widget.nominationData['id']}';

    final userDetail = await UserAccountManagement().getUserDetail();
    final userId = userDetail?.user.id.toString();

    final Map<String, String> headers = {
      'department-Id': '3',
      'user-id': userId!,
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'remarks': _remarksController.text,
      'response': 'REJECTED',
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = {
          'status': 8000,
          'message': 'SUCCESS',
          'data': {
            'remarks': _remarksController.text,
            'response': 'REJECTED',
          },
        };

        print('Response: ${jsonEncode(responseData)}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nomination rejected successfully')),
        );

        // Navigate back to the previous screen and pass the result
        Navigator.pop(context, true);
      } else {
        print('Failed to reject nomination: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reject nomination')),
        );
      }
    } catch (e) {
      print('Error sending request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while sending the request')),
      );
    }
  }
}
