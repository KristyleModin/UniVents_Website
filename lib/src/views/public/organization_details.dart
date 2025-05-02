import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define a dynamic banner height based on screen size
    double bannerHeight = screenHeight * 0.5; // 30% of screen height
    if (screenWidth < 600) {
      // If it's a phone, make it smaller
      bannerHeight = screenHeight * 0.25;
    } else if (screenWidth < 900) {
      // If it's a tablet, slightly larger
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
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          logo,
                          width:
                              screenWidth < 600
                                  ? 100 // small size for phones
                                  : screenWidth < 900
                                  ? 150 // medium size for tablets
                                  : 200, // larger for desktops
                          height:
                              screenHeight < 600
                                  ? 100
                                  : screenHeight < 900
                                  ? 150
                                  : 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20),
                      SizedBox(
                        height:
                            screenHeight < 600
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF182C8C),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Edit Organization',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
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
                        child: Text(
                          'Delete Organization',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
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
