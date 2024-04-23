import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewEnquiryPage extends StatefulWidget {
  final Map<String, dynamic> enquiry;
  final int userId;

  const ViewEnquiryPage({super.key, required this.enquiry, required this.userId});

  @override
  _ViewEnquiryPageState createState() => _ViewEnquiryPageState();
}

class _ViewEnquiryPageState extends State<ViewEnquiryPage> {
  bool canApprove = false;
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
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
        backgroundColor: const Color.fromARGB(255, 245, 33, 18),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Client:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['client']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Date:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['date']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Received By:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['received_by']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Conv_Type:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['conversation_type']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Type:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['type']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'No_Trucks:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['number_of_trucks']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Loading City:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['loading_city']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Loading Point:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['loading_point_id']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Offloading City:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            '${widget.enquiry['offloading_city']}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                controller: remarksController,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (canApprove) ...[
                    ElevatedButton(
                      onPressed: () {
                        approveEnquiry();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(160, 40),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        rejectEnquiry();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(160, 40),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void approveEnquiry() async {
    if (remarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide remarks')),
      );
      return;
    }

    String url =
        'https://macargotest.iosuite.org/api/v1/enquiry/approve/${widget.enquiry['client_inquiry_id']}';

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user-id': widget.userId.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'remarks': [remarksController.text],
        'response': ['APPROVED'],
      }),
    );

    if (response.statusCode == 200) {
      print('Enquiry ${widget.enquiry['client_inquiry_id']} approved');
      Navigator.pop(context, true);
    } else {
      // Parse the error response to extract error messages
      Map<String, dynamic> errorResponse = json.decode(response.body);
      String errorMessage = errorResponse.values.first.join(', ');

      print('Failed to approve enquiry. Error: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  void rejectEnquiry() async {
    if (remarksController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide remarks')),
      );
      return;
    }

    String url =
        'https://macargotest.iosuite.org/api/v1/enquiry/approve/${widget.enquiry['client_inquiry_id']}';

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'user-id': widget.userId.toString(),
      },
      body: jsonEncode(<String, dynamic>{
        'remarks': [remarksController.text],
        'response': ['REJECTED'],
      }),
    );

    if (response.statusCode == 200) {
      print('Enquiry ${widget.enquiry['client_inquiry_id']} rejected');
      Navigator.pop(context, true);
    } else {
      // Parse the error response to extract error messages
      Map<String, dynamic> errorResponse = json.decode(response.body);
      String errorMessage = errorResponse.values.first.join(', ');

      print('Failed to reject enquiry. Error: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
}
