import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:univents/src/views/customwidgets/organizations_cards.dart';
import 'package:univents/src/views/public/create_organization.dart';
import 'package:univents/src/views/customwidgets/manage_button.dart';


class ViewAllOrganizationsPage extends StatefulWidget {
  const ViewAllOrganizationsPage({super.key, required List<OrganizationCard> organizations});

  @override
  State<ViewAllOrganizationsPage> createState() => _ViewAllOrganizationsPageState();
}

class _ViewAllOrganizationsPageState extends State<ViewAllOrganizationsPage> {
  late Future<List<OrganizationCard>> _futureOrganizationCards;

  @override
  void initState() {
    super.initState();
    _futureOrganizationCards = fetchAllOrganizationCards();
  }

  Future<List<OrganizationCard>> fetchAllOrganizationCards() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('organizations')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final orgRef = doc.reference;

      return OrganizationCard.fromMap(
        data,
        orgRef,
        onVisibilityChanged: () async {
          final newVisibility = !(data['isVisible'] ?? true);
          await orgRef.update({'isVisible': newVisibility});
          setState(() {
            _futureOrganizationCards = fetchAllOrganizationCards();
          });
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Organizations",
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
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<OrganizationCard>>(
          future: _futureOrganizationCards,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No organizations found.'));
            } else {
              final organizations = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  spacing: 15,
                  children: [
                    Wrap(
                      children: organizations,
                    ),
                  ],
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
            MaterialPageRoute(builder: (context) => const CreateOrganization()),
          ).then((_) {
            setState(() {
              _futureOrganizationCards = fetchAllOrganizationCards();
            });
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
