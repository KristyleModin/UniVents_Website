import 'package:flutter/material.dart';
import 'package:univents/src/views/public/organization_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class OrganizationCard extends StatefulWidget {
  final String acronym;
  final String banner;
  final String status;
  final String category;
  final String email;
  final String facebook;
  final String logo;
  final String mobile;
  final String name;
  final VoidCallback? onVisibilityChanged;
  final DocumentReference eventRef;
  final String uid;
  final bool isVisible;

  const OrganizationCard({
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
    this.onVisibilityChanged,
    required this.eventRef,
    required this.uid,
    required this.isVisible,
  });

  factory OrganizationCard.fromMap(
    Map<String, dynamic> map,
    DocumentReference eventRef, {
    VoidCallback? onVisibilityChanged,
  }) {
    final String acronym = map['acronym'] ?? '';
    final String banner = map['banner'] ?? '';
    final String status = map['status'] ?? '';
    final String category = map['category'] ?? '';
    final String email = map['email'] ?? '';
    final String facebook = map['facebook'] ?? '';
    final String logo = map['logo'] ?? '';
    final String mobile = map['mobile'] ?? '';
    final String name = map['name'] ?? '';
    final String uid = map['uid'] ?? '';
    final bool isVisible = map['isVisible'] ?? true;

    return OrganizationCard(
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
      isVisible: isVisible,
      eventRef: eventRef,
      onVisibilityChanged: onVisibilityChanged,
    );
  }
  @override
  State<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<OrganizationCard> {
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.isVisible;
  }

  
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isVisible ? 1.0 : 0.4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        height: 300,
        width: 250,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewOrganization(
                  acronym: widget.acronym,
                  banner: widget.banner,
                  status: widget.status,
                  category: widget.category,
                  email: widget.email,
                  facebook: widget.facebook,
                  logo: widget.logo,
                  mobile: widget.mobile,
                  name: widget.name,
                  uid: widget.uid,
                )
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
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image:
                                    (widget.logo != "")
                                        ? NetworkImage(widget.logo)
                                        : const AssetImage('assets/default_image.png')
                                            as ImageProvider,
                                fit: BoxFit.cover,
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
                    widget.acronym,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

