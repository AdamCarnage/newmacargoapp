import 'package:flutter/material.dart';

class ViewNominationPage extends StatefulWidget {
  final Map<String, dynamic> nominationData;
  final int userId;

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

  @override
  void initState() {
    super.initState();
    _remarksController = TextEditingController();
  }

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Truck Nomination ID - ${widget.nominationData['client_inquiry_id']}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 245, 33, 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table for nomination details
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Field'),
                    // width: 100,
                  ),
                  DataColumn(
                    label: Text('Value'),
                    // width: 200,
                  ),
                ],
                rows: const <DataRow>[
                  // ... your DataRow widgets
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Action when the approve button is pressed
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
                      // Action when the reject button is pressed
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
