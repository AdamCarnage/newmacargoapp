// import 'dart:convert';
// import 'package:enquiry/pages/view_nomination.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class truck_nomination extends StatefulWidget {
//   const truck_nomination({super.key});

//   @override
//   State<truck_nomination> createState() => _trucknominationState();
// }

// class _trucknominationState extends State<truck_nomination>
// // with SingleTickerProviderStateMixin { // Commented out to remove TabController
// {
//   // late TabController _tabController; // Commented out to remove TabController
//   int userId = 40; // Set the user ID here

//   @override
//   void initState() {
//     super.initState();
//     // _tabController = TabController(length: 2, vsync: this); // Commented out to remove TabController
//   }

//   Future<List<dynamic>> fetchNominations() async {
//     final response = await http.get(
//       Uri.parse(''),
//       headers: <String, String>{
//         'user-id': userId.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body)['data'];
//     } else {
//       throw Exception('Failed to load nominations');
//     }
//   }

//   Widget _buildNominationList(String status) {
//     return Theme(
//       data: ThemeData(
//         hintColor: Color.fromARGB(255, 246, 37, 22),
//       ),
//       child: RefreshIndicator(
//         color: Color.fromARGB(255, 246, 37, 22),
//         onRefresh: () => fetchNominations(),
//         child: FutureBuilder<List<dynamic>>(
//           future: fetchNominations(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: 40,
//                       width: 40,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 1,
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               List<dynamic> nominationData = snapshot.data ?? [];

//               // if (status == 'PENDING') { // Commented out to remove TabController
//               //   nominationData = nominationData
//               //       .where((item) => item['level'] == '1')
//               //       .toList();
//               // } else { // Commented out to remove TabController
//               //   nominationData = nominationData
//               //       .where((item) => int.parse(item['level']) >= 2)
//               //       .toList();
//               // }

//               return ListView.builder(
//                 itemCount: nominationData.length,
//                 itemBuilder: (context, index) {
//                   final nominationItem = nominationData[index];
//                   // bool isApproved = int.parse(nominationItem['level']) == 2;

//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ViewNominationPage(
//                             nominationData: nominationItem,
//                             userId: userId,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin:
//                           EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
//                       child: Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15.0),
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(8.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(15.0),
//                                   topRight: Radius.circular(15.0),
//                                 ),
//                                 color: Color(0xFF00072D),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     '${nominationItem['date']}',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     'REF NO : ${nominationItem['id']}',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Table(
//                                     columnWidths: {
//                                       0: FlexColumnWidth(1),
//                                       1: FlexColumnWidth(2),
//                                     },
//                                     children: [
//                                       TableRow(
//                                         children: [
//                                           TableCell(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2.0,
//                                                       vertical: 1.0),
//                                               child: Text(
//                                                 'Client:',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12.0,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           TableCell(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2.0,
//                                                       vertical: 1.0),
//                                               child: Text(
//                                                 '${nominationItem['client']}',
//                                                 style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 12.0,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       TableRow(
//                                         children: [
//                                           TableCell(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2.0,
//                                                       vertical: 2.0),
//                                               child: Text(
//                                                 'Loading Type:',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12.0,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           TableCell(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2.0,
//                                                       vertical: 2.0),
//                                               child: Text(
//                                                 '${nominationItem['loading_type']}',
//                                                 style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 12.0,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       TableRow(
//                                         children: [
//                                           TableCell(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2.0,
//                                                       vertical: 2.0),
//                                               child: Text(
//                                                 'Cargo Type:',
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 12.0,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           TableCell(
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 2.0,
//                                                       vertical: 2.0),
//                                               child: Text(
//                                                 '${nominationItem['type']}',
//                                                 style: TextStyle(
//                                                   color: Colors.grey,
//                                                   fontSize: 12.0,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding: EdgeInsets.all(8.0),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(15.0),
//                                   bottomRight: Radius.circular(15.0),
//                                 ),
//                                 color: Color(0xFF00072D),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "WAITING FOR APPROVAL",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight
//                                           .bold // Set text color to white
//                                       ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Nomination',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 245, 33, 18),
//         // bottom: TabBar(
//         //   controller: _tabController,
//         //   indicatorColor: Colors.white,
//         //   labelColor: Colors.white,
//         //   unselectedLabelColor: Colors.black,
//         //   tabs: [
//         //     Tab(
//         //       text: 'PENDING',
//         //       icon: Icon(Icons.access_time, color: Colors.white),
//         //     ),
//         //     Tab(
//         //       text: 'APPROVED',
//         //       icon: Icon(Icons.check, color: Colors.white),
//         //     ),
//         //   ],
//         // ),
//         iconTheme: IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       // body: TabBarView(
//       //   controller: _tabController,
//       //   children: [
//       //     _buildNominationList('PENDING'),
//       //     _buildNominationList('APPROVED'),
//       //   ],
//       // ),
//       body: _buildNominationList('PENDING'), // Display only pending list
//     );
//   }
// }
