import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ViewEnquiryPage1 extends StatefulWidget {
  final Map<String, dynamic> enquiry;
  final String userId;

  const ViewEnquiryPage1(
      {super.key, required this.enquiry, required this.userId});

  @override
  _ViewEnquiryPage1State createState() => _ViewEnquiryPage1State();
}

class _ViewEnquiryPage1State extends State<ViewEnquiryPage1> {
  bool canApprove = false;
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    canApprove = widget.enquiry['is_approve'] == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enquiry - ${widget.enquiry['client_inquiry_id']}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 182, 6, 6),
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
                        'REF -${widget.enquiry['client_inquiry_id']}',
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
                        '${widget.enquiry['date']}',
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
                          '${widget.enquiry['received_by']}',
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
                          'Enquiry by',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${widget.enquiry['client']}',
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
                          'Enquiry type',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${widget.enquiry['type']}',
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
                    'Waiting to be Approved by ${widget.enquiry['position']}',
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
                  'Enquiry Items',
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
                                    'From:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 69, 69, 69),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.enquiry['loading_city']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 152, 152, 152),
                                    ),
                                  ),
                                  const SizedBox(width: 28),
                                  const Text(
                                    'To:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 69, 69, 69),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.enquiry['offloading_city']}',
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
                                '${widget.enquiry['truck']}, ${widget.enquiry['product']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Rate/MT: ${widget.enquiry['rate_mt']} ${widget.enquiry['currency']};',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 73, 73, 73),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rate/Trip: ${widget.enquiry['rate_trip']} ${widget.enquiry['currency']};',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 73, 73, 73),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: Text(
                        //     '19200 USD',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 16,
                        //     ),
                        //   ),
                        // ),
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
                  controller: remarksController,
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
                                  'Approve Enquiry',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.green, // Green color for approve
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  approveEnquiry(); // Call the new function here
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: const Text(
                                  'Reject Enquiry',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 182, 6,
                                        6), // Black color for reject
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  rejectEnquiry(); // Keep the rejectEnquiry function as it is
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
                        backgroundColor: const Color.fromARGB(255, 182, 6, 6),
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

  Future<void> approveEnquiry() async {
    if (remarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide remarks')),
      );
      return;
    }

    final String apiUrl =
        'http://www.macargotest.iosuite.org/api/v1/enquiry/approve/${widget.enquiry['client_inquiry_id']}';

    final Map<String, String> headers = {
      'user-id': '40',
      'department-Id': '3',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'remarks': remarksController.text,
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
            'remarks': remarksController.text,
            'response': 'APPROVED',
          },
        };

        print('Response: ${jsonEncode(responseData)}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enquiry approved successfully')),
        );

        Navigator.pop(context, true);
      } else {
        print('Failed to approve enquiry: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to approve enquiry')),
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

  Future<void> rejectEnquiry() async {
    if (remarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide remarks')),
      );
      return;
    }

    final String apiUrl =
        'http://www.macargotest.iosuite.org/api/v1/enquiry/approve/${widget.enquiry['client_inquiry_id']}';

    final Map<String, String> headers = {
      'department-Id': '3',
      'user-id': '40',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'remarks': remarksController.text,
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
            'remarks': remarksController.text,
            'response': 'REJECTED',
          },
        };

        print('Response: ${jsonEncode(responseData)}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enquiry rejected successfully')),
        );

        // Navigate back to the previous screen and pass the result
        Navigator.pop(context, true);
      } else {
        print('Failed to reject enquiry: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reject enquiry')),
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
