import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShelterDetailsPage extends StatelessWidget {
  final String name;
  final String shelter;
  final String description;
  final int bikesAvailable;
  final int scootersAvailable;
  final String image;

  const ShelterDetailsPage({
    Key? key,
    required this.name,
    required this.shelter,
    required this.description,
    required this.bikesAvailable,
    required this.scootersAvailable,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 163, 41, 41),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: 350.0,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  shelter,
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_bike, color: Color.fromARGB(255, 163, 41, 41)),
                  title: const Text('Bikes available'),
                  trailing: Text(
                    '$bikesAvailable',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.electric_scooter, color: Color.fromARGB(255, 163, 41, 41)),
                  title: const Text('Scooters available'),
                  trailing: Text(
                    '$scootersAvailable',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
