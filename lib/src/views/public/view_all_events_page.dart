import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:univents/src/views/customwidgets/events_card.dart';
import 'package:univents/src/views/customwidgets/manage_button.dart';
import 'package:univents/src/views/public/create_event_page.dart';

class ViewAllEventsPage extends StatefulWidget {
  const ViewAllEventsPage({super.key});

  @override
  State<ViewAllEventsPage> createState() => _ViewAllEventsPageState();
}

class _ViewAllEventsPageState extends State<ViewAllEventsPage> {
  late Future<List<EventCard>> _futureEventsCards;

  @override
  void initState() {
    super.initState();
    _futureEventsCards = fetchAllEventCards();
  }

  Future<List<EventCard>> fetchAllEventCards() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final eventRef = doc.reference;

      return EventCard.fromMap(
        data,
        eventRef,
        onVisibilityChanged: () async {
          final newVisibility = !(data['isVisible'] ?? true);
          await eventRef.update({'isVisible': newVisibility});
          setState(() {
            _futureEventsCards = fetchAllEventCards();
          });
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Events", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF182C8C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<EventCard>>(
          future: _futureEventsCards,
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
                padding: const EdgeInsets.only(bottom: 100), // Prevents overlap with button
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
      floatingActionButton: ManageButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateEventPage()),
          ).then((_) {
            setState(() {
              _futureEventsCards = fetchAllEventCards(); // Refresh after returning
            });
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
