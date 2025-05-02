import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:univents/src/views/customwidgets/events_cards.dart';

class ViewAllEventsPage extends StatefulWidget {
  const ViewAllEventsPage({super.key, required List<DashboardCard> events});

  @override
  State<ViewAllEventsPage> createState() => _ViewAllEventsPageState();
}

class _ViewAllEventsPageState extends State<ViewAllEventsPage> {
  late Future<List<DashboardCard>> _futureCards;

  @override
  void initState() {
    super.initState();
    _futureCards = fetchAllDashboardCards();
  }

  Future<List<DashboardCard>> fetchAllDashboardCards() async {
    final snapshot = await FirebaseFirestore.instance.collection('events').get();
    return snapshot.docs.map((doc) => DashboardCard.fromMap(doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Events",
          style: TextStyle(
            color: Colors.white,
          ),
          ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF182C8C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<DashboardCard>>(
          future: _futureCards,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No events found.'));
            } else {
              final events = snapshot.data!;
              return SingleChildScrollView(
                child: Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: events,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
