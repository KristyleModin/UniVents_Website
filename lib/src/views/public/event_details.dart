import 'package:flutter/material.dart';

class ViewEvents extends StatelessWidget {
  final String title;
  final String banner;
  final DateTime dateTimeStart;
  final String location;
  final String description;

  const ViewEvents(
      {super.key,
      required this.title,
      required this.banner,
      required this.dateTimeStart,
      required this.location,
      required this.description
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF182C8C),
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (banner != '')
            ClipRRect(
              child: Image.network(
                banner,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Text(
                //   dateTimeStart as String,
                //   style: const TextStyle(
                //     color: Colors.grey,
                //   ),
                // ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
    ),
    );
  }
}
