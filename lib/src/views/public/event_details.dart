import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:univents/src/views/public/edit_event_page.dart';

class ViewEvents extends StatefulWidget {
  final String title;
  final String banner;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;
  final String location;
  final String description;
  final String status;
  final DocumentReference orgUid;
  final String tags;
  final String type;
  final DocumentReference eventRef;

  const ViewEvents({
    super.key,
    required this.title,
    required this.eventRef,
    required this.banner,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.location,
    required this.description,
    required this.status,
    required this.orgUid,
    required this.tags,
    required this.type,
  });

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  String? orgName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrganization();
  }

  Future<void> fetchOrganization() async {
    try {
      final doc = await widget.orgUid.get();
      if (doc.exists) {
        setState(() {
          orgName = doc['name'];
          isLoading = false;
        });
      } else {
        setState(() {
          orgName = "Unknown Organization";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        orgName = "Error loading organization";
        isLoading = false;
      });
    }
  }

 Future<List<Map<String, dynamic>>> fetchAttendees() async {
  final attendeesSnapshot = await FirebaseFirestore.instance
      .collection('attendees')
      .where('eventid', isEqualTo: widget.eventRef)
      .get();

  List<Map<String, dynamic>> attendeeList = [];

  for (var doc in attendeesSnapshot.docs) {
    final data = doc.data();
    final accountRef = data['accountid'] as DocumentReference;
    final accountSnapshot = await accountRef.get();

    if (accountSnapshot.exists) {
      final accountData = accountSnapshot.data() as Map<String, dynamic>;
      attendeeList.add({
        'firstname': accountData['firstname'] ?? '',
        'lastname': accountData['lastname'] ?? '',
        'email': accountData['email'] ?? 'Unknown',
        'timestamp': data['datetimestamp'] ?? '',
        'status': data['status'] ?? '',
      });
    }
  }

  return attendeeList;
}


  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM d, y h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Event Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF182C8C),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Event',
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditEventPage(
                    eventRef: widget.eventRef,
                    initialData: {
                      'title': widget.title,
                      'location': widget.location,
                      'description': widget.description,
                      'tags': widget.tags,
                      'status': widget.status,
                      'type': widget.type,
                      'dateTimeStart': widget.dateTimeStart,
                      'dateTimeEnd': widget.dateTimeEnd,
                    },
                  ),
                ),
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event updated successfully')),
                );
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Delete Event',
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Event'),
                  content: const Text('Are you sure you want to delete this event? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (shouldDelete == true) {
                try {
                  await widget.eventRef.delete();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event deleted successfully')),
                    );
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting event: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.banner.isNotEmpty)
              ClipRRect(
                child: Image.network(
                  widget.banner,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${dateFormat.format(widget.dateTimeStart)} - ${dateFormat.format(widget.dateTimeEnd)}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(widget.location, style: const TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Status: ${widget.status}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.confirmation_number_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Type: ${widget.type}", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.tag, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Flexible(child: Text(widget.tags, style: const TextStyle(color: Colors.grey))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_circle_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                isLoading
                    ? const Text("Loading organization...", style: TextStyle(color: Colors.grey))
                    : Text("Organizer: $orgName", style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(widget.description, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 24),
            const Text(
              "Attendees",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchAttendees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No attendees yet.');
                }

                final attendees = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Timestamp')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: attendees.map((attendee) {
                      return DataRow(cells: [
                        DataCell(Text('${attendee['firstname']} ${attendee['lastname']}')),
                        DataCell(Text(attendee['email'])),
                        DataCell(Text(
                          attendee['timestamp'] is Timestamp
                              ? DateFormat.yMd().add_jm().format((attendee['timestamp'] as Timestamp).toDate())
                              : attendee['timestamp'].toString(),
                        )),
                        DataCell(Text(attendee['status'])),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
