import 'package:cloud_firestore/cloud_firestore.dart';

class Shelter {
  final String name;
  final String location;
  final String description;
  final int bikesAvailable;
  final int scootersAvailable;
  String image;

  Shelter({
    required this.name,
    required this.location,
    required this.description,
    required this.bikesAvailable,
    required this.scootersAvailable,
    required this.image,
  });

  // Method to create Shelter object from Firestore DocumentSnapshot
  static Shelter fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Shelter(
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      bikesAvailable: data['bikesAvailable'] ?? 0,
      scootersAvailable: data['scootersAvailable'] ?? 0,
      image: data['image'] ?? '',
    );
  }
}
