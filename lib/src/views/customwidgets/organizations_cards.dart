import 'package:flutter/material.dart';
import 'package:univents/src/views/public/organization_details.dart';

class OrganizationCard extends StatelessWidget {
  final String acronym;
  final String banner;
  final String status;
  final String category;
  final String email;
  final String facebook;
  final String logo;
  final String mobile;
  final String name;
  final String uid;

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
    required this.uid,
  });

  factory OrganizationCard.fromMap(Map<String, dynamic> map) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      height: 300,
      width: 250,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewOrganization(
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
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image:
                            (logo != "")
                                ? NetworkImage(logo)
                                : const AssetImage('assets/default_image.png')
                                    as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  acronym,
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
    );
  }
}
