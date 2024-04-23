import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoadNominationForm extends StatefulWidget {
  const LoadNominationForm({super.key});

  @override
  _LoadNominationFormState createState() => _LoadNominationFormState();
}

class _LoadNominationFormState extends State<LoadNominationForm> {
  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController loadingTypeController = TextEditingController();
  final TextEditingController approvalChainModuleIdController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String _submissionStatus = '';

  Future<void> fetchDataFromAPI() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://macargotest.iosuite.org/api/v1/truck-nomination/store'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "data": {
            "loading_nomination": {
              "client_id": clientIdController.text,
              "type": typeController.text,
              "user_id": userIdController.text,
              "loading_type": loadingTypeController.text,
              "approval_chain_module_id":
                  int.tryParse(approvalChainModuleIdController.text) ?? 0,
              "level": null,
              "description": descriptionController.text
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
        title: const Text('Load Nomination Form'),
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
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextFormField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextFormField(
              controller: loadingTypeController,
              decoration: const InputDecoration(labelText: 'Loading Type'),
            ),
            TextFormField(
              controller: approvalChainModuleIdController,
              decoration:
                  const InputDecoration(labelText: 'Approval Chain Module ID'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (clientIdController.text.isEmpty ||
                    typeController.text.isEmpty ||
                    userIdController.text.isEmpty ||
                    loadingTypeController.text.isEmpty ||
                    approvalChainModuleIdController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
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
