import 'package:flutter/material.dart';
import 'package:univents/src/views/customwidgets/categories.dart';
import 'package:univents/src/views/customwidgets/dashboard_cards.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                  onTap: () {
                    // ACTION
                  },
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
                            onPressed: () {
                              // ACTION
                            },
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
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upcoming Events",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF182C8C),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  DashboardCard(
                    title: "Basketball Tournament",
                    banner: "https://images.unsplash.com/photo-1579972665334-22c5bdf7a6c8",
                    dateTimeStart: DateTime.now().add(const Duration(days: 3)),
                    location: "Jacinto Gym",
                  ),
                  DashboardCard(
                    title: "Music Festival",
                    banner: "https://images.unsplash.com/photo-1508970707-db1e1a0f9b1b",
                    dateTimeStart: DateTime.now().add(const Duration(days: 5)),
                    location: "People's Park",
                  ),
                  DashboardCard(
                    title: "Art Exhibit",
                    banner: "https://images.unsplash.com/photo-1529107386315-e1a2ed48a620",
                    dateTimeStart: DateTime.now().add(const Duration(days: 7)),
                    location: "Museo Dabawenyo",
                  ),
                  DashboardCard(
                    title: "E-Sports Finals",
                    banner: "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61",
                    dateTimeStart: DateTime.now().add(const Duration(days: 10)),
                    location: "Lanang Premier Center",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
 // Empty body since categories are now inside appbar
    );
  }
}
