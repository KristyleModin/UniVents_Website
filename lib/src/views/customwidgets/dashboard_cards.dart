import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:univents/src/views/public/event_details.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String banner;
  final DateTime dateTimeStart;
  final String location;
  final String description;

  const DashboardCard({
    super.key,
    required this.title,
    required this.banner,
    required this.dateTimeStart,
    required this.location,
    required this.description,
  });

  factory DashboardCard.fromMap(Map<String, dynamic> map) {
    final Timestamp timestamp = map['datetimestart'];
    final DateTime dateTime = timestamp.toDate();
    final String location = map['location'] ?? '';
    final String title = map['title'] ?? '';
    final String banner = map['banner'] ?? '';
    final String description = map['description'] ?? '';

    print('Loading event: title=$title, banner=$banner');

    return DashboardCard(
      title: title,
      banner: banner,
      dateTimeStart: dateTime,
      location: location,
      description: description,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String month = DateFormat('MMM').format(dateTimeStart);
    final String day = DateFormat('dd').format(dateTimeStart);

    const int maxCharsTitle = 18;
    const int maxCharsLocation = 20;

    final String partialTitle = title.length > maxCharsTitle
        ? '${title.substring(0, maxCharsTitle)}...'
        : title;

    final String partialLocation = location.length > maxCharsLocation
        ? '${location.substring(0, maxCharsLocation)}...'
        : location;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 300,
      width: 250,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ViewEvents(
                title: title,
                description: description,
                location: location,
                dateTimeStart: dateTimeStart,
                banner: banner,
              )),
              );
              
        }, 
        child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: (banner != "")
                            ? NetworkImage(banner)
                            : const AssetImage('assets/default_image.png') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Opacity(
                      opacity: 0.85,
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          child: Column(
                            children: [
                              Text(
                                day,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                month,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                partialTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      partialLocation,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
