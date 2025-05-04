import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:univents/src/services/auth.dart';
import 'package:univents/src/views/customwidgets/categories.dart';
import 'package:univents/src/views/customwidgets/events_card.dart';
import 'package:univents/src/views/customwidgets/organizations_cards.dart';
import 'package:univents/src/views/public/sign_In_Page.dart';
import 'package:univents/src/views/public/view_all_events_page.dart';
import 'package:univents/src/views/public/view_all_organizations_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<EventCard>> _futureEventCards;
  late Future<List<OrganizationCard>> _futureOrganizationCards;
  bool isDashboardExpanded = true;

  @override
  void initState() {
    super.initState();
    _futureEventCards = fetchEventCards();
    _futureOrganizationCards = fetchOrganizationCards();
  }

  Future<List<EventCard>> fetchEventCards() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('isVisible', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data();
      final eventRef = doc.reference;
      return EventCard.fromMap(
        data,
        eventRef,
        onVisibilityChanged: () {
          setState(() {
            _futureEventCards = fetchEventCards();
          });
        },
      );
    }).toList();
  }

  Future<List<OrganizationCard>> fetchOrganizationCards() async {
    final organizationSnapshot =
        await FirebaseFirestore.instance.collection('organizations').get();
    return organizationSnapshot.docs
        .map((doc) => OrganizationCard.fromMap(doc.data()))
        .toList();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(280.0),
        child: AppBar(
          backgroundColor: const Color(0xFF182C8C),
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: Stack(
            children: [
              Positioned(
                top: 30,
                right: 30,
                child: GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'lib/images/notification_bell_logo.png',
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Current Location",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFFCFCFC).withOpacity(0.8),
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Jacinto, Davao City",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 400,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2135A0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                              ),
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B6EF6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list, size: 20, color: Colors.white),
                            label: const Text(
                              "Filters",
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        CategoryButton(
                          icon: Icons.sports_basketball,
                          label: 'Sports',
                          color: const Color(0xFFEB5757),
                          onPressed: () {},
                        ),
                        SizedBox(width: 7),
                        CategoryButton(
                          icon: Icons.music_note,
                          label: 'Music',
                          color: const Color(0xFFF2994A),
                          onPressed: () {},
                        ),
                        SizedBox(width: 7),
                        CategoryButton(
                          icon: Icons.sports_esports,
                          label: 'ESports',
                          color: const Color(0xFF27AE60),
                          onPressed: () {},
                        ),
                        SizedBox(width: 7),
                        CategoryButton(
                          icon: Icons.brush,
                          label: 'Art',
                          color: const Color(0xFF2D9CDB),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("lib/images/profile.png"),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF979797),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey, thickness: 1, height: 20),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text(
                    "Main",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF979797),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: true,
                leading: Icon(Icons.grid_view_rounded, size: 24, color: Colors.black),
                title: const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 60),
                    title: Text('Organization'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 60),
                    title: Text('Manage Events'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewAllEventsPage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Upcoming Events",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF182C8C),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ViewAllEventsPage()),
                        );
                      },
                      child: const Text(
                        "View All",
                        style: TextStyle(
                          color: Color(0xFF182C8C),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<EventCard>>(
                  future: _futureEventCards,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No events found.'));
                    } else {
                      final events = snapshot.data!;
                      final limitedEvents = events.take(10).toList(); // Limit to 10 events

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 280,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: limitedEvents.map((card) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: card,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<OrganizationCard>>(
                  future: _futureOrganizationCards,
                  builder: (context, organizationSnapshot) {
                    if (organizationSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (organizationSnapshot.hasError) {
                      return Center(child: Text('Error: ${organizationSnapshot.error}'));
                    } else if (!organizationSnapshot.hasData || organizationSnapshot.data!.isEmpty) {
                      return const Center(child: Text('No organizations found.'));
                    } else {
                      final oprganizations = organizationSnapshot.data!;
                      final limitedOrganizations = oprganizations.take(10).toList(); // Limit to 10 oprganizations

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Organizations",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF182C8C),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ViewAllOrganizationsPage(organizations: [],)),
                                  );
                                },
                                child: const Text(
                                  "View All",
                                  style: TextStyle(
                                    color: Color(0xFF182C8C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 280,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: limitedOrganizations.map((card) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: card,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              final user = await signOut();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Signed out successfully!")),
                              );
                              if (!mounted) return; // Add this to prevent errors after async
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignInPage()),
                              );
                            },
                            child: const Text('Sign Out'),
                          ),
                        ],
                            );
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


