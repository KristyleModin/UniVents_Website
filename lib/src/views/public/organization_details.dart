import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:univents/src/views/public/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/src/views/public/edit_organization.dart';

class ViewOrganization extends StatefulWidget {
  final String acronym;
  final String banner;
  final String status;
  final String category;
  final String email;
  final String facebook;
  final String logo;
  final String mobile;
  final String name;
  final String uid;

  const ViewOrganization({
    super.key,
    required this.acronym,
    required this.banner,
    required this.status,
    required this.category,
    required this.email,
    required this.facebook,
    required this.logo,
    required this.mobile,
    required this.name,
    required this.uid,
  });

  @override
  State<ViewOrganization> createState() => _ViewOrganizationState();
}

class _ViewOrganizationState extends State<ViewOrganization> {
  // Function to delete organization
  Future<void> deleteOrganization(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('organizations').doc(uid).delete();
    } catch (e) {
      print("Error deleting organization: $e");
    }
  }

  // Function to show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('This action will permanently delete this organization.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await deleteOrganization(uid);
                Navigator.of(context).pop();  // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Organization deleted successfully!')),
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                  (route) => false, // Removes all previous routes
                );
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

Future<List<Map<String, dynamic>>> fetchEvents() async {
  if (widget.uid.isEmpty) {
    print(widget.name);
    print("UID is empty, skipping event fetch.");
    return [];
  }

  final eventsSnapshot = await FirebaseFirestore.instance
      .collection('events')
      .where('orguid', isEqualTo: FirebaseFirestore.instance.collection('organizations').doc(widget.uid))
      .get();

  List<Map<String, dynamic>> eventList = [];

  for (var doc in eventsSnapshot.docs) {
    final data = doc.data();
    eventList.add({
      'title': data['title'] ?? '',
      'datetimestart': data['datetimestart'] ?? '',
      'datetimeend': data['datetimeend'] ?? '',
      'status': data['status'] ?? '',
    });
  }

  return eventList;
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic banner height based on screen size
    double bannerHeight = screenHeight * 0.5;
    if (screenWidth < 600) {
      bannerHeight = screenHeight * 0.25;
    } else if (screenWidth < 900) {
      bannerHeight = screenHeight * 0.35;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Organization Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF182C8C),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Organization',
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditOrganization(
                    acronym: widget.acronym,
                    banner: widget.banner,
                    status: widget.status,
                    category: widget.category,
                    email: widget.email,
                    facebook: widget.facebook,
                    logo: widget.logo,
                    mobile: widget.mobile,
                    name: widget.name,
                    uid: widget.uid,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Delete Organization',
            onPressed: () async {
              _showDeleteConfirmation(context, widget.uid);  // Show confirmation dialog
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.banner != '')
              ClipRRect(
                child: Image.network(
                  widget.banner,
                  width: double.infinity,
                  height: bannerHeight,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.logo,
                          width: screenWidth < 600
                              ? 100
                              : screenWidth < 900
                                  ? 150
                                  : 200,
                          height: screenWidth < 600
                              ? 100
                              : screenWidth < 900
                                  ? 150
                                  : 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        height: screenHeight < 600
                            ? 100
                            : screenHeight < 900
                                ? 150
                                : 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.acronym,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(" (", style: TextStyle(fontSize: 24)),
                                Text(widget.category, style: TextStyle(fontSize: 24)),
                                Text(")", style: TextStyle(fontSize: 24)),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: Text(
                                widget.status,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email, size: 20),
                          Text(
                            " Email: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(widget.email, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.facebook, size: 20),
                          Text(
                            " Facebook: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(widget.facebook, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 20),
                          Text(
                            " Mobile Number: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(widget.mobile, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  const Text(
                    "Events",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No events yet.');
                      }

                      final events = snapshot.data!;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 16,
                          columns: const [
                            DataColumn(label: Text('Title')),
                            DataColumn(label: Text('Start Date & Time')),
                            DataColumn(label: Text('End Date & Time')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: events.map((event) {
                            return DataRow(cells: [
                              DataCell(Text(event['title'])),
                              DataCell(Text(
                                event['datetimestart'] is Timestamp
                                    ? DateFormat.yMd().add_jm().format((event['datetimestart'] as Timestamp).toDate())
                                    : event['datetimestart'].toString(),
                              )),
                              DataCell(Text(
                                event['datetimeend'] is Timestamp
                                    ? DateFormat.yMd().add_jm().format((event['datetimeend'] as Timestamp).toDate())
                                    : event['datetimeend'].toString(),
                              )),
                              DataCell(Text(event['status'])),
                            ]);
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


} 

  