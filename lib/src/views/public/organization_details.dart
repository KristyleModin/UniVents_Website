import 'package:flutter/material.dart';
import 'package:univents/src/views/public/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/src/views/public/edit_organization.dart';

class ViewOrganization extends StatelessWidget {
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
                    acronym: acronym,
                    banner: banner,
                    status: status,
                    category: category,
                    email: email,
                    facebook: facebook,
                    logo: logo,
                    mobile: mobile,
                    name: name,
                    uid: uid,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Delete Organization',
            onPressed: () async {
              _showDeleteConfirmation(context, uid);  // Show confirmation dialog
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (banner != '')
              ClipRRect(
                child: Image.network(
                  banner,
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
                          logo,
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
                              name,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  acronym,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(" (", style: TextStyle(fontSize: 24)),
                                Text(category, style: TextStyle(fontSize: 24)),
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
                                status,
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
                          Text(email, style: TextStyle(fontSize: 20)),
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
                          Text(facebook, style: TextStyle(fontSize: 20)),
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
                          Text(mobile, style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
