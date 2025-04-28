import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String banner;
  final DateTime dateTimeStart;
  final String location;

  const DashboardCard({
    super.key,
    required this.title,
    required this.banner,
    required this.dateTimeStart,
    required this.location,
  });

  factory DashboardCard.fromMap(Map<String, dynamic> map) {
    final Timestamp timestamp = map['datetimestart'];
    final DateTime dateTime = timestamp.toDate();
    final String location = map['location'] ?? '';
    final String title = map['title'] ?? '';
    final String banner = map['banner'] ?? '';

    return DashboardCard(
      title: title,
      banner: banner,
      dateTimeStart: dateTime,
      location: location,
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
      height: 260,
      width: 250,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        banner,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 140,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          height: 140,
                          width: double.infinity,
                          child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
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
                  const Icon(Icons.location_on_rounded, color: Colors.grey, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      partialLocation,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
