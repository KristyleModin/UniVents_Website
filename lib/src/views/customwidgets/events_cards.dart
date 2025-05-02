// ignore_for_file: deprecated_member_use, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:univents/src/views/public/event_details.dart';

class EventsCard extends StatefulWidget {
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
  final VoidCallback? onVisibilityChanged;
  final bool isVisible;

  const EventsCard({
    super.key,
    required this.title,
    required this.banner,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.location,
    required this.description,
    required this.status,
    required this.orgUid,
    required this.tags,
    required this.type,
    required this.eventRef,
    this.onVisibilityChanged,
    required this.isVisible,
  });

  factory EventsCard.fromMap(
    Map<String, dynamic> map,
    DocumentReference eventRef, {
    VoidCallback? onVisibilityChanged,
  }) {
    final Timestamp startTimestamp = map['datetimestart'];
    final Timestamp endTimestamp = map['datetimeend'];

    return EventsCard(
      title: map['title'] ?? '',
      banner: map['banner'] ?? '',
      dateTimeStart: startTimestamp.toDate(),
      dateTimeEnd: endTimestamp.toDate(),
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'upcoming',
      orgUid: map['orguid'],
      tags: map['tags'] ?? '',
      type: map['type'] ?? '',
      eventRef: eventRef,
      isVisible: map['isVisible'] ?? true,
      onVisibilityChanged: onVisibilityChanged,
    );
  }

  @override
  State<EventsCard> createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  late bool _isVisible;
  String? _orgName;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.isVisible;
    fetchOrgName();
  }

  Future<void> fetchOrgName() async {
    try {
      final docSnapshot = await widget.orgUid.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _orgName = data['name'] ?? 'Unknown Org';
        });
      } else {
        setState(() {
          _orgName = 'Unknown Org';
        });
      }
    } catch (e) {
      setState(() {
        _orgName = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String month = DateFormat('MMM').format(widget.dateTimeStart);
    final String day = DateFormat('dd').format(widget.dateTimeStart);

    const int maxCharsTitle = 18;
    const int maxCharsLocation = 20;

    final String partialTitle =
        widget.title.length > maxCharsTitle
            ? '${widget.title.substring(0, maxCharsTitle)}...'
            : widget.title;

    final String partialLocation =
        widget.location.length > maxCharsLocation
            ? '${widget.location.substring(0, maxCharsLocation)}...'
            : widget.location;

    return Opacity(
      opacity: _isVisible ? 1.0 : 0.4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        height: 320,
        width: 250,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ViewEvents(
                      title: widget.title,
                      banner: widget.banner,
                      dateTimeStart: widget.dateTimeStart,
                      dateTimeEnd: widget.dateTimeEnd,
                      location: widget.location,
                      description: widget.description,
                      status: widget.status,
                      orgUid: widget.orgUid,
                      tags: widget.tags,
                      type: widget.type,
                      eventRef: widget.eventRef,
                    ),
              ),
            );
          },
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
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image:
                                (widget.banner != "")
                                    ? NetworkImage(widget.banner)
                                    : const AssetImage(
                                          'assets/default_image.png',
                                        )
                                        as ImageProvider,
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
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () async {
                            final newVisibility = !_isVisible;

                            try {
                              await widget.eventRef.update({
                                'isVisible': newVisibility,
                              });
                              setState(() {
                                _isVisible = newVisibility;
                              });
                              widget.onVisibilityChanged?.call();
                            } catch (e) {
                              print("Failed to update visibility: $e");
                            }
                          },
                          child: Card(
                            elevation: 0,
                            color: Colors.white.withOpacity(0.85),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                _isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                                color: Colors.black,
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
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (_orgName != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_rounded,
                          color: Colors.blueGrey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _orgName!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
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
        ),
      ),
    );
  }
}