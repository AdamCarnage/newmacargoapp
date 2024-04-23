import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EnquiryForm extends StatefulWidget {
  const EnquiryForm({super.key});

  @override
  _EnquiryFormState createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<EnquiryForm> {
  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController conversationTypeController =
      TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController approvalChainModuleIdController =
      TextEditingController();

  String _submissionStatus = '';

  Future<void> fetchDataFromAPI() async {
    try {
      final response = await http.post(
        Uri.parse('http://macargotest.iosuite.org/api/v1/enquiry/store'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "data": {
            "client_enquiry": {
              "client_id": clientIdController.text,
              "conversation_type": conversationTypeController.text,
              "user_id": userIdController.text,
              "type": typeController.text,
              "approval_chain_module_id":
                  int.tryParse(approvalChainModuleIdController.text) ?? 0,
              "level": null
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _submissionStatus = 'Submission successful!';
        });
      } else {
        setState(() {
          _submissionStatus = 'Failed to submit: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _submissionStatus = 'Error submitting: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquiry Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: clientIdController,
              decoration: const InputDecoration(labelText: 'Client ID'),
            ),
            TextFormField(
              controller: conversationTypeController,
              decoration: const InputDecoration(labelText: 'Conversation Type'),
            ),
            TextFormField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextFormField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextFormField(
              controller: approvalChainModuleIdController,
              decoration:
                  const InputDecoration(labelText: 'Approval Chain Module ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (clientIdController.text.isEmpty ||
                    conversationTypeController.text.isEmpty ||
                    userIdController.text.isEmpty ||
                    typeController.text.isEmpty ||
                    approvalChainModuleIdController.text.isEmpty) {
                  setState(() {
                    _submissionStatus = 'All fields are required';
                  });
                } else {
                  fetchDataFromAPI();
                }
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 8.0),
            Text(
              _submissionStatus,
              style: TextStyle(
                  color: _submissionStatus.startsWith('Submission successful!')
                      ? Colors.green
                      : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
